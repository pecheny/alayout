package al.openfl;
import al.al2d.Axis2D;
import al.appliers.ApplierFactory;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import al.openfl.DisplayObjectAxisAppliers;
class ColoredRect extends Sprite {
    public function new(c) {
        super();
        graphics.beginFill(c);
        graphics.drawRect(0, 0, 20, 20);
        graphics.endFill();
    }
}

class DisplayObjectScalerApplierFactory<T:DisplayObject> implements ApplierFactory<Axis2D> {
    var target:T;

    public function new(t) this.target = t;

    public function getApplier(a){
        return switch a {
            case horizontal : new DOHorizontalApplier(target);
            case vertical : new DOVerticalApplier(target);
        }
    }


}

