package al.core;
import al.al2d.Axis2D;
class Boundbox {
    public var size(default, null):Map<Axis2D, Float> = new Map();
    public var pos(default, null):Map<Axis2D, Float> = new Map();

    public function new(x = 0., y = 0., w = 1., h = 1.) {
        size[horizontal] = w;
        size[vertical] = h;
        pos[horizontal] = x;
        pos[vertical] = y;
    }
}
