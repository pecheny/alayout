package al.animation;

import al.core.AxisState;
import al.core.Placeholder;
import al.core.WidgetContainer;
import utils.Mathu;

@:build(macros.BuildMacro.buildAxes())
@:enum abstract TimeAxis(Axis<TimeAxis>) to Axis<TimeAxis> to Int {
    var time = 0;
}

class AnimationPlaceholder implements Animatable implements Channels extends PlainPlaceholder<TimeAxis> {
    public var channels(default, null):Array<Float->Void> = [];

    public inline function setTime(time:Float) {
        for (ach in channels) {
            ach(time);
        }
    }

    public function bindAnimation(id, handler:Float->Void) {
        entity.getChildren()[id].getComponent(AnimationPlaceholder).channels.push(handler);
    }

    public function bindDeep(path, handler:Float->Void) {
        var trg = entity.getGrandchild(path);
        if (trg != null)
            trg.getComponent(AnimationPlaceholder).channels.push(handler);
    }
}

class AnimContainer extends WidgetContainer<TimeAxis, AnimationPlaceholder> implements Animatable {
    var aph:AnimationPlaceholder;

    public function new(w:AnimationPlaceholder) {
        w.channels.push(setTime);
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
}

interface Animatable {
    function setTime(t:Float):Void;
}

interface Channels {
    var channels(default, null):Array<Float->Void>;
}
