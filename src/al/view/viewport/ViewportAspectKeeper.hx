package al.view.viewport;
import al.view.AspectKeeper.WidgetSizeApplier;
class ViewportAspectKeeper implements WidgetSizeApplier {
    var child:Viewportable;
    var aspect:Float;
    var offsetX:Int = 0;
    var offsetY:Int = 0;
    @:isVar public var widgetWidth(default, set):Float;
    @:isVar public var widgetHeight(default, set):Float;

    public function new(child, aspect = 1, offsetX:Int = 0, offsetY:Int = 0) {
        this.offsetX = offsetX;
        this.offsetY = offsetY;
        this.child = child;
        this.aspect = aspect;
    }

    public function refresh() {
        var widgetAspect = widgetWidth / widgetHeight;
        if (widgetAspect > aspect) {
            var height = Std.int(widgetHeight);
            var width = Std.int(height * aspect);
            var freeWidth = Std.int(widgetWidth - width);
            var x = Std.int(freeWidth / 2 + offsetX) ;
            var y = offsetY ;
            child.setViewport(x,y,width,height);
        } else {
            var width = Std.int(widgetWidth);
            var height = Std.int(width / aspect);
            var freeHeight = Std.int(widgetHeight - height);
            var x = offsetX ;
            var y = Std.int(offsetY + freeHeight / 2);
            child.setViewport(x,y,width,height);
        }
    }

    function set_widgetHeight(value:Float):Float {
        this.widgetHeight = value;
        refresh();
        return value;
    }

    function set_widgetWidth(value:Float):Float {
        this.widgetWidth = value;
        refresh();
        return value;
    }
}

