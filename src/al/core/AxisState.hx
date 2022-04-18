package al.core;
import al.layouts.data.LayoutData;
/**
*  Stores logic layout state for item and provides access to apply calculated value to target
**/

class AxisState implements AxisApplier {
    var sizeVal:Float = 1;
    var posVal:Float = 0;
    public var size(default, null):ISize;
    public var position(default, null):Position;
    var siblings:Array<AxisApplier> = [];

    public function new(p, s) {
        this.position = p;
        this.size = s;
    }

    public function addSibling(aa:AxisApplier) {
        if (aa == this)
            throw "Dont do this";
        siblings.push(aa);
        aa.apply(getPos(), getSize());
    }

    public function removeSibling(aa:AxisApplier) {
        siblings.remove(aa);
    }

    public function apply(pos:Float, size:Float):Void {
        posVal = pos;
        sizeVal = size;
        for (s in siblings)
            s.apply(pos, size);
    }

    public function getSize() {
        return sizeVal;
    }

    public function getPos() {
        return posVal;
    }

    public function isArrangable():Bool {
        return position.type == managed;
    }
}


