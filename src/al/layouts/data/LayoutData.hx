package al.layouts.data;
import al.appliers.PropertyAccessors.FloatValue;
//enum LayoutItem {
//    Range(minSize:Pixels, fluidIncreace:Weight);
//    Weightd(w:Weight);
//    Unmanaged(pos:Length, size:Length);
//}
//
//enum Length {
//    Fixed(value:Pixels);
//    Percent(value:Percent);
//}
//abstract Percent(Float) {
//    public inline function new(val) this = val;
//
//    public inline function toMultiplier():Float return this / 100;
//    public inline function raw() return this;
//    @:op(A + B) static private inline function __aPlusB (a:Percent, b:Percent):Percent return new Percent(a.raw() + b.raw());
//    @:op(A - B) static private inline function __aMinusB (a:Percent, b:Percent):Percent return new Percent(a.raw() - b.raw());
//}
//abstract Pixels(Float) {
//    public inline function new(val) this = val;
//
//    @:op(A + B) static private inline function __aPlusB (a:Pixels, b:Pixels):Pixels;// return new Pixels(a + b);
//    @:op(A - B) static private inline function __aMinusB (a:Pixels, b:Pixels):Pixels;// return new Pixels(a - b);
//    @:op(A * B) static private inline function __aMulB (a:Pixels, b:Float);// return new Pixels(a * b);
//    @:op(A / B) static private inline function __aDivB (a:Pixels, b:Float);// return new Pixels(a / b);
//    @:op(A / B) static private inline function __aDivB2 (a:Pixels, b:Pixels);// return (a / b);
//}
//
//abstract Weight(Float) to Float {
//    public inline function new(val) this = val;
//
//    @:op(A + B) static private inline function __aPlusB (a:Weight, b:Weight):Weight return new Weight(a + b);
//    @:op(A - B) static private inline function __aMinusB (a:Weight, b:Weight):Weight return new Weight(a - b);
//    @:op(A * B) static private inline function __aMulB (a:Weight, b:Float) return new Weight(a * b);
//    @:op(A / B) static private inline function __aDivB (a:Weight, b:Float) return new Weight(a / b);
////    @:op(A / B) static private inline function __aDivB2 (a:Weight, b:Weight) return (a / b);
//}
//// ** from first iteration


class Position extends FloatValue {
    public var type:PositionType = managed;
}


@:enum abstract PositionType(String) from String to String {
    var fixed = "fixed";
    var percent = "percent";
    var managed = "managed";
}

class Size extends FloatValue {
    public var type(default, null):SizeType = portion;
    public var maxValue:Null<Float>;

    public function setWeight(w:Float) {
        type = portion;
        value = w;
    }

    public function setFixed(w:Float) {
        type = fixed;
        value = w;
    }
}
@:enum abstract SizeType(String) from String to String {
    var fixed = "fixed";
    var portion = "portion";
    var percent = "percent";
    var range = "range";
}


