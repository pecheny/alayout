package al;

import macros.AVConstructor;
import al.layouts.data.LayoutData.FractionSize;
import al.layouts.data.LayoutData.ISize;
import Axis2D;
import al.al2d.Widget2D;
import al.al2d.Widget2DContainer;
import al.appliers.ContainerRefresher;
import al.core.AxisCollection;
import al.core.AxisState;
import al.ec.Entity;
import al.layouts.data.LayoutData.Position;
import al.layouts.PortionLayout;
import al.layouts.WholefillLayout;
using al.Builder;

class Builder {
    public static inline function widget(hsize:ISize = null, vsize:ISize = null):Widget2D {
        var entity = new Entity();
        var hst = new AxisState(new Position(), hsize != null ? hsize : new FractionSize(1));
        var vst = new AxisState(new Position(), vsize != null ? vsize : new FractionSize(1));
        var axisStates:AVector<Axis2D,AxisState> = AVConstructor.create(hst, vst);
        var w = new Widget2D(axisStates);
        entity.addComponent(w);
        return w;
    }

    public static function createContainer(w:Widget2D, alignment):Widget2DContainer {
        var wc = new Widget2DContainer(w, 2);
        for (a in Axis2D) {
            w.axisStates[a].addSibling(new ContainerRefresher(wc));
        }
        w.entity.addComponent(wc);
        alignContainer(wc, alignment);
        return wc;
    }

    public static function alignContainer(wc:Widget2DContainer, align:Axis2D):Widget2DContainer {
        for (axis in Axis2D) {
            wc.setLayout(axis,
            if (axis == align)
                PortionLayout.instance
            else
                WholefillLayout.instance
            );
        };
        return wc;
    }

    public static function v(hsize:ISize = null, vsize:ISize = null) {
        return createContainer(widget(hsize, vsize), vertical);
    }

    public static function h(hsize:ISize = null, vsize:ISize = null) {
        return createContainer(widget(hsize, vsize), horizontal);
    }

    public static function withChildren(c:Widget2DContainer, children:Array<Widget2D>):Widget2D {
        for (ch in children)
            addWidget(c, ch);
        return c.widget();
    }

    public static function addWidget(wc:Widget2DContainer, w:Widget2D) {
        wc.addChild(w);
        wc.entity.addChild(w.entity);
    }
}



