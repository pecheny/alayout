package al.layouts;

import al.core.Align;
import al.layouts.data.LayoutData.FixedSize;
import al.layouts.data.LayoutData.ISize;
import al.core.WidgetContainer.LayoutPosMode;
import al.core.AxisState;

class PortionLayout implements AxisLayout {
    public static var instance(default, null) = new PortionLayout();

    public function new(gap:ISize = null) {
        if (gap != null)
            this.gap = gap;
    }

    var gap:ISize = new FixedSize(0.1);
    var align:Align = Forward;

    public function arrange(pos:Float, size:Float, children:Array<AxisState>, mode:LayoutPosMode) {
        if (children.length == 0)
            return 0.;
        var fixedValue = gap.getFixed();
        var portionsSum = gap.getPortion();

        for (child in children) {
            if (!child.isArrangable())
                continue;

            portionsSum += child.size.getPortion();
            fixedValue += child.size.getFixed();
            portionsSum += gap.getPortion();
            fixedValue += gap.getFixed();
        }
        if (portionsSum == 0)
            portionsSum = 1;

        var totalValue = mode.isGlobal() ? size : 1;
        var distributedValue = totalValue - fixedValue;

        inline function getSize(isize:ISize) {
            var size:Float = 0.0;
            size += distributedValue * isize.getPortion() / portionsSum;
            size += isize.getFixed();
            return size;
        }

        
        switch align {
            case Forward:
                {
                    var coord = mode.isGlobal() ? pos : 0;
                    var calculatedTotalSize = getSize(gap);
                    coord += getSize(gap);
                    for (child in children) {
                        if (!child.isArrangable()) // todo handle unmanaged percent size here
                            continue;
                        var size = getSize(child.size);
                        child.apply(coord, size);
                        coord += size;
                        calculatedTotalSize += size;
                        coord += getSize(gap);
                        calculatedTotalSize += getSize(gap);
                    }
                    return calculatedTotalSize;
                }
            case Backward:
                {
                    var coord = (mode.isGlobal() ? pos : 0) + totalValue;
                    var calculatedTotalSize = getSize(gap);
                    coord -= getSize(gap);
                    for (child in children) {
                        if (!child.isArrangable()) // todo handle unmanaged percent size here
                            continue;
                        var size = getSize(child.size);
                        child.apply(coord - size, size);
                        coord -= size;
                        calculatedTotalSize += size;
                        coord -= getSize(gap);
                        calculatedTotalSize += getSize(gap);
                    }
                    return calculatedTotalSize;
                }
            case Center:
                {
                    var coord = (mode.isGlobal() ? pos : 0) + totalValue / 2;
                    var calculatedTotalSize = getSize(gap);
                    coord += getSize(gap);
                    for (child in children) {
                        if (!child.isArrangable()) // todo handle unmanaged percent size here
                            continue;
                        var size = getSize(child.size);
                        child.apply(coord, size);
                        coord += size;
                        calculatedTotalSize += size;
                        coord += getSize(gap);
                        calculatedTotalSize += getSize(gap);
                    }
                    return calculatedTotalSize;
                }
        }
    }
}
