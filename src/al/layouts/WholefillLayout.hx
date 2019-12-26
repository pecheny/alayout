package al.layouts;
import al.core.WidgetContainer.LayoutPosMode;
import al.core.AxisState;
class WholefillLayout implements AxisLayout {
    public static var instance(default, null) = new WholefillLayout();

    function new() {}

    public function arrange(parent:AxisState, children:Array<AxisState>, mode:LayoutPosMode):Void {
        for (child in children) {
            if (!child.isArrangable())
                continue;
            if (mode.isGlobal()){
                child.applySize(parent.getSize());
                child.applyPos(parent.getPos());
            }else{
                child.applySize(1);
            }

        }
    }
}

