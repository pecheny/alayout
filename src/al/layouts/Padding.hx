package al.layouts;

import al.core.AxisState;
import al.layouts.data.LayoutData.FixedSize;
import al.layouts.data.LayoutData.ISize;

class Padding implements AxisLayout {
    public var padding:ISize;
    var layout:AxisLayout;

    public function new(padding:ISize, layout) {
        this.padding = padding;
        this.layout = layout;
    }

    public function arrange(pos:Float, size:Float, children:Array<AxisState>) {
        var paddingValue = Math.max(padding.getFixed(), padding.getPortion() * size);
        var contSize = size - paddingValue * 2;
        var max = size;
        var pos = pos + paddingValue;
        var result = layout.arrange(pos, contSize, children);
        return result + paddingValue;
    }
}
