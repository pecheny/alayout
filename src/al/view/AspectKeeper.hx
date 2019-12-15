package al.view;
import al.core.AxisApplier;
import al.appliers.PropertyAccessors.FloatPropertyWriter;
import al.al2d.Axis2D;
import al.core.AxisState;
import al.core.Boundbox;
class AspectKeeper {
    var bounds:Boundbox;
    var target:Map<Axis2D, AxisApplier>;
    var size:Map<Axis2D, Float> = new Map();
    var ownAppliers:Map<Axis2D, FloatPropertyWriter> = new Map();

    public function new(targetStates:Map<Axis2D, AxisApplier>, bounds:Boundbox) {
        this.bounds = bounds;
        this.target = targetStates;
        for (axis in Axis2D.keys){
            size[axis] = 1;
            ownAppliers[axis] = new KeeperAxisApplier(size, this, axis);
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
            target[a].applySize(scale);
            var free = size[a] - bounds.size[a] * scale;
            target[a].applyPos(-scale * bounds.pos[a] + free / 2);
        }
    }

    public function getAxisApplier(a:Axis2D){
        return ownAppliers[a];
    }

    public function applySize(a:Axis2D, val:Float) {
        size[a] = val;
        refresh();
    }
}

class KeeperAxisApplier implements FloatPropertyWriter {
    var target:Map<Axis2D, Float>;
    var key:Axis2D;
    var keeper:AspectKeeper;
    public function new(t, k, a) {
        this.target = t;
        this.keeper = k;
        this.key = a;
    }

    public function setValue(val:Float):Void {
        target[key] = val;
        keeper.refresh();
    }
}

