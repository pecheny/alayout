package al.layouts;

// store typed children collection on pass as arg to arrange()
import al.core.AxisState;
interface AxisLayout {
    function arrange(pos:Float, size:Float,  children:Array<AxisState>):Float;
}

