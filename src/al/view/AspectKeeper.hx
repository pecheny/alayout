package al.view;
import al.al2d.Widget2D.AxisCollection2D;
import al.al2d.Axis2D;
import al.core.AxisApplier;
import al.al2d.Boundbox;
class AspectKeeper {
    var bounds:Boundbox;
    var target:AxisCollection2D<AxisApplier>;
    var size:AxisCollection2D<Float> = new AxisCollection2D();
    var pos:AxisCollection2D<Float> = new AxisCollection2D();
    var ownSizeAppliers:AxisCollection2D<AxisApplier> = new AxisCollection2D();

    public function new(targetStates:AxisCollection2D<AxisApplier>, bounds:Boundbox) {
        this.bounds = bounds;
        this.target = targetStates;
        for (axis in Axis2D.keys) {
            size[axis] = 1;
            ownSizeAppliers[axis] = new KeeperAxisApplier(pos, size, this, axis);
        }
    }

    public function refresh() {
        var scale = 9999.;
        for (a in Axis2D.keys) {
            var _scale = size[a] / bounds.size[a];
            if (_scale < scale)
                scale = _scale;
        }

        for (a in Axis2D.keys) {
            var free = size[a] - bounds.size[a] * scale;
            var pos = -scale * bounds.pos[a] + free / 2;
            target[a].apply(pos, scale);
        }
    }


    public function getApplier(a:Axis2D) {
        return ownSizeAppliers[a];
    }
}

class KeeperAxisApplier implements AxisApplier {
    var key:Axis2D;
    var keeper:AspectKeeper;
    var size:AxisCollection2D<Float> = new AxisCollection2D();
    var pos:AxisCollection2D<Float> = new AxisCollection2D();

    public function new(p, s, k, a) {
        this.pos = p;
        this.size = s;
        this.keeper = k;
        this.key = a;
    }

    public function apply(pos:Float, size:Float):Void {
        this.pos[key] = pos;
        this.size[key] = size;
        keeper.refresh();
    }

}

