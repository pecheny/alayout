package al.layouts;

import al.layouts.data.LayoutData.FractionSize;
import al.core.Align;
import al.layouts.data.LayoutData.FixedSize;
import al.layouts.data.LayoutData.ISize;
import al.core.WidgetContainer.LayoutPosMode;
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

        function arrangePart(startIndex:Int, startCoord:Float, direction:Sign):Float {
            var lastIndex = if (direction == 1) children.length - 1 else 0;
            var index = startIndex;
            var coord = startCoord;
            var calculatedTotal = 0.;
            while (index != lastIndex + direction) {
                var child = children[index];
                trace(child);
                var size = getSize(child.size);

                if (direction == 1)
                    child.apply(coord, size);

                coord += direction * size;

                if (direction == -1)
                    child.apply(coord, size);

                calculatedTotal += size;

                size = getSize(gap);
                calculatedTotal += size;
                coord += direction * size;

                index += direction;
            };
            return calculatedTotal;
        };

        switch align {
            case Forward:
                {
                    var coord = mode.isGlobal() ? pos : 0;
                    var calculatedTotalSize = getSize(gap);
                    coord += getSize(gap);
                    calculatedTotalSize += arrangePart(0, coord, positive);
                    return calculatedTotalSize;
                }
            case Backward:
                {
                    var coord = (mode.isGlobal() ? pos : 0) + totalValue;
                    var calculatedTotalSize = getSize(gap);
                    coord -= getSize(gap);
                    calculatedTotalSize += arrangePart(children.length - 1, coord, negative);
                    return calculatedTotalSize;
                }
            case Center:
                {
                    var gapsNum = children.length + 1; // if (children.length == 1) 2 else if(children.length % 2 == 0)

                    var calculatedTotalSize = getSize(gap) * gapsNum;

                    for (child in children)
                        calculatedTotalSize += getSize(child.size);

                    var coord = mode.isGlobal() ? pos : 0;
                    var offset = Math.max((totalValue - calculatedTotalSize) / 2, getSize(gap));
                    coord += offset;

                    arrangePart(0, coord, positive);
                    return calculatedTotalSize;
                    // var coord = (mode.isGlobal() ? pos : 0) + totalValue / 2;
                    // var even = children.length % 2 == 0;
                    // if (even) {
                    //     var gapSize = getSize(gap);
                    //     var calculatedTotalSize = gapSize;
                    //     var startInd = Std.int(children.length / 2);
                    //     calculatedTotalSize += arrangePart(startInd - 1, coord - gapSize / 2, negative);
                    //     calculatedTotalSize += arrangePart(startInd, coord + gapSize / 2, positive);
                    //     return calculatedTotalSize;
                    // } else {
                    //     var centralInd = Math.floor(children.length/2);
                    //     var centralChild = children[centralInd];
                    //     var size = getSize(centralChild.size);
                    //     centralChild.apply(coord - size / 2, size);
                    //     var calculatedTotalSize = size;
                    //     var gapSize = getSize(gap);
                    //     if (children.length == 1)
                    //         return calculatedTotalSize + gapSize * 2;
                    //     calculatedTotalSize += arrangePart(centralInd - 1, coord - ( gapSize + size / 2 ), negative);
                    //     calculatedTotalSize += arrangePart(centralInd + 1, coord + ( gapSize + size / 2 ), positive);
                    //     return calculatedTotalSize;
                }
        }
    }
}

@:enum abstract Sign(Int) to Int {
    var positive = 1;
    var negative = -1;
}
