package al.layouts;

import al.layouts.data.LayoutData.FractionSize;
import al.core.Align;
import al.layouts.data.LayoutData.FixedSize;
import al.layouts.data.LayoutData.ISize;
import al.core.AxisState;

class PortionLayout implements AxisLayout {
    public static var instance(default, null) = new PortionLayout(Forward);
    public static var backward(default, null) = new PortionLayout(Backward);
    public static var center(default, null) = new PortionLayout(Center);

    public var gap:ISize = new FixedSize(0);

    var align:Align = Center;

    public function new(align:Align, spacing:ISize = null) {
        if (spacing != null)
            this.gap = spacing;
        this.align = align;
    }

    public function arrange(pos:Float, size:Float, children:Array<AxisState>) {
        if (children.length == 0)
            return 0.;
        var gapsNum = children.length - 1;
        var fixedValue = gap.getFixed() * gapsNum;
        var portionsSum = gap.getPortion() * gapsNum;

        for (child in children) {
            if (!child.isArrangable())
                continue;

            portionsSum += child.size.getPortion();
            fixedValue += child.size.getFixed();
        }
        if (portionsSum == 0)
            portionsSum = 1;

        var totalValue = size;
        var distributedValue = totalValue - fixedValue;

        if (distributedValue < 0)
            distributedValue = 0;

        inline function getSize(isize:ISize) {
            var size:Float = 0.0;
            size += distributedValue * isize.getPortion() / portionsSum;
            size += isize.getFixed();
            return size;
        }

        function arrangePart(startIndex:Int, startCoord:Float, direction:Sign):Float {
            var lastIndex = if (direction == 1) children.length - 1 else 0;
            var index = startIndex;
            var coord = startCoord;
            var calculatedTotal = 0.;
            while (true) {
                var child = children[index];
                var size = getSize(child.size);

                if (direction == 1)
                    child.apply(coord, size);

                coord += direction * size;

                if (direction == -1)
                    child.apply(coord, size);

                calculatedTotal += size;

                index += direction;
                if (index == lastIndex + direction)
                    break;

                size = getSize(gap);
                calculatedTotal += size;
                coord += direction * size;
            };
            return calculatedTotal;
        };

        switch align {
            case Forward:
                {
                    var coord = pos;
                    var calculatedTotalSize = 0.;
                    calculatedTotalSize += arrangePart(0, coord, positive);
                    return calculatedTotalSize;
                }
            case Backward:
                {
                    var coord = pos + totalValue;
                    var calculatedTotalSize = 0.;
                    calculatedTotalSize += arrangePart(children.length - 1, coord, negative);
                    return calculatedTotalSize;
                }
            case Center:
                {
                    var calculatedTotalSize = getSize(gap) * gapsNum;

                    for (child in children)
                        calculatedTotalSize += getSize(child.size);

                    var coord = pos;
                    var offset = (totalValue - calculatedTotalSize) / 2;
                    coord += offset;

                    arrangePart(0, coord, positive);
                    return calculatedTotalSize;
                }
        }
    }
}

@:enum abstract Sign(Int) to Int {
    var positive = 1;
    var negative = -1;
}
