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

class FixedSize implements ISize {
    var value:Float;
    public function new (v) {
        this.value = v;
    }

    public function getPortion():Float {
        return 0;
    }

    public function getFixed():Float {
        return value;
    }
}

class FractionSize implements ISize {
    var value:Float;
    public function new (v) {
        this.value = v;
    }

    public function getPortion():Float {
        return value;
    }

    public function getFixed():Float {
        return 0;
    }
}
