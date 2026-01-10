package al.prop;

import macros.AVConstructor;
import fu.Signal;
import AVector;
import Axis2D;

@:build(ec.macros.Macros.buildGetOrCreate())
class TransformComponent {
    public var onChange(default, null):Signal<Void->Void> = new Signal();
    public var value(get, set):Float;
    @:isVar public var scale(get, set) = 1.;

    public var offset:ReadOnlyAVector2D<Float> = AVConstructor.create(0., 0.);

    public function new() {}

    public function setOffset(axis, value) {
        var offset:AVector2D<Float> = cast this.offset;
        offset[axis] = value;
        onChange.dispatch();
    }

    public function setBothOffsets(hor, vert) {
        var offset:AVector2D<Float> = cast this.offset;
        offset[horizontal] = hor;
        offset[vertical] = vert;
        onChange.dispatch();
    }

    function set_value(value:Float):Float {
        return this.scale = value;
    }

    function get_value():Float {
        return scale;
    }

    function set_scale(value) {
        this.scale = value;
        onChange.dispatch();
        return value;
    }

    function get_scale() {
        return scale;
    }
}
