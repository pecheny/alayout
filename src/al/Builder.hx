package al;

import al.core.Align;
import macros.AVConstructor;
import al.layouts.data.LayoutData.FractionSize;
import al.layouts.data.LayoutData.ISize;
import Axis2D;
import al.al2d.Placeholder2D;
import al.al2d.Widget2DContainer;
import al.appliers.ContainerRefresher;
import al.core.AxisState;
import al.ec.Entity;
import al.layouts.data.LayoutData.Position;
import al.layouts.PortionLayout;
import al.layouts.WholefillLayout;
using al.Builder;

class Builder {
    public static inline function widget(hsize:ISize = null, vsize:ISize = null):Placeholder2D {
        var entity = new Entity();
        var w = ph(hsize, vsize);
        entity.addComponent(w);
        return w;
    }

    public static inline function ph(hsize:ISize = null, vsize:ISize = null) {
        var hst = new AxisState(new Position(), hsize != null ? hsize : new FractionSize(1));
        var vst = new AxisState(new Position(), vsize != null ? vsize : new FractionSize(1));
        var axisStates:AVector<Axis2D,AxisState> = AVConstructor.create(hst, vst);
        var w = new Placeholder2D(axisStates);
        return w;
    }

    public static function createContainer(w:Placeholder2D, direction:Axis2D, alignment:Align):Widget2DContainer {
        var wc = new Widget2DContainer(w, 2);
        for (a in Axis2D) {
            w.axisStates[a].addSibling(new ContainerRefresher(wc));
        }
        w.entity.addComponent(wc);
        alignContainer(wc, direction, alignment);
        return wc;
    }

    static function alignContainer(wc:Widget2DContainer, direction:Axis2D, alignment:Align):Widget2DContainer {
        for (axis in Axis2D) {
            wc.setLayout(axis,
            if (axis == direction)
                switch alignment {
                    case Forward:PortionLayout.instance;
                    case Backward:PortionLayout.backward;
                    case Center:PortionLayout.center;
                }
            else
                WholefillLayout.instance
            );
        };
        return wc;
    }


    public static function v(hsize:ISize = null, vsize:ISize = null, align = Forward) {
        return createContainer(widget(hsize, vsize), vertical, align);
    }

    public static function h(hsize:ISize = null, vsize:ISize = null, align = Forward) {
        return createContainer(widget(hsize, vsize), horizontal, align);
    }

    public static function withChildren(c:Widget2DContainer, children:Array<Placeholder2D>):Placeholder2D {
        for (ch in children)
            addWidget(c, ch);
        c.refresh();
        return c.widget();
    }

    public static function addWidget(wc:Widget2DContainer, w:Placeholder2D) {
        wc.addChild(w);
        wc.entity.addChild(w.entity);
    }

    public static function removeWidget(wc:Widget2DContainer, w:Placeholder2D) {
        wc.removeChild(w);
        wc.entity.removeChild(w.entity);
    }

    public static function sibling(w:Placeholder2D) {
        var s = Builder.widget();
        for (a in Axis2D) 
            w.axisStates[a].addSibling(s.axisStates[a]);
        w.entity.addChild(s.entity);
        return s;
    }
}



