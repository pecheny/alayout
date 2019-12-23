package al.view;
import al.al2d.Axis2D;
import al.appliers.PropertyAccessors.FloatPropertyWriter;
import al.core.AxisApplier;
import al.core.Boundbox;
class AspectKeeper {
    var bounds:Boundbox;
    var target:Map<Axis2D, AxisApplier>;
    var size:Map<Axis2D, Float> = new Map();
    var pos:Map<Axis2D, Float> = new Map();
    var ownSizeAppliers:Map<Axis2D, FloatPropertyWriter> = new Map();
    var ownPosAppliers:Map<Axis2D, FloatPropertyWriter> = new Map();

    public function new(targetStates:Map<Axis2D, AxisApplier>, bounds:Boundbox) {
        this.bounds = bounds;
        this.target = targetStates;
        for (axis in Axis2D.keys){
            size[axis] = 1;
            ownSizeAppliers[axis] = new KeeperAxisApplier(size, this, axis);
            ownPosAppliers[axis] = new KeeperAxisApplier(pos, this, axis);
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

    public function getSizeApplier(a:Axis2D){
        return ownSizeAppliers[a];
    }

    public function getPosApplier(a:Axis2D){
        return ownPosAppliers[a];
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

