package al.openfl;
import al.appliers.PropertyAccessors.PropertyAccessor;
import al.appliers.PropertyAccessors.FloatPropertyAccessor;
import openfl.display.DisplayObject;
class DisplayObjectValueAppliers {
    public function new() {
    }
}

@:property("scaleX") class DOScaleXPropertySetter<T:DisplayObject> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
@:property("scaleY") class DOScaleYPropertySetter<T:DisplayObject> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
@:property("width") class DOWidthPropertySetter<T:DisplayObject> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
@:property("height") class DOHeightPropertySetter<T:DisplayObject> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
@:property("x") class DOXPropertySetter<T:DisplayObject> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
@:property("y") class DOYPropertySetter<T:DisplayObject> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
//typedef Target2D = DisplayObject;// doesnt work on cpp {x:Float, y:Float, width:Float, height:Float};
