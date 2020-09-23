package al.openfl;
import al.appliers.PropertyAccessors.PropertyAccessor;
import al.appliers.PropertyAccessors.FloatPropertyAccessor;

@:property("scaleX") class DOScaleXPropertySetter<T:{scaleX:Float}> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
@:property("scaleY") class DOScaleYPropertySetter<T:{scaleY:Float}> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
@:property("width") class DOWidthPropertySetter<T:DisplayObject> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
@:property("height") class DOHeightPropertySetter<T:DisplayObject> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
@:property("x") class DOXPropertySetter<T:DisplayObject> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
@:property("y") class DOYPropertySetter<T:DisplayObject> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
typedef  DisplayObject = {x:Float, y:Float, width:Float, height:Float }
