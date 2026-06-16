package al.layouts;

import al.core.Align;
import al.layouts.data.LayoutData;
import al.core.AxisState;

class UnmanagedLayout implements AxisLayout {
    public static var instance(default, null) = new UnmanagedLayout(Forward, PortionLayout.instance);

    var align:Align = Center;
    var managedLayout:AxisLayout;

    public function new(align:Align, managed:AxisLayout) {
        this.align = align;
        this.managedLayout = managed;
    }

    public function arrange(pos:Float, size:Float, children:Array<AxisState>) {
        inline function getSize(isize:ISize) {
            var csize:Float = 0.0;
            csize += size * isize.getPortion();
            csize += isize.getFixed();
            return csize;
        }
        switch align {
            case Forward:
                for (child in children) {
                    if (child.isArrangable())
                        continue;
                    switch child.position.type {
                        case fixed:
                            child.apply(pos + child.position.value, getSize(child.size));
                        case percent:
                            child.apply(pos + child.position.value * size, getSize(child.size));
                        case managed:
                            throw "Magic";
                    }
                }
            case Backward:
                for (child in children) {
                    if (child.isArrangable())
                        continue;
                    switch child.position.type {
                        case fixed:
                            child.apply(pos + size - child.position.value, getSize(child.size));
                        case percent:
                            child.apply(pos + size - child.position.value * size, getSize(child.size));
                        case managed:
                            throw "Magic";
                    }
                }
            case Center:
                for (child in children) {
                    if (child.isArrangable())
                        continue;
                    switch child.position.type {
                        case fixed:
                            child.apply(pos + size / 2 + child.position.value, getSize(child.size));
                        case percent:
                            child.apply(pos + size / 2 + child.position.value * size, getSize(child.size));
                        case managed:
                            throw "Magic";
                    }
                }
        }

        return managedLayout.arrange(pos, size, children);
    }
}
