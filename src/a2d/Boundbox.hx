package a2d;

import Axis2D;
import macros.AVConstructor;
class Boundbox {
    public var size(default, null) = AVConstructor.create(Axis2D, 1.,1.);
    public var pos(default, null) = AVConstructor.create(Axis2D, 0.,0.);

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
