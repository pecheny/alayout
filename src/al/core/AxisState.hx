package al.core;
/**
*  Stores logic layout state for item and provides access to apply calculated value to target
**/

import al.layouts.data.LayoutData.SizeType;
import al.layouts.data.LayoutData.Position;
import al.layouts.data.LayoutData.Size;
import al.appliers.PropertyAccessors.AppliersContainer;
import al.appliers.PropertyAccessors.FloatPropertyAccessor;
class AxisState {
    var sizeApplier:FloatPropertyAccessor;
    var posApplier:FloatPropertyAccessor;
    public var size(default, null):Size = new Size();
    public var position(default, null):Position = new Position();

    public function new() {}

    public function init(sizeApplier:FloatPropertyAccessor, posApplier:FloatPropertyAccessor) {
        this.sizeApplier = sizeApplier;
        this.posApplier = posApplier;
        size.value = 1;
        return this;
    }

    public function addSizeApplier(a:FloatPropertyAccessor) {
        sizeApplier = addApplier(sizeApplier, a);
    }

    public function addPosApplier(a:FloatPropertyAccessor) {
        posApplier = addApplier(posApplier, a);
    }

    inline function addApplier(parent:FloatPropertyAccessor, child:FloatPropertyAccessor) {
        if (Std.is(parent, AppliersContainer)) {
            cast(parent, AppliersContainer).addChild(child);
            return parent;
        } else {
            var cont = new AppliersContainer(parent.getValue());
            cont.addChild(parent);
            cont.addChild(child);
            return cont;
        }
    }


    public function initSize(type:SizeType, size:Float) {
        if(type == fixed) {
            this.size.setFixed(size);
            sizeApplier.setValue(size);
        } else if (type == portion) {
            this.size.setWeight(size);
        }
    }

    public function applySize(value) {
        sizeApplier.setValue(value);
    }

    public function applyPos(value) {
        posApplier.setValue(value);
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

