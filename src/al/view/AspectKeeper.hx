package al.view;
import al.al2d.Widget2D.AxisCollection2D;
import al.al2d.Axis2D;
import al.appliers.PropertyAccessors.FloatPropertyWriter;
import al.core.AxisApplier;
import al.al2d.Boundbox;
class AspectKeeper {
    var bounds:Boundbox;
    var target:AxisCollection2D<AxisApplier>;
    var size:AxisCollection2D<Float> = new AxisCollection2D();
    var pos:AxisCollection2D<Float> = new AxisCollection2D();
    var ownSizeAppliers:AxisCollection2D<FloatPropertyWriter> = new AxisCollection2D();
    var ownPosAppliers:AxisCollection2D<FloatPropertyWriter> = new AxisCollection2D();

    public function new(targetStates:AxisCollection2D<AxisApplier>, bounds:Boundbox) {
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
    var target:AxisCollection2D<Float>;
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

