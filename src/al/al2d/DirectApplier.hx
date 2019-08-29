package al.al2d;
import al.view.AspectKeeper.WidgetSizeApplier;
class DirectApplier implements WidgetSizeApplier {
    var target:Widget2D;

    public var widgetWidth(default, set):Float;
    public var widgetHeight(default, set):Float;

    public function new(target:Widget2D) {
        this.target = target;
    }

    function set_widgetWidth(value:Float):Float {
        target.axisStates[Axis2D.horizontal].applySize(value);
        return value;
    }

    function set_widgetHeight(value:Float):Float {
        target.axisStates[Axis2D.vertical].applySize(value);
        return value;
    }

}
