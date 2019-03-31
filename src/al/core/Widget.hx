package al.core;
import al.ec.Entity.Component;
class Widget<TAxis> extends Component {
    public var axisStates(default, null):Map<TAxis, AxisState>;

    public function new(axisStates:Map<TAxis, AxisState>) {
        this.axisStates = axisStates;
    }
}
