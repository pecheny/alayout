package al.view;
import al.appliers.ApplierFactory;
import al.al2d.Axis2D;
import al.appliers.PropertyAccessors.DOHeightPropertySetter;
import al.appliers.PropertyAccessors.DOWidthPropertySetter;
import al.appliers.PropertyAccessors.DOXPropertySetter;
import al.appliers.PropertyAccessors.DOYPropertySetter;
import al.appliers.PropertyAccessors.FloatPropertyAccessor;
import al.appliers.PropertyAccessors.Target2D;
import openfl.display.Sprite;
class ColoredRect extends Sprite {
    public function new(c) {
        super();
        graphics.beginFill(c);
        graphics.drawRect(0, 0, 20, 20);
        graphics.endFill();
    }
}

class DisplayObjectScalerApplierFactory<T:Target2D> implements ApplierFactory<Axis2D> {
    var target:T;

    public function new(t) this.target = t;

    public function getPosApplier(axis:Axis2D):FloatPropertyAccessor {
        return switch axis {
            case vertical : return new DOYPropertySetter(target);
            case horizontal : return new DOXPropertySetter(target);
        }
    }

    public function getSizeApplier(axis:Axis2D):FloatPropertyAccessor {
        return switch axis {
            case vertical : return new DOHeightPropertySetter(target);
            case horizontal : return new DOWidthPropertySetter(target);
        }
    }
}