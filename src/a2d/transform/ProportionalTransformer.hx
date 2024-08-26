package a2d.transform;
import Axis2D;
class ProportionalTransformer extends TransformerBase {
    var localScale = 1.;

    override public function transformValue(a:Axis2D, input:Float) {
        var sign = a == 0 ? 1 : -1;
        var free = size[a] - bounds.size[a] * localScale;
        var lp = (input - bounds.pos[a]) * localScale + free / 2;
        return
            ((pos[a] + lp) / aspects[a] - 1) * sign;
    }


    override public function invalidate() {
        localScale = 9999.;
        for (a in Axis2D) {
            var _scale = size[a] / bounds.size[a];
            if (_scale < localScale)
                localScale = _scale;
        }
    }
}



