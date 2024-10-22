package al.animation;

import ec.IComponent;
import utils.Mathu;
import ec.PropertyComponent;
import al.animation.Animation;
import al.animation.AnimationTreeBuilder;
import ec.Component;
import ec.Entity;
import fu.PropStorage;

class AnimationTreeProp extends PropertyComponent<AnimationPlaceholder> {}

/**
    Represents an animated widget instance for handling its animation.
    There are following usecases:
    - common type for defining animation preset: certain Channels implementation type used as a key in ProspStorage.
    - channells property is an array of channels i.e. anything that can be animated independable. 
    - tree is a property holder of AnimationPlaceholder which used to put the widget animation into the parent animation tree (or handle it directly through setT()).
    If the animation preset defines tree description for the widget, the tree is also a target for mapping widget's channels to.
**/
interface Channels {
    var channels(default, null):Array<Float->Void>;
    var entity(get, null):Entity;
}

/**
    Listens for AnimationTreeProp changes and wires target channels with given animation tree according to rules defined in AnimationPreset for given target.
**/
class TreeMapperComponent extends Component {
    @:once var props:PropStorage<AnimationPreset>;
    var tree:AnimationTreeProp;
    var target:Channels;
    var alias:String;
    var unbinders:Array<Void->Void>;
    var preset:AnimationPreset;

    public function new(e, target, alias = "") {
        this.target = target;
        this.alias = alias;
        super(e);
        tree = AnimationTreeProp.getOrCreate(e);
    }

    override function init() {
        preset = props.get(AnimationPreset.getId(target, alias));
        if (preset == null)
            throw 'animation preset for $target not defined.';
        tree.onChange.listen(bind);
        bind();
    }

    function bind() {
        if (unbinders != null)
            unbind();
        if (tree.value != null)
            unbinders = bindToTree(tree.value, preset.mapping, target.channels);
    }

    function unbind() {
        if (unbinders == null)
            return;
        for (u in unbinders)
            u();
        unbinders = null;
    }

    public static function bindToTree(tree:AnimationPlaceholder, mapping:Array<Mapper>, channels:Array<Float->Void>) {
        return [
            for (i in 0...Mathu.min(channels.length, mapping.length))
                mapping[i](tree, channels[i])
        ];
    }
}

/**
    Creates animation tree according to description in animation preset for given target.
    After creation tree will assigned to AnimationTreeProp value.
**/
class TreeBuilderComponent extends Component {
    var tree:AnimationTreeProp;
    var target:Channels;
    var alias:String;
    @:once var props:PropStorage<AnimationPreset>;
    @:once var builder:AnimationTreeBuilder;

    public function new(e, target, alias = "") {
        this.target = target;
        this.alias = alias;
        super(e);
        tree = AnimationTreeProp.getOrCreate(e);
    }

    override function init() {
        var preset = props.get(AnimationPreset.getId(target, alias));
        tree.value = builder.build(preset.treeDesc);
    }
}

class TreeBinderComponent extends Component {
    @:once var props:PropStorage<AnimationPreset>;
    var target:Channels;
    var targetTree:AnimationTreeProp;
    var alias:String;
    var children:Array<Channels> = [];
    var preset:AnimationPreset;

    public function new(e, target, alias = "") {
        this.target = target;
        this.targetTree = AnimationTreeProp.getOrCreate(e);
        this.alias = alias;
        super(e);
    }

    override function init() {
        preset = props.get(AnimationPreset.getId(target, alias));
        targetTree.onChange.listen(onTree);
        if (targetTree.value != null)
            onTree();
    }

    function onTree() {
        for (ch in children)
            bindChild(ch);
    }

    public function addChild(aph:Channels) {
        children.push(aph);
        if (targetTree?.value != null)
            bindChild(aph);
    }

    function bindChild(child:Channels) {
        if (!_inited)
            return;
        if (targetTree.value == null)
            return;
        var selector = preset.childrenSelectors.get(AnimationPreset.getId(child, ""));
        var parentAph = selector(targetTree.value);
        // check / wait for child tree value
        var ac = parentAph.entity.getComponent(AnimContainer);
        var childTree = AnimationTreeProp.getOrCreate(child.entity);
        function addToCont() {
            if (childTree.value != null) {
                AnimationTreeBuilder.addChild(ac, childTree.value);
                ac.refresh();
                childTree.onChange.remove(addToCont);
            }
        }
        if (childTree.value != null)
            AnimationTreeBuilder.addChild(ac, childTree.value);
        else
            childTree.onChange.listen(addToCont);
    }

