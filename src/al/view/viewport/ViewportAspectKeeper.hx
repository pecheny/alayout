package al.view.viewport;

// todo delete?
import openfl.events.Event;
class ViewportAspectKeeper {
    var child:Viewportable;
    var aspect:Float;
    var offsetX:Int = 0;
    var offsetY:Int = 0;


    public function new(child, aspect = 1, offsetX:Int = 0, offsetY:Int = 0) {
        this.offsetX = offsetX;
        this.offsetY = offsetY;
        this.child = child;
        this.aspect = aspect;
        openfl.Lib.current.stage.addEventListener(Event.RESIZE, refresh);
        refresh(null);
    }

    public function refresh(e:Event) {
        var st = openfl.Lib.current.stage;
        var widgetWidth:Float = st.stageWidth;
        var widgetHeight:Float = st.stageHeight;
        var widgetAspect = widgetWidth / widgetHeight;
        if (widgetAspect > aspect) {
            var height = Std.int(widgetHeight);
            var width = Std.int(height * aspect);
            var freeWidth = Std.int(widgetWidth - width);
            var x = Std.int(freeWidth / 2 + offsetX) ;
            var y = offsetY ;
            child.setViewport(x, y, width, height);
        } else {
            var width = Std.int(widgetWidth);
            var height = Std.int(width / aspect);
            var freeHeight = Std.int(widgetHeight - height);
            var x = offsetX ;
            var y = Std.int(offsetY + freeHeight / 2);
            child.setViewport(x, y, width, height);
        }
    }


}

