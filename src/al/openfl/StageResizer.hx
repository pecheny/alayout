package al.openfl;
import Axis2D;
import al.core.AxisState;
import openfl.events.Event;

class StageResizer {
    var targetAxis:AVector2D<AxisState>;

    public function new(targetAxis:AVector2D<AxisState>){
        this.targetAxis = targetAxis;
        openfl.Lib.current.stage.addEventListener(Event.RESIZE, onResize);
        onResize(null);
    }

    function onResize(e) {
        targetAxis[Axis2D.horizontal].apply(0, openfl.Lib.current.stage.stageWidth);
        targetAxis[Axis2D.vertical].apply(0, openfl.Lib.current.stage.stageHeight);
    }
}



