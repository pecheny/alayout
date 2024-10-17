package al.animation;

import al.animation.Animation;
import al.animation.AnimationTreeBuilder;
import ec.Component;
import ec.CtxWatcher;
import ec.Entity;
import fu.PropStorage;

class TreeBindingComponent {
    var mappers:Array<Mapper>;
    var channels:Array<Float->Void>;
    var unbinders:Array<Void->Void>;

    public function new(mappers:Array<Mapper>, channels:Array<Float->Void>) {
        this.mappers = mappers;
        this.channels = channels;
    }

    public function bind(tree:AnimationPlaceholder) {
        unbinders = bindToTree(tree, mappers, channels);
    }

    public function unbind() {
        if (unbinders == null)
            return;
        for (u in unbinders)
            u();
        unbinders = null;
    }

    public static function bindToTree(tree:AnimationPlaceholder, mapping:Array<Mapper>, channels:Array<Float->Void>) {
        return [
            for (i in 0...channels.length)
                mapping[i](tree, channels[i])
        ];
    }
}

class AnimationTreeComponent extends Component {
    var tree(default, null):AnimationPlaceholder;
    var target:Channels;
    var alias:String;
    @:once var props:PropStorage<AnimationPreset>;
    @:once var builder:AnimationTreeBuilder;
    @:once var binder:TreeBindingComponent;

    public function new(e, target, alias = "") {
        this.target = target;
        this.alias = alias;
        super(e);
    }

    override function init() {
        var preset = props.get(getId(target, alias));
        tree = builder.build(preset.treeDesc);
        binder.bind(tree);
    }

    public function setTime(t):Void {
        if (_inited)
            tree.setTime(t);
    }

    public static function getId(instance:Dynamic, alias = "") {
        return Entity.getComponentId(instance) + "_" + alias;
    }
    
    public static function bindToTree(tree:AnimationPlaceholder, mapping:Array<Mapper>, channels:Array<Float->Void>) {
        for (i in 0...channels.length)
            mapping[i](tree, channels[i]);
    }
}

class AnimationTreeBinder implements CtxBinder {
    var container:AnimContainer;

    public function new(container) {
        this.container = container;
    }

    public function bind(e:Entity) {
        var acomp = e.getComponent(AnimationTreeComponent);
        if (acomp != null) {
            AnimationTreeBuilder.addChild(container, acomp.tree);
            container.refresh();
        }
    }

    public function unbind(e:Entity) {
        var acomp = e.getComponent(AnimationTreeComponent);
        if (acomp != null) {
            AnimationTreeBuilder.removeChild(container, acomp.tree);
            container.refresh();
        }
    }
}

typedef Selector = AnimationPlaceholder->AnimationPlaceholder;
typedef Mapper = (AnimationPlaceholder, Float->Void) -> Void;

/**
    Description of animation tree and a way of binding animation channels of a component to the tree.
    mapping is an array of functions which find place in animation tree to bind channel of given index to.
**/
class AnimationPreset {
    public var treeDesc(default, null):Dynamic; 
    public var mapping(default, null):Array<Mapper> = [];

    public function new(descr) {
        this.treeDesc = descr;
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
