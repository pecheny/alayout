package al.appliers;
import al.appliers.PropertyAccessors.FloatPropertyAccessor;
class DynamicPropertyAccessor implements FloatPropertyAccessor {
    var get:Void -> Float;
    var set:Float -> Void;

    public function new(get:Void -> Float, set:Float -> Void) {
        this.get = get;
        this.set = set;
    }

    public function setValue(val:Float):Void {
        set(val);
    }

    public function getValue():Float {
        return get();
    }
}

