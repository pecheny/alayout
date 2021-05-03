package al.al2d;
/**
*  Calculates axis-aligned thickness for use in normalized space of widget.
*  Measure units of thickness expressed in portion of 2x(Smallest window dimension).
*  @see transform.AspectRatio
*  LineScaleCalcularor registers on widget axis state so be sure to create it before registering dependent redraw.
**/
import al.core.AxisApplier;
import al.al2d.Widget2D;
import al.al2d.Axis2D;
import haxe.ds.ReadOnlyArray;
class LineThicknessCalculator implements AxisApplier {
    var w:Widget2D;
    var lwBase:Float;
    var _lineScales = [1., 1.];
    var aspectRatio:AspectRatio;

    public function new(w:Widget2D, ar, thickness = 0.05) {
        this.w = w;
        lwBase = thickness;
        this.aspectRatio = ar;
        for (a in Axis2D.keys) {
            w.axisStates[a].addSibling(this);
        }
    }

    public inline function lineScales():ReadOnlyArray<Float> {
        return _lineScales;
    }

    inline function refresh() {
        var ww = w.axisStates[horizontal].getSize();
        var wh = w.axisStates[vertical].getSize();
        if (aspectRatio[0] < aspectRatio[1]) {
            var wAsp = ww / wh;
            _lineScales[1] = lwBase / wh;
            _lineScales[0] = _lineScales[1] / wAsp;
        } else {
            var wAsp = wh / ww;
            _lineScales[0] = lwBase / ww;
            _lineScales[1] = _lineScales[0] / wAsp;
        }
    }


    public function apply(_, _):Void {
        refresh();
    }
}
