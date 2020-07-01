package al.al2d;
import al.al2d.Widget2D.AxisCollection2D;
import al.al2d.Axis2D;
class Boundbox {
    public var size(default, null):AxisCollection2D<Float> = new AxisCollection2D();
    public var pos(default, null):AxisCollection2D<Float> = new AxisCollection2D();

    public function new(x = 0., y = 0., w = 1., h = 1.) {
        set(x, y, w, h);
    }

    inline public function set(x = 0., y = 0., w = 1., h = 1.) {
        size[horizontal] = w;
        size[vertical] = h;
        pos[horizontal] = x;
        pos[vertical] = y;
    }
}
