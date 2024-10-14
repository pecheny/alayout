package al.animation;

import al.animation.AnimationTreeBuilder;
import al.animation.Animation;
import ec.Component;
import ec.Entity;
import al.layouts.OffsetLayout;

@:build(ec.macros.Macros.buildGetOrCreate())
class Animator extends Component {
    var tree:AnimationPlaceholder;
    var channels:Array<Float->Void> = []; // befor init only
    @:once var animationTreeBuilder:AnimationTreeBuilder;

    override function init() {
        tree = animationTreeBuilder.build({
            layout: OffsetLayout.NAME,
            children: []
        });
        for (ch in channels)
            initAnim(ch);
        channels = null;
    }

    public function setT(t:Float) {
        if (tree == null)
            return;
        tree.setTime(t);
    }

    public function addAnim(h) {
        if (_inited)
            initAnim(h);
        else
            channels.push(h);
    }

    function initAnim(h) {
        var animContainer = tree.entity.getComponent(AnimContainer);
        var anim = animationTreeBuilder.animationWidget(new Entity(), {});
        AnimationTreeBuilder.addChild(animContainer, anim);
        anim.channels.push(h);
        animContainer.refresh();
    }
}
