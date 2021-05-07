package al;

import al.al2d.Axis2D;
import al.al2d.Widget2D;
import al.al2d.Widget2DContainer;
import al.appliers.ContainerRefresher;
import al.appliers.PropertyAccessors.FloatPropertyAccessor;
import al.appliers.PropertyAccessors.FloatPropertyReader;
import al.appliers.PropertyAccessors.FloatPropertyWriter;
import al.core.AxisCollection;
import al.core.AxisState;
import al.layouts.data.LayoutData.SizeType;
import al.layouts.PortionLayout;
import al.layouts.WholefillLayout;
import ec.Entity;
using al.Builder;

class Builder {
    var alignStack:Array<Axis2D> = [];

    public function new() {}

    public function align(d:Axis2D) {
        alignStack.push(d);
        return this;
    }

    public static inline function widget2d(xtype:SizeType = SizeType.portion, xsize = 1., ytype = SizeType.portion, ysize = 1.):Widget2D {
        var factor = #if flash 300 #else 1 #end ;
        var entity = new Entity();
        var axisStates = new AxisCollection<Axis2D, AxisState>();
        axisStates[horizontal] = new AxisState();
        axisStates[horizontal].initSize(xtype, xsize * factor);
        axisStates[vertical] = new AxisState();
        axisStates[vertical].initSize(ytype, ysize * factor);

        var w = new Widget2D(axisStates);
        entity.addComponent(w);
        return w;
    }

    public function widget(xtype:SizeType = SizeType.portion, xsize = 1., ytype = SizeType.portion, ysize = 1.):Widget2D {
        var w = widget2d(xtype, xsize, ytype, ysize);
        return w;
    }


    public function makeContainer(w:Widget2D, children:Array<Widget2D>):Widget2DContainer {
        var alignment = if (alignStack.length > 0) {
            alignStack.pop();
        } else {
            trace("Warn: empty align stack");
            Axis2D.horizontal;
        };
        var wc = createContainer(w, alignment);
        for (ch in children)
            addWidget(wc, ch);
        return wc;
    }

    public static function createContainer(w:Widget2D, alignment):Widget2DContainer {
        var wc = new Widget2DContainer(w);
        for (a in Axis2D.keys) {
            w.axisStates[a].addSibling(new ContainerRefresher(wc));
        }
        w.entity.addComponent(wc);
        alignContainer(wc, alignment);
        return wc;
    }

    public static function alignContainer(wc:Widget2DContainer, align:Axis2D) :Widget2DContainer{
        for (axis in Axis2D.keys) {
            wc.setLayout(axis,
            if (axis == align)
                PortionLayout.instance
            else
                WholefillLayout.instance
            );
        };
        return wc;
    }

    public static function addWidget(wc:Widget2DContainer, w:Widget2D) {
        wc.addChild(w);
        wc.entity.addChild(w.entity);
    }

    public static function removeWidget(wc:Widget2DContainer, w:Widget2D) {
        wc.removeChild(w);
        wc.entity.removeChild(w.entity);
    }

    public function container(children:Array<Widget2D>):Widget2D {
        var w = widget();
        var wc = makeContainer(w, children);
        return w;
    }

}


class GlobalPos {
//    public var x:Float = 0;
//    public var y:Float = 0;
    public var axis:AxisCollection2D<Float> = new AxisCollection();
    var readers:Map<Axis2D, FloatPropertyAccessor> = new Map();


    public function new() {
        for (a in Axis2D.keys) {
            axis[a] = 0;
            readers[a] = new FloatAxisAccessor(a, axis);
        }
    }

    public function getReader(a):FloatPropertyReader return readers[a];

    public function getWriter(a):FloatPropertyWriter return readers[a];

    public function toString() {
        return "" + axis;
    }
}

class FloatAxisAccessor implements FloatPropertyAccessor {
    var target:AxisCollection2D<Float>;
    var axis:Axis2D;

    public function new(a, t) {
        this.target = t;
        this.axis = a;
    }

    public function setValue(val:Float):Void {
        target[axis] = val;
    }

    public function getValue():Float {
        return target[axis];
    }


}


