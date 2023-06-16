package al.layouts;

import al.core.AxisState;

class OffsetLayout implements AxisLayout {
    public static inline var NAME = "offset";
    public static var instance(default, null) = new OffsetLayout(0.1);

    var offset = 0.1;

    public function new(offset) {
        this.offset = offset;
    }

    public function arrange(pos:Float, size:Float, children:Array<AxisState>) {
        var coord = pos;
        var origin = coord;
        var childNum = 0;
        for (child in children) {
            if (!child.isArrangable())
                continue;
            childNum++;
        }
        var totalValue = size;
        var delta = (offset * (childNum - 1));
        var distributedValue = totalValue - delta; //

        for (child in children) {
            if (!child.isArrangable()) // todo handle unmanaged percent size here
                continue;
            var size:Float = 0.0;
            size += distributedValue * child.size.getPortion();
            size += child.size.getFixed();
            child.apply(coord, size);
            coord += offset;
        }
        return coord - origin;
    }
}
