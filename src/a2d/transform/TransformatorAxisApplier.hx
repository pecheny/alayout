package a2d.transform;
import a2d.transform.TransformerBase;
#if taxis
import Axis2D;
#else
typedef Axis2D = Int;
typedef AVector2D<T> = haxe.ds.Vector<T>; 
#end
class TransformatorAxisApplier #if taxis implements al.core.AxisApplier #end {
    var axisIntex:Axis2D;
    var target:TransformerBase;

    public function new(target:TransformerBase, c) {
        this.target = target;
        axisIntex = c;
    }

    public function apply(_pos:Float, _size:Float):Void {
        var p:AVector2D<Float> = @:privateAccess target._pos;
        p[axisIntex] = _pos;
        var s:AVector2D<Float> = @:privateAccess target._size;
        s[axisIntex] = _size;
        target.changed.dispatch();
    }
}
