package al.openfl;
import al.al2d.Axis2D;
import al.al2d.Widget2D;
import openfl.events.Event;


/**
*  Handles stage.RESIZE event and applies stage aspect ratio to the widget. Short side is equal to base.
**/
class StageAspectResizer {
    var target:Widget2D;
    var base:Float;

    public function new(target, base = 1) {
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
            target.axisStates[Axis2D.horizontal].applySize( base * width / height);
            target.axisStates[Axis2D.vertical].applySize( base );
        } else {
            target.axisStates[horizontal].applySize( base );
            target.axisStates[vertical].applySize( base * height / width);
        }
    }
}



