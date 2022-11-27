package al.animation;
import al.core.AxisState;
import al.core.Placeholder;
import al.core.WidgetContainer;
import utils.Mathu;
@:build(macros.BuildMacro.buildAxes())
@:enum abstract TimeAxis(Axis<TimeAxis>) to Axis<TimeAxis> to Int{
    var time = 0;
}

class AnimationPlaceholder extends Placeholder<TimeAxis> implements Animatable {
    public var animations(default, null):Animations = new Animations();

    public inline function setTime(time:Float) {
        animations.setTime(time);
    }

    public function bindAnimation(id, handler:Float -> Void) {
        entity.getChildren()[id].getComponent(AnimationPlaceholder).animations.channels.push(handler);
    }

    public function bindDeep(path, handler:Float -> Void) {
        var trg = entity.getGrandchild(path);
        if (trg != null)
            trg.getComponent(AnimationPlaceholder).animations.channels.push(handler);
    }
}
class AnimContainer extends WidgetContainer<TimeAxis, AnimationPlaceholder> implements Animatable {
    public function new(w) {
        super(w, 1);
    }

    public function setTime(t:Float) {
        var ptime = t;
        for (ch in getChildren()) {
            var tax:AxisState = ch.axisStates[TimeAxis.time];
            var ltuc = (ptime - tax.getPos()) / tax.getSize();
            var ltime = Mathu.clamp(ltuc, 0., 1.);
            ch.setTime(ltime);
        }
    }

    override public function setHolder(h:AnimationPlaceholder) {
        if (holder == h)
            return;
        super.setHolder(h);
        h.animations.channels.push(setTime);
    }
}

class Animations implements Animatable {
    public var channels:Array<Float -> Void> = [];

    public function new() {}

    public function setTime(t:Float):Void {
        for (ach in channels) {
            ach(t);
        }
    }
}

interface Animatable {
    function setTime(t:Float):Void;
}
