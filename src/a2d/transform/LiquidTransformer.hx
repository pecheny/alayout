package a2d.transform;
import al.al2d.Placeholder2D;
import Axis2D;
import a2d.Boundbox;

using a2d.transform.LiquidTransformer.BoundboxConverters;

class LiquidTransformer extends TransformerBase {
    override public function transformValue(c:Axis2D, input:Float) {
        var sign = c == horizontal ? 1 : -1;
        return
            sign *
            ((pos[c] + bounds.localToGlobal(c, input) * size[c]) / aspects[c] - 1) ;
    }

    public static function withLiquidTransform(w:Placeholder2D, aspectRatio) {
        if (w.entity.hasComponent(LiquidTransformer))
            return w;
        var transformer = new LiquidTransformer(aspectRatio);
        for (a in Axis2D) {
            var applier2 = new TransformatorAxisApplier(transformer, a);
            w.axisStates[a].addSibling(applier2);
        }
        w.entity.addComponent(transformer);
        return w;
    }
}

class BoundboxConverters {
    public static inline function localToGlobal(bb:Boundbox, a:Axis2D, value:Float):Float {
        return bb.pos[a] + value / bb.size[a];
    }

    public static inline function globalToLocal(bb:Boundbox, a:Axis2D, value:Float):Float {
        return value * bb.size[a] - bb.pos[a];
    }
}


