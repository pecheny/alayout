package a2d.transform;

import Axis2D;
import a2d.AspectRatioProvider;
import a2d.Placeholder2D;
import a2d.Widget;
import a2d.transform.LineThicknessCalculator;
import al.core.AxisApplier;
import gl.AttribSet;
import graphics.shapes.Bar;
import macros.AVConstructor;

/**
    Utility class to calculate multipliers for transformation coordinates from widget's normal space to screen units.
    If you want add shape of certain size on the screen to a ShapeWidget, use this class.
**/
@:build(ec.macros.Macros.buildGetOrCreate())
class WidgetToScreenRatio extends Widget {
    @:once var ratioProvider:AspectRatioProvider;
    var targetRatio = AVConstructor.create(Axis2D, 1., 1.);
    var scale:Float;
    function new(ph, scale) {
        this.scale = scale;
        super(ph);
    }

    override function init() {
        var lineCalc = new LineThicknessCalculator(ratioProvider.getAspectRatio(), targetRatio, scale);
        var aa = new Axis2DApplier(lineCalc);
        for (a in Axis2D)
            ph.axisStates[a].addSibling(aa.appliers[a]);
    }

    public function getRatio():ReadOnlyAVector2D<Float> {
        return targetRatio;
    }
}


class Axis2DApplier {
    public var appliers(default, null):ReadOnlyAVector2D<StorageAxisApplier>;

    var target:LineThicknessCalculator;

    public function new(lthc):Void {
        this.target = lthc;
        appliers = AVConstructor.factoryCreate(Axis2D, a -> new StorageAxisApplier(this));
    }

    public function refresh() {
        target.resize(appliers[Axis2D.horizontal].size, appliers[vertical].size);
    }
}

class StorageAxisApplier implements AxisApplier {
    public var pos:Float;
    public var size:Float;

    var target:Axis2DApplier;

    public function new(t) {
        this.target = t;
    }

    public function apply(pos:Float, size:Float):Void {
        this.pos = pos;
        this.size = size;
        target.refresh();
    }
}
