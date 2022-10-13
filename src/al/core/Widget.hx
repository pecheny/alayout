package al.core;
import al.ec.Entity.Component;

class Widget<TAxis:Axis<TAxis>> extends Component {
    public var axisStates(default, null):AVector<TAxis, AxisState>;

    public function new(axisStates:AVector<TAxis, AxisState>) {
        this.axisStates = axisStates;
    }
}
