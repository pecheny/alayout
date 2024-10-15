package al.animation;

import al.animation.Animation;
import al.animation.AnimationTreeBuilder;
import ec.Component;
import ec.CtxWatcher;
import ec.Entity;
import fu.PropStorage;

class AnimationTreeComponent extends Component {
    public var tree(default, null):AnimationPlaceholder; 

    var target:Channels;
    var alias:String;
    @:once var props:PropStorage<AnimationPreset>;
    @:once var builder:AnimationTreeBuilder;

    public function new(e, target, alias = "") {
        this.target = target;
        this.alias = alias;
        super(e);
    }

    override function init() {
        var preset = props.get(getId(target, alias));
        tree = builder.build(preset.treeDesc);
        bindToTree(tree, preset.mapping, target.channels);
        // new CtxWatcher(AnimationTreeBinder, entity);
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
        return aph.entity.getGrandchild(path).getComponent(AnimationPlaceholder);
    }
    
    public static function pathMapper(path, aph, channel:Float->Void) {
        pathSelector(path, aph).channels.push(channel);
    }
    
    // public static function newChild( aph:AnimationPlaceholder) { }
}
