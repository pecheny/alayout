package al.core;
/**
*  Stores logic layout state for item and provides access to apply calculated value to target
**/

import al.appliers.PropertyAccessors.StoreApplier;
import al.appliers.PropertyAccessors.FloatPropertyWriter;
import al.layouts.data.LayoutData.SizeType;
import al.layouts.data.LayoutData.Position;
import al.layouts.data.LayoutData.Size;
import al.appliers.PropertyAccessors.AppliersContainer;
import al.appliers.PropertyAccessors.FloatPropertyAccessor;
class AxisState implements AxisApplier {
    var sizeApplier:FloatPropertyAccessor;
    var posApplier:FloatPropertyAccessor;
    public var size(default, null):Size = new Size();
    public var position(default, null):Position = new Position();
    var siblings:Array<AxisApplier> = [];
    var postSiblings:Array<AxisApplier> = [];

    public function new() {
        this.sizeApplier = new StoreApplier(1);
        this.posApplier = new StoreApplier(0);
        size.value = 1;
    }

    public function addSizeApplier(a:FloatPropertyWriter) {
        sizeApplier = addApplier(sizeApplier, a);
    }

    public function addPosApplier(a:FloatPropertyWriter) {
        posApplier = addApplier(posApplier, a);
    }

    inline function addApplier(parent:FloatPropertyAccessor, child:FloatPropertyWriter):FloatPropertyAccessor {
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

    public function addSibling(aa:AxisApplier, postValueApplying = false){
        if (postValueApplying)
            postSiblings.push(aa)
        else
            siblings.push(aa);
    }

    public function applySize(value) {
        for (s in siblings)
            s.applySize(value);
        sizeApplier.setValue(value);
        for (s in postSiblings)
            s.applySize(value);
    }

    public function applyPos(value) {
        for (s in siblings)
            s.applyPos(value);
        posApplier.setValue(value);
        for (s in postSiblings)
            s.applyPos(value);
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


