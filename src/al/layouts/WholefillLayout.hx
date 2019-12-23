package al.layouts;
import al.core.AxisState;
class WholefillLayout implements AxisLayout {
    public static var instance(default, null) = new WholefillLayout();

    function new() {}

    public function arrange(parent:AxisState, children:Array<AxisState>):Void {
        for (child in children) {
            if (!child.isArrangable())
                continue;
            child.applySize(parent.getSize());
            child.applyPos(parent.getPos());
        }
    }
}

