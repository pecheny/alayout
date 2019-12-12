package al.openfl;
import al.view.AspectKeeper.WidgetSizeApplier;
import openfl.events.Event;


/**
*  Handles stage.RESIZE event and applies stage aspect ratio to the widget. Short side is equal to base.
**/
class StageAspectResizer {
    var target:WidgetSizeApplier;
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
            target.widgetWidth = base * width / height;
            target.widgetHeight = base;
        } else {
            target.widgetWidth = base;
            target.widgetHeight = base * height / width;
        }
    }
}



