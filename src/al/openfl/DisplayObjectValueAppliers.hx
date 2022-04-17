package al.openfl;
import openfl.display.DisplayObject;
import al.appliers.PropertyAccessors.PropertyAccessor;
import al.appliers.PropertyAccessors.FloatPropertyAccessor;

@:property("scaleX") class DOScaleXPropertySetter<T:DisplayObject> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
@:property("scaleY") class DOScaleYPropertySetter<T:DisplayObject> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
@:property("width") class DOWidthPropertySetter<T:DisplayObject> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
@:property("height") class DOHeightPropertySetter<T:DisplayObject> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
@:property("x") class DOXPropertySetter<T:DisplayObject> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
@:property("y") class DOYPropertySetter<T:DisplayObject> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
