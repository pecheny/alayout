package al.layouts;

// store typed children collection on pass as arg to arrange()
import al.core.WidgetContainer.LayoutPosMode;
import al.core.AxisState;
interface AxisLayout {
    function arrange(parent:AxisState, children:Array<AxisState>, mode:LayoutPosMode):Float;
}

