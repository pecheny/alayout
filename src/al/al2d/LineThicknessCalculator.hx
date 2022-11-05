package al.al2d;
/**
*  Calculates axis-aligned thickness for use in normalized space of widget.
*  Measure units of thickness expressed in portion of 2x(Smallest window dimension).
*  @see transform.AspectRatio
*  LineScaleCalcularor registers on widget axis state so be sure to create it before registering dependent redraw.
**/
import al.al2d.Widget2D;
import al.core.AxisApplier;
import Axis2D;
import macros.AVConstructor;
class LineThicknessCalculator implements AxisApplier {
    var w:Widget2D;
    var lwBase:Float;
    var _lineScales = AVConstructor.create(Axis2D, 1., 1.);
    var aspectRatio:AspectRatio;

    public function new(w:Widget2D, ar, thickness = 0.05) {
        this.w = w;
        lwBase = thickness;
        this.aspectRatio = ar;
        for (a in Axis2D) {
            w.axisStates[a].addSibling(this);
        }
    }

    public inline function lineScales():ReadOnlyAVector2D<Float> {
        return _lineScales;
    }

    inline function refresh() {
        var ww = w.axisStates[horizontal].getSize();
        var wh = w.axisStates[vertical].getSize();
        if (aspectRatio[horizontal] < aspectRatio[vertical]) {
            var wAsp = ww / wh;
            _lineScales[vertical] = lwBase / wh;
            _lineScales[horizontal] = _lineScales[vertical] / wAsp;
        } else {
            var wAsp = wh / ww;
            _lineScales[horizontal] = lwBase / ww;
            _lineScales[vertical] = _lineScales[horizontal] / wAsp;
        }
    }


    public function apply(_, _):Void {
        refresh();
    }
}