    function bindChildren() {}

    function unbindChildren() {}
}

typedef Selector = AnimationPlaceholder->AnimationPlaceholder;

/**
    Incapsulates the way to put given cahannel into given tree.
    The way may be:
    - look for child node by some description line path or name
    - create new node and bind into the tree
    - await for upstream tree by listening e.onContext to find place there by criteria like in - 1
**/
typedef Mapper = (AnimationPlaceholder, Float->Void) -> (Void->Void);

// typedef Binder = (AnimationPlaceholder, AnimationPlaceholder) -> (Void->Void);

/**
    Description of animation tree and a way of binding animation channels of a component to the tree.
    mapping is an array of functions which find place in animation tree to bind channel of given index to.
**/
class AnimationPreset {
    public var treeDesc(default, null):AnimationContainerRec;
    public var mapping(default, null):Array<Mapper> = [];
    public var childrenSelectors(default, null):Map<String, Selector> = new Map();

    public function new(descr) {
        this.treeDesc = descr;
    }

    public function addChildBinder<T>(childClass:Class<T>, alias:String, selector:Selector) {
        childrenSelectors.set(getId(childClass, alias), selector);
    }

    public static function getId(instance:Dynamic, alias = "") {
        return Entity.getComponentId(instance) + "_" + alias;
    }
}

class AnimationSlotSelectors {
    public static function pathSelector(path:Array<Int>, aph:AnimationPlaceholder) {
        return aph.entity.getGrandchild(path.copy()).getComponent(AnimationPlaceholder);
    }

    public static function pathMapper(path:Array<Int>, aph:AnimationPlaceholder, channel:Float->Void) {
        var targetAph = pathSelector(path, aph);
        targetAph.channels.push(channel);
        return () -> targetAph.channels.remove(channel);
    }

    public static function mapper(selector:Selector, aph:AnimationPlaceholder, channel:Float->Void) {
        var targetAph = selector(aph);
        targetAph.channels.push(channel);
        return () -> targetAph.channels.remove(channel);
    }

    public static function nameSelector(name:String, aph:AnimationPlaceholder) {
        return findFirstInside(aph.entity, e -> e.name == name)?.getComponent(AnimationPlaceholder);
    }

    public static function findFirstInside(e:Entity, matcher:Entity->Bool):Entity {
        if (matcher(e))
            return e;
        for (ch in e.getChildren()) {
            var r = findFirstInside(ch, matcher);
            if (r != null)
                return r;
        }
        return null;
    }

    public static function newChildSelector(aph:AnimationPlaceholder) {
        var c = aph.entity.getComponent(AnimContainer);
        if (c == null)
            return null;
        var aph = AnimationTreeBuilder.animationWidget(new Entity("auto-anim-child"), {});
        AnimationTreeBuilder.addChild(c, aph);
        return aph;
    }

    // не поддерживается случай, если селектор не смог найти места и нужно продолжать слушать контекст

    /**
        Looks for channel place to bind upward in the animation tree hierarcy.
        @param aph - main component animation tree.
        If aph has parent - it give a try to map instantly.
        If not - aph.entity.onContext listener added and waits until first AnimationPlaceholder appears upward in the hierarchy, then tries to map here.
    **/
    public static function parentMapper(aph:AnimationPlaceholder, selector, channel) {
        var parentAph = aph.entity.parent?.getComponentUpward(AnimationPlaceholder);
        if (parentAph != null) {
            return existingParentMapper(parentAph, selector, channel);
        } else {
            var parentAph:AnimationPlaceholder = null;
            var parentUnbinder = null;
            function onCtx(_) {
                parentAph = aph.entity.parent?.getComponentUpward(AnimationPlaceholder);
                if (parentAph == null)
                    return;
                aph.entity.onContext.remove(onCtx);
                parentUnbinder = existingParentMapper(parentAph, selector, channel);
            }

            aph.entity.onContext.listen(onCtx);
            function unbind() {
                aph.entity.onContext.remove(onCtx);
                if (parentUnbinder != null)
                    parentUnbinder();
            }
            return unbind;
        }
    }

    static function existingParentMapper(parentAph, selector, channel):Void->Void {
        var target:AnimationPlaceholder = selector(parentAph);
        target.channels.push(channel);
        return () -> target.channels.remove(channel);
    }
}
