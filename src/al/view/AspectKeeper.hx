package al.view;
//import openfl.display.DisplayObject;
//@:generic

import openfl.display.DisplayObject;
import openfl.geom.Rectangle;
interface WidgetSizeApplier {
    var widgetWidth(default, set):Float;
    var widgetHeight(default, set):Float;
}
typedef Target2D = DisplayObject;//{x:Float, y:Float, width:Float, height:Float, scaleX:Float, scaleY:Float}
class AspectKeeper<T:Target2D> implements WidgetSizeApplier {
    var child:T;
    @:isVar public var widgetWidth(default, set):Float;
    @:isVar public var widgetHeight(default, set):Float;
    var bounds:Rectangle;

    public function new(child:T, bounds:Rectangle) {
        this.bounds = bounds;
        this.child = child;
    }

    public function refresh() {
        var widgetAspect = widgetWidth / widgetHeight;

        var scaleX = widgetWidth / bounds.width ;
        var scaleY = widgetHeight / bounds.height ;
        var scale = Math.min(scaleX, scaleY);

        child.scaleX = scale;
        child.scaleY = scale;
        var freeWidth:Float = 0;
        var freeHeight:Float = 0;
        if (scaleX > scaleY) {
            freeWidth = widgetWidth - bounds.width * scale;
        } else {
            freeHeight = widgetHeight - bounds.height * scale;
        }
        child.x = -scale * bounds.x + freeWidth / 2;
        child.y = -scale * bounds.y + freeHeight / 2;
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


class WidthBasedAspectKeeper<T:{x:Float, y:Float, width:Float, height:Float, scaleX:Float, scaleY:Float}> implements WidgetSizeApplier {
    var child:T;
    var aspect:Float;
    var offsetX:Float = 0;
    var offsetY:Float = 0;
    @:isVar public var widgetWidth(default, set):Float;
    @:isVar public var widgetHeight(default, set):Float;

    public function new(child:T, offsetX:Float = 0, offsetY:Float = 0) {
        this.offsetX = offsetX;
        this.offsetY = offsetY;
        this.child = child;
        aspect = child.width / child.height;
    }

    public function refresh() {
        var widgetAspect = widgetWidth / widgetHeight;
        if (widgetAspect > aspect) {
            var height = widgetHeight;
            var width = height * aspect;
            var freeWidth = widgetWidth - width;
            child.width = width;
            child.height = height;
            child.x = freeWidth / 2 + offsetX * child.scaleY;
            child.y = offsetY * child.scaleY;
        } else {
            var width = widgetWidth;
            var height = width / aspect;
            var freeHeight = widgetHeight - height;
            child.width = width;
            child.height = height;
            child.x = offsetX * child.scaleX;
            child.y = offsetY * child.scaleX + freeHeight / 2;
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

interface Viewportable {
    function setViewport(x:Int, y:Int, w:Int, h:Int):Void;
}
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
