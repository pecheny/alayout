package al.layouts;

import al.core.WidgetContainer.LayoutPosMode;
import al.core.AxisState;
class PortionLayout implements AxisLayout {
    public static var instance(default, null) = new PortionLayout();
    public function new() {}

    public function arrange(parent:AxisState, children:Array<AxisState>, mode:LayoutPosMode){
        var fixedValue = 0.0;
        var portionsSum = 0.0;
        var coord = mode.isGlobal() ? parent.getPos() : 0;
        var origin = coord;

        for (child in children) {
            if (!child.isArrangable())
                continue;

            portionsSum += child.size.getPortion();
            fixedValue += child.size.getFixed();
        }
        if (portionsSum == 0)
            portionsSum = 1;

        var totalValue = mode.isGlobal() ? parent.getSize() : 1;
        var distributedValue = totalValue - fixedValue;
        for (child in children) {
            if (!child.isArrangable()) // todo handle unmanaged percent size here
                continue;
            var size:Float = 0.0;
            size += distributedValue * child.size.getPortion() / portionsSum;
            size += child.size.getFixed();
            child.apply(coord, size);
            coord += size;
        }
        return coord - origin;
    }
}

