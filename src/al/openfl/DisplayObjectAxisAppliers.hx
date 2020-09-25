package al.openfl;
import al.core.AxisApplier;
import openfl.display.DisplayObject;
class DOVerticalApplier implements AxisApplier {
    var target:DisplayObject;

    public function new(t) this.target = t;


    public function apply(pos:Float, size:Float):Void {
        target.y = pos;
        target.height = size;
    }
}
class DOHorizontalApplier implements AxisApplier {
    var target:DisplayObject;

    public function new(t) this.target = t;


    public function apply(pos:Float, size:Float):Void {
        target.x = pos;
        target.width = size;
    }
}
class DOVerticalPosApplier implements AxisApplier {
    var target:DisplayObject;

    public function new(t) this.target = t;


    public function apply(pos:Float, size:Float):Void {
        target.y = pos;
    }
}
class DOHorizontalPosApplier implements AxisApplier {
    var target:DisplayObject;

    public function new(t) this.target = t;


    public function apply(pos:Float, size:Float):Void {
        target.x = pos;
    }
}
