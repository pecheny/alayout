package al.view;

import Axis2D;
import a2d.Boundbox;
import al.al2d.Placeholder2D;
import al.al2d.Widget;
import al.core.AxisApplier;
import macros.AVConstructor;

class AspectLimiter extends Widget implements AxisApplier {
    var maxRatio = 0.;
    var minRatio = 0.;
    var target:Placeholder2D;

    public function new(ph:Placeholder2D, target:Placeholder2D, maxRatio = 4 / 3, minRatio = 3 / 4) {
        super(ph);
        this.maxRatio = maxRatio;
        this.minRatio = minRatio;
        this.target = target;
        ph.axisStates[horizontal].addSibling(this);
        ph.axisStates[vertical].addSibling(this);
    }

    public function apply(_:Float, _:Float):Void {
        var w = ph.axisStates[horizontal].getSize();
        var h = ph.axisStates[vertical].getSize();
        var x = ph.axisStates[horizontal].getPos();
        var y = ph.axisStates[vertical].getPos();

        if (maxRatio > 0 && w / h > maxRatio) {
            var nw = h * maxRatio;
            var free = w - nw;
            target.axisStates[horizontal].apply(x + free / 2, nw);
            target.axisStates[vertical].apply(y, h);
        } else if (minRatio > 0 && w / h < minRatio) {
            var nh = w / minRatio;
            var free = h - nh;
            target.axisStates[horizontal].apply(x, w);
            target.axisStates[vertical].apply(y + free / 2, nh);
        } else {
            target.axisStates[horizontal].apply(x, w);
            target.axisStates[vertical].apply(y, h);
        }
    }
}
