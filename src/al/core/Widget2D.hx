package al.core;
import ecs.Entity.Component;
import al.layouts.data.LayoutData.Axis2D;
import al.core.AxisState;
class Widget2D extends Component {
    public static inline var TYPE = "Widget2D";
    public var axisStates(default, null):Map<Axis2D, AxisState>;

    public function new(axisStates:Map<Axis2D, AxisState>) {
        super(TYPE);
        this.axisStates = axisStates;
    }
}

