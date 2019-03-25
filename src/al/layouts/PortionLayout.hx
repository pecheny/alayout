package al.layouts;

import al.core.AxisState;
class PortionLayout implements AxisLayout {
    public static var instance(default, null) = new PortionLayout();
    public function new() {}

    public function arrange(parent:AxisState, children:Array<AxisState>):Void {
        var fixedValue = 0.0;
        var portionsSum = 0.0;
        var coord = 0.0;

        for (child in children) {
            if (!child.isArrangable())
                continue;

            portionsSum += getPortion(child);
            fixedValue += getFixed(child);
        }

        var totalValue = parent.getSize();
        var distributedValue = totalValue - fixedValue;
        for (child in children) {
            if (!child.isArrangable()) // todo handle unmanaged percent size here
                continue;
            var size = 0.0;
            size += distributedValue * getPortion(child) / portionsSum;
            size += getFixed(child);
            child.applyPos(coord);
            child.applySize(size);
            coord += size;
        }
    }

    inline function getPortion(w:AxisState) {
        return switch w.size.type {
            case fixed, percent: 0;
            case range: w.size.maxValue - w.size.value;
            case portion : w.size.value;
        }
    }

    inline function getFixed(w:AxisState) {
        return switch w.size.type {
            case fixed, range: w.size.value;
            case portion, percent: 0;
        }
    }
}

