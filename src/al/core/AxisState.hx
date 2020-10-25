package al.core;
/**
*  Stores logic layout state for item and provides access to apply calculated value to target
**/

import al.appliers.PropertyAccessors.StoreApplier;
import al.layouts.data.LayoutData.SizeType;
import al.layouts.data.LayoutData.Position;
import al.layouts.data.LayoutData.Size;
import al.appliers.PropertyAccessors.FloatPropertyAccessor;
class AxisState implements AxisApplier {
    var sizeApplier:FloatPropertyAccessor;
    var posApplier:FloatPropertyAccessor;
    public var size(default, null):Size = new Size();
    public var position(default, null):Position = new Position();
    var siblings:Array<AxisApplier> = [];

    public function new() {
        this.sizeApplier = new StoreApplier(1);
        this.posApplier = new StoreApplier(0);
        size.value = 1;
    }

    public function initSize(type:SizeType, size:Float) {
        if (type == fixed) {
            this.size.setFixed(size);
            sizeApplier.setValue(size);
        } else if (type == portion) {
            this.size.setWeight(size);
        }
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
        posApplier.setValue(pos);
        sizeApplier.setValue(size);
        for (s in siblings)
            s.apply(pos, size);
    }


    public function getSize() {
        return sizeApplier.getValue();
    }

    public function getPos() {
        return posApplier.getValue();
    }

    public function isArrangable():Bool {
        return position.type == managed;
    }
}


