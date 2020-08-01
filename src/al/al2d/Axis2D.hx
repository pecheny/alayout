package al.al2d;
@:enum abstract Axis2D(Int) to Int{
    public static var keys = [ horizontal, vertical,];
    var horizontal = 0;
    var vertical = 1;
    inline private static var HORIZONTAL_STRING:String = "horizontal";
    inline private static var VERTIVAL_STRING:String = "vertical";

    @:to public function toString():String {
        return
            if (this == horizontal)
                HORIZONTAL_STRING
            else
                VERTIVAL_STRING;
    }

    @:from static inline function fromString(s:String) {
        return switch s {
            case HORIZONTAL_STRING : horizontal;
            case VERTIVAL_STRING : vertical;
            case s : throw "Cant parse axis ";
        }
    }

    public static inline function fromInt(v:Int) {
        #if debug
        if(v!=0 &&v!=1)
            throw 'wrong axis $v';
        #end
        return cast v;
    }

    public inline function toInt():Int return this;
}


