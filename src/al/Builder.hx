package al;

import al.al2d.Axis2D;
import al.al2d.Widget2D;
import al.al2d.Widget2DContainer;
import al.appliers.ContainerRefresher;
import al.appliers.DynamicPropertyAccessor;
import al.appliers.PropertyAccessors.StoreApplier;
import al.core.AxisState;
import al.layouts.PortionLayout;
import al.layouts.WholefillLayout;
import al.utils.Signal;
import ec.Entity;
using al.Builder;

class Builder {
    var alignStack:Array<Axis2D> = [];

    public var onWidgetCreated(default, null):Signal<Widget2D -> Void> = new Signal();
    public var onContainerCreated(default, null):Signal<Widget2D -> Void> = new Signal();
    public var onAddedToContainer(default, null):Signal<(Widget2DContainer, Widget2D) -> Void> = new Signal();

    public function new() {}

    public function align(d:Axis2D) {
        alignStack.push(d);
        return this;
    }



    public function widget(vfac:Widget2D -> Void = null) {
        var entity = new Entity();
        var axisStates = new Map();
        for (a in Axis2D.keys)
            axisStates[a] = new AxisState().init(new StoreApplier(10), new StoreApplier(10));
        var w = new Widget2D(axisStates);
        entity.addComponent(w);
        onWidgetCreated.dispatch(w);
        if (vfac != null)
            entity.addComponent(new OnAddToParent(vfac));
        return w;
    }


    function makeContainer(w:Widget2D, children:Array<Widget2D>) {
        var wc = new Widget2DContainer(w);
        var gp = new GlobalPos();
        w.entity.addComponent(gp);
        for (a in Axis2D.keys) {
            w.axisStates[a].addSizeApplier(new ContainerRefresher(wc));
            w.axisStates[a].addPosApplier(new DynamicPropertyAccessor(() -> gp.axis[a], (x) -> gp.axis[a] = x));
        }
        w.entity.addComponent(wc);
        alignContainer(wc,
        if (alignStack.length > 0) {
            alignStack.pop();
        } else {
            trace("Warn: empty align stack");
            Axis2D.horizontal;
        });
        onContainerCreated.dispatch(w);
        for (ch in children)
            addWidget(wc, ch);
        return wc;
    }

    function alignContainer(wc:Widget2DContainer, align:Axis2D) {
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

    public function gap(wg:Float){
        return weight(wg, widget());
    }

    public function weight(val:Float, w:Widget2D) {
        var axis = alignStack[alignStack.length - 1];
        w.axisStates[axis].size.setWeight(val);
        return w;
    }


    public function addWidget(wc:Widget2DContainer, w:Widget2D) {
        wc.entity.addChild(w.entity);
        wc.addChild(w);
        onAddedToContainer.dispatch(wc, w);
        if (w.entity.hasComponent(OnAddToParent))
            w.entity.getComponent(OnAddToParent).handler(w);
    }

    public function container(children:Array<Widget2D>) {
        var w = widget();
        var wc = makeContainer(w, children);
        return w;
    }

}


class OnAddToParent {
    public var handler:Widget2D -> Void;

    public function new(h) {
        handler = h;
    }
}

class GlobalPos {
//    public var x:Float = 0;
//    public var y:Float = 0;
    public var axis:Map<Axis2D, Float> = new Map();

    public function new() {}
}


