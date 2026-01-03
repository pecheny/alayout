package a2d;

import Axis2D;
import al.Builder;
import a2d.Placeholder2D;
import a2d.Widget;
import al.core.AxisApplier;
import al.prop.ScaleComponent;
import macros.AVConstructor;

enum abstract ProxyWidgetTransformScaleMode(Int) {
    var scale;
    var paddings;
}

@:build(ec.macros.Macros.buildGetOrCreate())
class ProxyWidgetTransform extends Widget {
    public var mode:ProxyWidgetTransformScaleMode = ProxyWidgetTransformScaleMode.scale;

    public var target(default, null):Placeholder2D;

    var transform:AVector2D<TransformAxisApplier> = AVConstructor.empty();
    @:once var scale:ScaleComponent;

    public function new(ph:Placeholder2D) {
        target = Builder.ph();
        ph.entity.addComponent(target);
        for (a in Axis2D) {
            var ta = new TransformAxisApplier(target.axisStates[a]);
            ph.axisStates[a].addSibling(ta);
            transform[a] = ta;
        }
        super(ph);
    }

    override function get_ph():Placeholder2D {
        return target;
    }

    override function init() {
        super.init();
        scale.onChange.listen(onScale);
        onScale();
    }

    public function setPadding(v:Float) {
        for (a in Axis2D) {
            var aa = transform[a];
            aa.padding = v;
        }
        applyAxis();
    }

    function onScale() {
        switch mode {
            case paddings:
                var h = ph.axisStates[vertical].getSize();
                var padding = (h - h * scale.value) / 2;
                setPadding(padding);
            case scale:
                for (a in Axis2D) {
                    var size = ph.axisStates[a].getSize();
                    var padding = - (size * this.scale.value - size) / 2;
                    transform[a].padding = padding;
                    var aa = super.ph.axisStates[a];
                    aa.apply(aa.getPos(), aa.getSize());
                }
        }
    }

    function applyAxis() {
        for (a in Axis2D) {
            var aa = super.ph.axisStates[a];
            aa.apply(aa.getPos(), aa.getSize());
        }
    }

    public static function getInnerPh(ph:Placeholder2D):Placeholder2D {
        var instance = ph.entity.getComponent(ProxyWidgetTransform);
        if (instance != null)
            return instance.target;
        return ph;
    }

    public static function grantInnerTransformPh(ph:Placeholder2D) {
        var scale = ScaleComponent.getOrCreate(ph.entity);
        scale.value = 1.;
        var prtr = ProxyWidgetTransform.getOrCreate(ph.entity, ph);
        return prtr.target;
    }
}

class TransformAxisApplier implements AxisApplier {
    var target:AxisApplier;

    public var offset:Float = 0;
    public var padding:Float = 0;

    public function new(target) {
        this.target = target;
    }

    public function apply(pos:Float, size:Float) {
        target.apply(offset + padding + pos, size - padding * 2);
    }
}
