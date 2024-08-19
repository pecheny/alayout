package al.al2d;
import Axis2D;
import a2d.Stage;
import al.al2d.Placeholder2D;
import al.core.AxisState;
import al.layouts.data.LayoutData;
import al.utils.PlaceholderBuilder;
import al.al2d.ProxyWidgetTransform;
import al.prop.ScaleComponent;
import macros.AVConstructor;


class PlaceholderBuilder2D extends PlaceholderBuilder<Axis2DStateFactory> {
    var s:Stage;
    var addLIquid:Bool; // all the time
    var _l:Bool; // once
    var scale:Null<Float>;

    public function new(s:Stage, addLiquid = false) {
        this.s = s;
        this.addLIquid = addLiquid;
        factories = AVConstructor.factoryCreate(a -> new Axis2DStateFactory(a, s));
    }

    public function h(t:ScreenMeasureUnit, v:Float) {
        factories[horizontal].type = t;
        factories[horizontal].value = v;
        return this;
    }

    public function ch(custom:ISize) {
        factories[horizontal].customSize = custom;
        return this;
    }

    public function v(t:ScreenMeasureUnit, v:Float) {
        factories[vertical].type = t;
        factories[vertical].value = v;
        return this;
    }

    public function cv(custom:ISize) {
        factories[vertical].customSize = custom;
        return this;
    }

    public function l() {
        _l = true;
        return this;
    }

    override function reset() {
        super.reset();
        _l = false;
        scale = null;
        for (k in Axis2D)
            factories[k].reset();
    }

    public function t(s:Float = 1) {
        scale = s;
        return this;
    }

    override function b(name:String = null):Placeholder2D {
        var _l = this._l;
        var _s = this.scale;
        var w = super.b(name);
        if (_l || addLIquid)
            widgets.utils.Utils.withLiquidTransform(w, s.getAspectRatio());
        if (_s != null) {
            var scale = ScaleComponent.getOrCreate(w.entity);
            scale.value = this.scale;
            var trans = new ProxyWidgetTransform(w);
            w.entity.addComponent(trans);
        }
        return w;
    }
}

class Axis2DStateFactory implements AxisFactory {
    public var type:ScreenMeasureUnit;
    public var value:Float;
    // todo ulcertain compat with keepStateAfterBuild
    public var customSize:ISize = null;

    var screen:Stage;
    var axis:Axis2D;

    public function new(a, s) {
        this.axis = a;
        this.screen = s;
        reset();
    }

    public function create() {
        var size = if (customSize != null) customSize else switch type {
            case sfr: new FixedSize(value * 2); // todo /2 its fixed size in units of the parent
            case pfr: new FractionSize(value);
            case px: new PixelSize(axis, screen, value);
        }
        customSize = null;
        return new AxisState(new Position(), size);
    }

    public function reset() {
        type = pfr;
        value = 1;
        customSize = null;
    }
}
