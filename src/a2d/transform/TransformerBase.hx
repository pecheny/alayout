package a2d.transform;
import a2d.transform.Resizable;
import Axis2D;
import a2d.Boundbox;
import macros.AVConstructor;
import utils.Signal;
/**
* Transformer provide a function to translate normalized coordinates (i.e. lacated in [0,1] range) into widget bounds.
**/

class TransformerBase implements Resizable {
    // var appliers:AVector2D<TransformatorAxisApplier>;

    @:isVar public var aspects(get, null):ReadOnlyAVector2D<Float> = AVConstructor.create(Axis2D, 1., 1.).readonly();
    var _size = AVConstructor.create(Axis2D, 1., 1.);
    var _pos = AVConstructor.create(Axis2D, 0., 0.);
    public var size(get,null):ReadOnlyAVector2D<Float>;
    public var pos(get,null):ReadOnlyAVector2D<Float>;
    public var changed(default, null):Signal<Void -> Void> = new Signal();

    // public function getAxisApplier(a:Axis2D):AxisApplier {
    //     return appliers[a];
    // }

//todo make own boundbox, exclude al dependency
    var bounds:Boundbox = new Boundbox();

    public function new(aspects:ReadOnlyAVector2D<Float>) {
        this.aspects = aspects;
        // appliers = AVConstructor.factoryCreate(k -> new TransformatorAxisApplier(this, k));
    }

    public function setBounds(x, y, w, h) {
        bounds.set(x, y, w, h);
    }

    public function invalidate() {}

    public function transformValue(c:Axis2D, input:Float):Float {throw "N/A";}

    
    public function resize(w:Float, h:Float):Void {
        _size[horizontal] = w;
        _size[vertical] = h;
        changed.dispatch();
    }

    public function applyAxis(a, p, s) {
        _pos[a] = p;
        _size[a] = s;
        changed.dispatch();
    }

    public function apply(x, w, y, h) {
        _pos[horizontal] = x;
        _size[horizontal] = w;
        _pos[vertical] = y;
        _size[vertical] = h;
        changed.dispatch();
    }

    function get_size():ReadOnlyAVector2D<Float> {
        return _size;
    }

    function get_pos():ReadOnlyAVector2D<Float> {
        return _pos;
    }

    function get_aspects(){
        return aspects;
    }
}
