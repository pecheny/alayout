package al.core;

#if array_axis_collection
abstract AxisCollection<TAxis:al.core.WidgetContainer.AxisKeyBase, T>(Array<T>) {
    public inline function new() this = [];
    @:arrayAccess public inline function get(a:TAxis):T return this[a];
    @:arrayAccess public inline function set(a:TAxis, val:T):T return this[a] = val;

    public inline function hasValueFor(a:TAxis) {
        return a < this.length && this[a] != null;
    }

    public inline function keys():AxisIterator<TAxis> return new AxisIterator<TAxis>(0, this.length);
    public inline function iterator():AxisIterator<TAxis> return new AxisIterator<TAxis>(0, this.length);
//    public inline function iterator():AxisIterator<TAxis> return cast 0...this.length;
}

/**
* Copy of IntIterator with typing.
**/
class AxisIterator<TAxis:al.core.WidgetContainer.AxisKeyBase> {
    var min:Int;
    var max:Int;

    public inline function new(min:Int, max:Int) {
        this.min = min;
        this.max = max;
    }

    public inline function hasNext() {
        return min < max;
    }

    public inline function next():TAxis {
        return cast min++;
    }
}
#else

//typedef AxisCollection<TAxis:al.core.WidgetContainer.AxisKeyBase, T> = Map<TAxis, T>;
@:forward(keys, copy)
abstract AxisCollection<TAxis:al.core.WidgetContainer.AxisKeyBase, T> (Map<TAxis, T>) from Map<TAxis, T> {
    public inline function new() this = new Map();

    @:arrayAccess public inline function get(a:TAxis):T {
        #if debug
        if (!hasValueFor(a))
            throw "no value for axis " + a;
        #end
        return this[a];
    }

    @:arrayAccess public inline function set(a:TAxis, val:T):T return this[a] = val;

    public inline function hasValueFor(a:TAxis) return this.exists(a);
}
#end
