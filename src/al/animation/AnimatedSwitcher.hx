package al.animation;

import al.animation.AnimationTree;
import a2d.Placeholder2D;
import al.animation.Animation.AnimationPlaceholder;
import al.animation.AnimationTreeBuilder;
import al.ec.WidgetSwitcher;
import update.Updatable;

class AnimatedSwitcher implements Updatable {
    public var duration = 1.;

    var tree:AnimationPlaceholder;
    var time:Float = 0;
    var switcher:WidgetSwitcher<Axis2D>;
    var prev:Placeholder2D;
    var prevAnim:AnimationTreeProp;
    var current:Placeholder2D;
    var curAnim:AnimationTreeProp;
    var builder:AnimationTreeBuilder = new AnimationTreeBuilder();

    public function new(switcher) {
        this.switcher = switcher;
        setTree({
            layout: "portion",
            name: "switcher",
            children: [{size: {value: 1.}}, {size: {value: 1.}},]
        });
    }

    public function setTree(desc) {
        tree = builder.build(desc);
        tree.bindAnimation(0, t -> {
            if (prevAnim?.value != null)
                prevAnim.value.setTime(1 - t);
        });
        tree.bindAnimation(1, t -> {
            if (curAnim?.value != null)
                curAnim.value.setTime(t);
        });
    }

    public function switchTo(ph:Placeholder2D) {
        time = current != null ? 0 : 0.5;
        prev = current;
        prevAnim = curAnim;
        current = ph;
        curAnim = current.entity.getComponent(AnimationTreeProp);
        switcher.bind(ph);
    }

    public function update(dt:Float):Void {
        if (time == 1 || current == null)
            return;
        time += dt / duration;
        if (time >= 1)
            time = 1;
        tree.setTime(time);
        if (time == 1 && prev != null) {
            switcher.unbind(prev);
            prev = null;
        }
    }
}
