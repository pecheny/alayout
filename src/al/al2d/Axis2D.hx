package al.al2d;
@:enum abstract Axis2D(String) to String {
    public static var keys = [horizontal, vertical];
    var horizontal = "horizontal";
    var vertical = "vertical";

    @:to public function toInt() {
        return
            if (this == horizontal)
                0
            else
                1;
    }

    public static inline function fromInt(i:Int) {
        return switch i {
            case 0: horizontal;
            case 1: vertical;
            case _:throw "Wrong!";
        }
    }
}

typedef AxisCollection<T> = Map<Axis2D, T>;
