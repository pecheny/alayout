package al.core;
import al.ec.Entity.Component;
import al.core.AxisCollection;

class Widget<TAxis:al.core.WidgetContainer.AxisKeyBase> extends Component {
    public var axisStates(default, null):AxisCollection<TAxis, AxisState>;

    public function new(axisStates:AxisCollection<TAxis, AxisState>) {
        this.axisStates = axisStates;
    }
}
