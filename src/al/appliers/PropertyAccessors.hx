package al.appliers;


@:autoBuild(al.appliers.buildmacro.AccessorMacro.build())
interface PropertyAccessor<Tval> {
    function setValue(val:Float):Void;
    function getValue():Float;
}


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
    var children:Array<FloatPropertyWriter> = [];

    override public function setValue(val:Float):Void {
        super.setValue(val);
        for (child in children)
            child.setValue(val);
    }

    public function addChild(c) {
        children.push(c);
    }
}

interface FloatPropertyWriter {
    function setValue(val:Float):Void;
}

interface FloatPropertyReader {
    function getValue():Float;
}

class FloatProvertyValue extends ConstFloatPropertyReader implements FloatPropertyAccessor {
    public function setValue(val:Float):Void {
        this.val = val;
    }
}

class ConstFloatPropertyReader implements FloatPropertyReader {
    var val:Float;
    public static var ZERO(default, never) = new ConstFloatPropertyReader(0);
    public function new(v) this.val = v;

    public function getValue():Float {
        return val;
    }
}

interface FloatPropertyAccessor extends FloatPropertyReader extends FloatPropertyWriter {
}

class FloatValue {
    public var value(default, set):Float = 0;

    public function new() {}

    function set_value(value:Float):Float {
        return this.value = value;
    }
}

class SumPropertyWriter implements FloatPropertyWriter {
    var summand:FloatPropertyReader;
    var target:FloatPropertyWriter;
    public function new(summand:FloatPropertyReader, target:FloatPropertyWriter) {
        this.summand = summand;
        this.target = target;
    }

    public function setValue(val:Float):Void {
        target.setValue(val + summand.getValue());
    }
}

class MultiplierReader implements FloatPropertyReader {
    var src:FloatPropertyReader;
    public var multiplier:Float = 1;
    public function new (src,  mul) {
        this.src = src;
        this.multiplier = mul;
    }

    public function getValue():Float {
        return src.getValue() * multiplier;
    }
}

class SummandReader implements FloatPropertyReader {
    var src:FloatPropertyReader;
    public var summand:Float = 1;
    public function new (src,  sum) {
        this.src = src;
        this.summand = sum;
    }

    public function getValue():Float {
        return src.getValue() + summand;
    }
}
