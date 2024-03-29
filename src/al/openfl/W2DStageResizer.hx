package al.openfl;
import Axis2D;
import al.al2d.Placeholder2D;
import openfl.events.Event;
class W2DStageResizer {
    var target:Placeholder2D;
    var scale:Float;

    public function new(target, scale:Float = 1) {
        this.scale = scale;
        this.target = target;
        openfl.Lib.current.stage.addEventListener(Event.RESIZE, onResize);
        onResize(null);
    }

    function onResize(e) {
        target.axisStates[Axis2D.horizontal].applySize(openfl.Lib.current.stage.stageWidth * scale);
        target.axisStates[Axis2D.vertical].applySize(openfl.Lib.current.stage.stageHeight * scale);
    }
}

