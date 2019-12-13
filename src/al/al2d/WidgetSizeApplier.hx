package al.al2d;
import al.view.AspectKeeper.WidgetSizeApplier;
import al.appliers.PropertyAccessors.PropertyAccessor;
import al.appliers.PropertyAccessors.FloatPropertyAccessor;
@:property("widgetWidth") class WidgetWidthApplier<T:WidgetSizeApplier> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
@:property("widgetHeight") class WidgetHeightApplier<T:WidgetSizeApplier> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}

