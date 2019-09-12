package al.openfl;
import al.al2d.Axis2D;
import al.al2d.Widget2D;
import openfl.events.Event;
class W2DStageResizer {
    var target:Widget2D;
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

