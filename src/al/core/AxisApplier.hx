package al.core;
import al.appliers.PropertyAccessors.FloatPropertyWriter;
interface AxisApplier {
    function apply(pos:Float, size:Float):Void;
}

class SimpleAxisApplier implements AxisApplier {
    var pos:FloatPropertyWriter;
    var size:FloatPropertyWriter;
    public function new(pos:FloatPropertyWriter, size:FloatPropertyWriter) {
        this.pos = pos;
        this.size = size;
    }

    public function apply(pos:Float, size:Float):Void {
        this.pos.setValue(pos);
        this.size.setValue(size);
    }
}

class StorageAxisApplier implements AxisApplier{
    public var pos:Float;
    public var size:Float;
    public function new(){}

    public function apply(pos:Float, size:Float):Void {
        this.pos = pos;
        this.size = size;
    }
}

