package al.al2d;
import Axis2D;
class GlAxis2DDirection {
    public static function get(a:Axis2D):AxisDirection {
        if (a==vertical)
            return inverted;
        return direct;
    }
}

@:enum abstract AxisDirection(Int) to Int {
    var direct = 1;
    var inverted = -1;
}
