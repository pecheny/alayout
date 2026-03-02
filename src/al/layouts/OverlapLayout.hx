package al.layouts;

import al.core.Align;
import al.core.AxisState;

class OverlapLayout implements AxisLayout {
    public static var instance(default, null) = new OverlapLayout();

    var sparceLayouter:AxisLayout = new PortionLayout(Align.Center);

    public function new(sparceLayouter:AxisLayout = null) {
        if (sparceLayouter != null)
            this.sparceLayouter = sparceLayouter;
    }

    public function arrange(pos:Float, size:Float, children:Array<AxisState>):Float {
        var fixedValue = 0.;
        for (child in children) {
            if (!child.isArrangable())
                continue;
            fixedValue += child.size.getFixed();
        }
        if (fixedValue <= size)
            return sparceLayouter.arrange(pos, size, children);
        var toDistribute = size - children[children.length - 1].getSize();
        var offset = toDistribute / (children.length - 1);
        var coord = 0.;
        for (ch in children) {
            ch.apply(coord, ch.size.getFixed());
            coord += offset;
        }
        return size;
    }
}
