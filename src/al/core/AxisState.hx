package al.core;
/**
*  Stores logic layout state for item and provides access to apply calculated value to target
**/

import al.layouts.data.LayoutData.Position;
import al.layouts.data.LayoutData.Size;
import al.layouts.data.LayoutData.SizeType;
class AxisState implements AxisApplier {
    var sizeVal:Float = 1;
    var posVal:Float = 0;
    public var size(default, null):Size = new Size();
    public var position(default, null):Position = new Position();
    var siblings:Array<AxisApplier> = [];

    public function new() {
        size.value = 1;
    }

    public function initSize(type:SizeType, size:Float) {
        if (type == fixed) {
            this.size.setFixed(size);
            sizeVal = size;
        } else if (type == portion) {
            this.size.setWeight(size);
        }
        return this;
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


