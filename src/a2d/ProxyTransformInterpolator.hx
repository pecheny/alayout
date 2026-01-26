package a2d;

import Axis2D;
import a2d.Placeholder2D;
import a2d.ProxyTransform;
import a2d.Widget;
import al.Builder;
import al.core.AxisApplier;
import al.core.AxisState;
import macros.AVConstructor;
import utils.Mathu;

class ProxyTransformInterpolator extends Widget implements ProxyTransform {
    public var target(default, null):Placeholder2D;

    var axes:AVector2D<ElasticAxis> = AVConstructor.empty();

    public function new(ph:Placeholder2D) {
        target = Builder.ph();
        ph.entity.addComponent(target);
        for (a in Axis2D) {
            var ta = new ElasticAxis(target.axisStates[a]);
            ph.axisStates[a].addSibling(ta);
            axes[a] = ta;
        }
        super(ph);
    }

    public function setT(t:Float) {
        for (a in Axis2D)
            axes[a].setT(t);
    }

    public static function elastic(ph:Placeholder2D) {
        if (ph.entity.hasComponent(ProxyTransform))
            throw "Already has ProxyTransform";
        var instance = ph.entity.getComponent(ProxyTransformInterpolator);
        if (instance == null) {
            instance = ph.entity.addComponent(new ProxyTransformInterpolator(ph));
            ph.entity.addComponentByType(ProxyTransform, instance);
        }
        return instance.target;
    }

    public function copyFromState(source:Placeholder2D) {
        for (a in Axis2D) {
            axes[a].setFrom(source.axisStates[a].getPos(), source.axisStates[a].getSize());
        }
    }

    public function copyToState(source:Placeholder2D) {
        for (a in Axis2D) {
            axes[a].setTo(source.axisStates[a].getPos(), source.axisStates[a].getSize());
        }
    }

    public function setToState(a, pos, size) {
        axes[a].setTo(pos, size);
    }

    public function setFromState(a, pos, size) {
        axes[a].setFrom(pos, size);
    }
}

class ElasticAxis implements AxisApplier {
    var initPos:Float = 0;
    var initSize:Float = 0;
    var sizeVal:Float = 1;
    var posVal:Float = 0;
    var target:AxisState;

    public function new(t) {
        this.target = t;
    }

    public function apply(pos:Float, size:Float):Void {
        sizeVal = size;
        posVal = pos;
    }

    public function setT(t:Float) {
        if (t == 1)
            target.apply(posVal, sizeVal);
        else
            target.apply(Mathu.lerp(t, initPos, posVal), Mathu.lerp(t, initSize, sizeVal));
    }

    public function setFrom(pos:Float, size:Float) {
        initPos = pos;
        initSize = size;
    }

    public function setTo(pos:Float, size:Float) {
        posVal = pos;
        sizeVal = size;
    }
}
