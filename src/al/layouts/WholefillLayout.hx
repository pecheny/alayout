package al.layouts;
import al.layouts.data.LayoutData.ISize;
import al.core.AxisState;
class WholefillLayout implements AxisLayout {
    public static var instance(default, null) = new WholefillLayout();

    function new() {}

    public function arrange(pos:Float, size:Float, children:Array<AxisState>) {
        var size =  size ;
        var max = size;
        var pos =  pos ;
        var origin = pos;
        for (child in children) {
            if (!child.isArrangable())
                continue;
            var fixed = child.size.getFixed();
            var portion = child.size.getPortion();
            var chSize = fixed;
            if (portion > 0 && fixed < size)
                chSize = size;
            if (chSize > max)
                max = chSize;
            child.apply(pos, chSize);
        }
        return max ;
    }


}

