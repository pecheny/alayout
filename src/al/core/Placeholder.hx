package al.core;

import ec.IComponent;
import ec.EntityHolder.MultiparentEntityHolder;
import al.ec.Entity;

interface Placeholder<TAxis:Axis<TAxis>> {
    public var entity(get, null):Entity;
    public var axisStates(default, null):AVector<TAxis, AxisState>;
}

class PlainPlaceholder<TAxis:Axis<TAxis>> extends Component implements Placeholder<TAxis> {
    public var axisStates(default, null):AVector<TAxis, AxisState>;

    public function new(axisStates:AVector<TAxis, AxisState>) {
        this.axisStates = axisStates;
    }
}

class MultiparentPlaceholder<TAxis:Axis<TAxis>> implements Placeholder<TAxis> extends MultiparentEntityHolder {
    public var axisStates(default, null):AVector<TAxis, AxisState>;

    public function new(axisStates:AVector<TAxis, AxisState>) {
        this.axisStates = axisStates;
    }
}
