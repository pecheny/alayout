package a2d;

import al.prop.TransformComponent;
import a2d.transform.LiquidTransformer;
import Axis2D;
import a2d.Stage;
import a2d.Placeholder2D;
import al.core.AxisState;
import al.layouts.data.LayoutData;
import al.utils.PlaceholderBuilder;
import a2d.ProxyWidgetTransform;
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

    public function hp(t:PositionType, val:Float) {
        var custom = switch t {
            case managed:
                null;
            case fixed, percent:
                new Position(t, val);
        }
        factories[horizontal].customPos = custom;
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

    public function vp(t:PositionType, val:Float) {
        var custom = switch t {
            case managed:
                null;
            case fixed, percent:
                new Position(t, val);
        }
        factories[vertical].customPos = custom;
        return this;
    }

    /**
        Add LiquidTransform
    **/
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

    /**
        Add transform prop
    **/
    public function t(s:Float = 1) {
        scale = s;
        return this;
    }

    override function b(name:String = null):Placeholder2D {
        var _l = this._l;
        var _s = this.scale;
        var w = super.b(name);
        if (_l || addLIquid)
            LiquidTransformer.withLiquidTransform(w, s.getAspectRatio());
        if (_s != null) {
            var scale = TransformComponent.getOrCreate(w.entity);
            scale.value = _s;
            var trans = ProxyWidgetTransform.getOrCreate(w.entity, w);
        }
        return w;
    }
}

class Axis2DStateFactory implements AxisFactory {
    public var type:ScreenMeasureUnit;
    public var value:Float;
    // todo ulcertain compat with keepStateAfterBuild
    public var customSize:ISize = null;
    public var customPos:Position = null;

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
        return new AxisState(customPos ?? new Position(), size);
    }

    public function reset() {
        type = pfr;
        value = 1;
        customSize = null;
        customPos = null;
    }
}
