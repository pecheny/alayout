package al.openfl;
import Axis2D;
import al.al2d.Placeholder2D;
import openfl.events.Event;


/**
*  Handles stage.RESIZE event and applies stage aspect ratio to the widget. Short side is equal to base.
**/
class StageAspectResizer {
    var target:Placeholder2D;
    var base:Float;

    public function new(target, base:Float = 1) {
        this.target = target;
        this.base = base;
        openfl.Lib.current.stage.addEventListener(Event.RESIZE, onResize);
        onResize(null);
    }

    function onResize(e) {
        var stage = openfl.Lib.current.stage;
        var width = stage.stageWidth;
        var height = stage.stageHeight;
        if (width > height) {
            target.axisStates[Axis2D.horizontal].apply(0, base * width / height);
            target.axisStates[Axis2D.vertical].apply(0, base );
        } else {
            target.axisStates[horizontal].apply(0, base );
            target.axisStates[vertical].apply(0, base * height / width);
        }
    }
}



