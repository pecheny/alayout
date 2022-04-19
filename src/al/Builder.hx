package al;

import al.layouts.WholefillLayout;
import al.layouts.PortionLayout;
import al.appliers.ContainerRefresher;
import al.al2d.Axis2D;
import al.layouts.data.LayoutData.Size;
import al.layouts.data.LayoutData.Position;
import al.core.AxisState;
import al.core.AxisCollection;
import al.ec.Entity;
import al.layouts.data.LayoutData.SizeType;
import al.al2d.Widget2DContainer;
import al.al2d.Widget2D;
using al.Builder;

class Builder {
    public static inline function widget(xtype:SizeType = SizeType.portion, xsize = 1., ytype = SizeType.portion, ysize = 1.):Widget2D {
        var entity = new Entity();
        var axisStates = new AxisCollection<Axis2D, AxisState>();
        axisStates[horizontal] = new AxisState(new Position(), new Size(xtype, xsize ));
        axisStates[vertical] = new AxisState(new Position(), new Size(ytype, ysize ));
        var w = new Widget2D(axisStates);
        entity.addComponent(w);
        return w;
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

    public static function alignContainer(wc:Widget2DContainer, align:Axis2D):Widget2DContainer {
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

    public static function v(xtype:SizeType = SizeType.portion, xsize = 1., ytype = SizeType.portion, ysize = 1.) {
        return createContainer(widget(xtype, xsize, ytype, ysize), vertical);
    }

    public static function h(xtype:SizeType = SizeType.portion, xsize = 1., ytype = SizeType.portion, ysize = 1.) {
        return createContainer(widget(xtype, xsize, ytype, ysize), horizontal);
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



