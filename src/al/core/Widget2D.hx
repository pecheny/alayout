package al.core;
import al.ec.Entity.Component;
import al.layouts.data.LayoutData.Axis2D;
import al.core.AxisState;
class Widget2D extends Component {
    public var axisStates(default, null):Map<Axis2D, AxisState>;

    public function new(axisStates:Map<Axis2D, AxisState>) {
        this.axisStates = axisStates;
    }
}

