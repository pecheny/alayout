package al.layouts;

import al.layouts.data.LayoutData.FixedSize;
import al.layouts.data.LayoutData.ISize;
import al.core.AxisState;

class WholefillLayout implements AxisLayout {
    public static var instance(default, null) = new WholefillLayout(new FixedSize(0));
    public var padding:ISize;

    public function new(padding:ISize) {
        this.padding = padding;
    }

    public function arrange(pos:Float, size:Float, children:Array<AxisState>) {
        var paddingValue = Math.max(padding.getFixed(), padding.getPortion() * size);
        var contSize = size - paddingValue * 2;
        var max = size;
        var pos = pos + paddingValue;
        for (child in children) {
            if (!child.isArrangable())
                continue;
            var fixed = child.size.getFixed();
            var chSize = fixed;

            if (child.size.getPortion() > 0 && fixed < contSize) // stretch child which has portion part upto container
                chSize = contSize;

            if (chSize + paddingValue * 2 > max) // calc content size for scrollbox
                max = chSize + paddingValue * 2;
            child.apply(pos, chSize);
        }
        return max;
    }
}
