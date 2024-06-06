package al.core;

import Axis;
import al.core.AxisApplier;

interface AllAxisApplier<TAxis:Axis<TAxis>> {
    public function apply(axis:TAxis, pos:Float, size:Float):Void;
}

class AnyAxisApplier<TAxis:Axis<TAxis>> implements AxisApplier {
    var axisIntex:TAxis;
    var target:AllAxisApplier<TAxis>;

    public function new(target:AllAxisApplier<TAxis>, a:TAxis) {
        this.target = target;
        axisIntex = a;
    }

    public function apply(pos:Float, size:Float):Void {
        target.apply(axisIntex, pos, size);
    }
}
