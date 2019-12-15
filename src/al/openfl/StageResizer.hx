package al.openfl;
import al.al2d.Axis2D;
import al.core.AxisState;
import openfl.events.Event;

class StageResizer {
    var targetAxis:Map<Axis2D,AxisState>;

    public function new(targetAxis:Map<Axis2D,AxisState>){
        this.targetAxis = targetAxis;
        openfl.Lib.current.stage.addEventListener(Event.RESIZE, onResize);
        onResize(null);
    }

    function onResize(e) {
        targetAxis[Axis2D.horizontal].applySize(openfl.Lib.current.stage.stageWidth);
        targetAxis[Axis2D.vertical].applySize(openfl.Lib.current.stage.stageHeight);
    }
}



