package al.animation;

import al.animation.AnimationTree.AnimationTreeProp;
import al.core.AxisState;
import al.core.Placeholder;
import al.core.WidgetContainer;
import utils.Mathu;

@:build(macros.BuildMacro.buildAxes())
@:enum abstract TimeAxis(Axis<TimeAxis>) to Axis<TimeAxis> to Int {
    var time = 0;
}

class AnimationPlaceholder implements Animatable extends PlainPlaceholder<TimeAxis> {
    public var channels(default, null):Array<Float->Void> = [];

    var siblings:Array<AnimationPlaceholder> = [];

    public inline function setTime(time:Float) {
        for (ach in channels) {
            ach(time);
        }
        for (s in siblings)
            s.setTime(time);
    }

    public function bindAnimation(id, handler:Float->Void) {
        entity.getChildren()[id].getComponent(AnimationPlaceholder).channels.push(handler);
    }

    public function bindDeep(path, handler:Float->Void) {
        var trg = entity.getGrandchild(path);
        if (trg != null)
            trg.getComponent(AnimationPlaceholder).channels.push(handler);
    }

    public function addSibling(aph) {
        siblings.push(aph);
        PlaceholderUtils.addSibling(this, aph);
    }

    public function removeSibling(aph) {
        siblings.remove(aph);
        PlaceholderUtils.removeSibling(this, aph);
    }
}

class AnimContainer extends WidgetContainer<TimeAxis, AnimationPlaceholder> implements Animatable {
    var aph:AnimationPlaceholder;

    public function new(w:AnimationPlaceholder) {
        this.aph = w;
        w.channels.push(setTime);
        super(w, 1);
    }

    public function setTime(t:Float) {
        var ptime = t;
        var pst = aph.axisStates[time];
        for (ch in getChildren()) {
            var tax:AxisState = ch.axisStates[TimeAxis.time];
            // positons stored in global space, but t should be calculated in internal normalized
            // so we should get
            // 1. beginning of child relative to parent
            // 2. parent time relative to child's beginning
            // 3. scale the result to be normalized within child's' space
            // Since t in both child and parent space is normalized the multiplier is relation of child and parent size.
            var ltuc = (ptime - tax.getPos() + pst.getPos()) / (tax.getSize() / pst.getSize());
            var ltime = Mathu.clamp(ltuc, 0., 1.);
            ch.setTime(ltime);
        }
    }
}

interface Animatable {
    function setTime(t:Float):Void;
}
