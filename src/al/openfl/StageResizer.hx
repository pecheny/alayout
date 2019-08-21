package al.openfl;
import al.view.AspectKeeper.WidgetSizeApplier;
import openfl.events.Event;

class StageResizer {
    var target:WidgetSizeApplier;

    public function new(target) {
        this.target = target;
        openfl.Lib.current.stage.addEventListener(Event.RESIZE, onResize);
        onResize(null);
    }

    function onResize(e) {
        target.widgetWidth = openfl.Lib.current.stage.stageWidth;
        target.widgetHeight = openfl.Lib.current.stage.stageHeight;
    }
}



