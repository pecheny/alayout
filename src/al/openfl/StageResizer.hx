package al.openfl;
import al.al2d.Widget2D.AxisCollection2D;
import al.al2d.Axis2D;
import al.core.AxisState;
import openfl.events.Event;

class StageResizer {
    var targetAxis:AxisCollection2D<AxisState>;

    public function new(targetAxis:AxisCollection2D<AxisState>){
        this.targetAxis = targetAxis;
        openfl.Lib.current.stage.addEventListener(Event.RESIZE, onResize);
        onResize(null);
    }

    function onResize(e) {
        targetAxis[Axis2D.horizontal].apply(0, openfl.Lib.current.stage.stageWidth);
        targetAxis[Axis2D.vertical].apply(0, openfl.Lib.current.stage.stageHeight);
    }
}



