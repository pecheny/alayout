package a2d.transform;

/**
 *  Calculates axis-aligned thickness for use in normalized space of widget.
 *  Measure units of thickness expressed in portion of 2x(Smallest window dimension).
 *  @see transform.AspectRatio
 *  LineScaleCalcularor registers on widget axis state so be sure to create it before registering dependent redraw.
**/
import Axis2D;
import a2d.AspectRatio;
import macros.AVConstructor;

class LineThicknessCalculator implements Resizable {
    var lwBase:Float;
    var _lineScales:AVector2D<Float> = AVConstructor.create(Axis2D, 1., 1.);
    var aspectRatio:AspectRatio;

    public function new(ar:AspectRatio, thickness = 0.05) {
        lwBase = thickness;
        this.aspectRatio = ar;
    }

    public inline function lineScales():ReadOnlyAVector2D<Float> {
        return _lineScales;
    }

    public inline function resize(ww:Float, wh:Float) {
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
}
