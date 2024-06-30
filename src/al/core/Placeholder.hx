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

class PlaceholderUtils {
    public static function addSibling<TAxis:Axis<TAxis>>(ph1:Placeholder<TAxis>, ph2:Placeholder<TAxis>) {
        ph1.entity.addChild(ph2.entity);
        for (a in ph1.axisStates.axes())
            ph1.axisStates[a].addSibling(ph2.axisStates[a]);
    }

    public static function removeSibling<TAxis:Axis<TAxis>>(ph1:Placeholder<TAxis>, ph2:Placeholder<TAxis>) {
        ph1.entity.removeChild(ph2.entity);
        for (a in ph1.axisStates.axes())
            ph1.axisStates[a].removeSibling(ph2.axisStates[a]);
    }
}
