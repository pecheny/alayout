package a2d.transform;

/**
 *  Calculates axis-aligned thickness for use in normalized space of widget.
 *  Measure units of thickness expressed in portion of 2x(Smallest window dimension).
 *  @see transform.AspectRatio
 *  LineScaleCalcularor registers on widget axis state so be sure to create it before registering dependent redraw.
**/
import Axis2D;
import a2d.AspectRatio;

class LineThicknessCalculator implements Resizable {
    var scale:Float;
    var _lineScales:AVector2D<Float>;
    var aspectRatio:AspectRatio;

    public function new(ar:AspectRatio, target:AVector2D<Float>, scale = 1.) {
        this.scale = scale;
        _lineScales = target;
        this.aspectRatio = ar;
    }

    public inline function lineScales():ReadOnlyAVector2D<Float> {
        return _lineScales;
    }

    public inline function resize(ww:Float, wh:Float) {
        if (aspectRatio[horizontal] < aspectRatio[vertical]) {
            var wAsp = ww / wh;
            _lineScales[vertical] = scale / wh;
            _lineScales[horizontal] = _lineScales[vertical] / wAsp;
        } else {
            var wAsp = wh / ww;
            _lineScales[horizontal] = scale / ww;
            _lineScales[vertical] = _lineScales[horizontal] / wAsp;
        }
    }
}
