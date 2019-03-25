package al.appliers;

import openfl.display.DisplayObject;
typedef ViewTarget = DisplayObject;



@:autoBuild(al.appliers.buildmacro.AccessorMacro.build())
interface PropertyAccessor<Tval> {
    function setValue(val:Float):Void;
    function getValue():Float;
}

@:property("width") class DOWidthPropertySetter<T:{width:Float}> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
@:property("height") class DOHeightPropertySetter<T:{height:Float}> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
@:property("x") class DOXPropertySetter<T:{x:Float}> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
@:property("y") class DOYPropertySetter<T:{y:Float}> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
typedef Target2D = {x:Float, y:Float, width:Float, height:Float};
@:property("value") class ValueApplier<T:FloatValue> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}

class StoreApplier implements FloatPropertyAccessor {
    var value:Float;
    public function new(value:Float = 0) {
        this.value = value;
    }

    public function setValue(val:Float):Void {
        this.value = val;
    }

    public function getValue():Float {
        return value;
    }
}

class AppliersContainer extends StoreApplier {
    var children:Array<FloatPropertyAccessor> = [];

    override public function setValue(val:Float):Void {
        super.setValue(val);
        for (child in children)
            child.setValue(val);
    }

    public function addChild(c) {
        children.push(c);
    }
}

interface FloatPropertyAccessor {
    function setValue(val:Float):Void;

    function getValue():Float;
}

class FloatValue {
    public var value(default, set):Float;

    public function new() {}

    function set_value(value:Float):Float {
        return this.value = value;
    }
}
