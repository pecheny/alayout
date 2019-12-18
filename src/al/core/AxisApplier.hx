package al.core;
import al.appliers.PropertyAccessors.FloatPropertyWriter;
interface AxisApplier {
    function applyPos(v:Float):Void;

    function applySize(v:Float):Void;
}

class SimpleAxisApplier implements AxisApplier {
    var pos:FloatPropertyWriter;
    var size:FloatPropertyWriter;
    public function new(pos:FloatPropertyWriter, size:FloatPropertyWriter) {
        this.pos = pos;
        this.size = size;
    }

    public function applyPos(v:Float):Void {
        pos.setValue(v);
    }

    public function applySize(v:Float):Void {
        size.setValue(v);
    }
}