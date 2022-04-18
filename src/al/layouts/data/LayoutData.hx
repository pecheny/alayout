package al.layouts.data;


class Position {
    public var type:PositionType = managed;
    public var value:Float = 0;

    public function new() {}
}


@:enum abstract PositionType(String) from String to String {
    var fixed = "fixed";
    var percent = "percent";
    var managed = "managed";
}

interface ISize {
    public function getPortion():Float;

    public function getFixed():Float;
}

class Size {
    public var type(default, null):SizeType = portion;
    public var maxValue:Null<Float>;
    var value:Float = 1;

    public function new() {}

    public function setWeight(w:Float) {
        type = portion;
        value = w;
    }

    public function setFixed(w:Float) {
        type = fixed;
        value = w;
    }

    public function getPortion() {
        return switch type {
            case fixed, percent: 0;
            case range: maxValue - value;
            case portion : value;
        }
    }

    public function getFixed() {
        return switch type {
            case fixed, range: value;
            case portion, percent: 0;
        }
    }
}
@:enum abstract SizeType(String) from String to String {
    var fixed = "fixed";
    var portion = "portion";
    var percent = "percent";
    var range = "range";
}


