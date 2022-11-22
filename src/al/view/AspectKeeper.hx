package al.view;

import a2d.Boundbox;
import macros.AVConstructor;
import Axis2D;
import al.core.AxisApplier;

class AspectKeeper {
    var bounds:Boundbox;
    var target:AVector2D<AxisApplier>;
    var size = AVConstructor.create(Axis2D, 1., 1.);
    var pos = AVConstructor.create(Axis2D, 0., 0.);
    var ownSizeAppliers:AVector2D<AxisApplier>;

    public function new(targetStates:AVector2D<AxisApplier>, bounds:Boundbox) {
        this.bounds = bounds;
        this.target = targetStates;
        ownSizeAppliers = AVConstructor.factoryCreate(Axis2D, axis -> new KeeperAxisApplier(pos, size, this, axis));
    }

    public function refresh() {
        var scale = 9999.;
        for (a in Axis2D) {
            var _scale = size[a] / bounds.size[a];
            if (_scale < scale)
                scale = _scale;
        }

        for (a in Axis2D) {
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

    var size:AVector2D<Float>;
    var pos:AVector2D<Float>;

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
