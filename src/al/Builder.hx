package al;
import al.ec.Entity.Component;
import al.appliers.ContainerRefresher;
import al.core.AxisState;
import openfl.geom.Rectangle;
import ec.Entity;
import al.appliers.PropertyAccessors.DOXPropertySetter;
import al.appliers.PropertyAccessors.DOYPropertySetter;
import al.appliers.PropertyAccessors.FloatPropertyAccessor;
import al.appliers.PropertyAccessors.StoreApplier;
import al.core.Widget2D;
import al.core.Widget2DContainer;
import al.layouts.data.LayoutData.Axis2D;
import al.layouts.PortionLayout;
import al.layouts.WholefillLayout;
import al.view.AspectKeeper;
import al.view.ColoredRect.DisplayObjectScalerApplierFactory;
import al.view.ColoredRect;
import al.view.OpenflViewAdapter;
import al.view.ViewAdapterBase;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import sxui.properties.accessors.StatelessPropertyAccessor.StatefullPropertyAccessor;
using al.Builder;
using al.Builder.ViewBuilderStaticWrapper;

class Builder {
//    var alongsideAxis:Axis2D = Axis2D.horizontal;
    var alignStack:Array<Axis2D> = [];

    public function new() {}

    public function align(d:Axis2D) {
        alignStack.push(d);
        return this;
    }

    public function empty() {
        var entity = new Entity();
        var axisStates = new Map();
        for (a in Axis2D.keys)
            axisStates[a] = new AxisState().init(new StoreApplier(10), new StoreApplier(10));
        var w = new Widget2D(axisStates);
        entity.addComponent(w);
        return w;
    }

    function addView(w:Widget2D, v:DisplayObjectContainer) {
        var adapter = new ViewAdapter(w, v);
        w.entity.addComponent(adapter);
        w.axisStates[Axis2D.horizontal].addPosApplier(new DOXPropertySetter(v));
        w.axisStates[Axis2D.vertical].addPosApplier(new DOYPropertySetter(v));
        return adapter;
    }

    function makeContainer(w:Widget2D, children:Array<Widget2D>) {
        var wc = new Widget2DContainer(w);
        for (a in Axis2D.keys) {
            w.axisStates[a].addSizeApplier(new ContainerRefresher(wc));
        }
        addView(w, new Sprite());
        w.entity.addComponent(wc);
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

    public function weight(val:Float, w:Widget2D) {
        var axis = alignStack[alignStack.length - 1];
        w.axisStates[axis].size.setWeight(val);
        return w;
    }


    public function addWidget(wc:Widget2DContainer, w:Widget2D) {
        wc.entity.addChild(w.entity);
        var doContatiner:ViewAdapter = wc.entity.getComponent(ViewAdapter);
        var doChild:ViewAdapter = w.entity.getComponent(ViewAdapter);
        doContatiner.addChild(doChild);
        wc.addChild(w);
    }

    public function container(children:Array<Widget2D>) {
        var w = empty();
        var wc = makeContainer(w, children);
        alignContainer(wc,
            if(alignStack.length > 0) {
                alignStack.pop();
            } else {
                trace("Warn: empty align stack");
                Axis2D.horizontal;
            });
        return w;
    }


}

class MovieClipAdapterLoader implements ViewFactory {
    var swfName:String;

    public function new(swfName:String) {
        this.swfName = swfName;
    }

    public function createView(id:String):DisplayObjectContainer {
        return openfl.utils.Assets.getMovieClip(swfName + ":" + id);
    }
}

interface ViewFactory {
//    function createView(w:Widget2D):ViewAdapter;
    function createView(id:String):DisplayObjectContainer;
}


class ViewBuilderStaticWrapper {
    public static var instance:ViewBuilder;

    public static function sprite(w:Widget2D, sid:String) {
        instance.sprite(w, sid);
        return w;
    }

    public static function rect(w:Widget2D) {
        var view = new ColoredRect(Std.int(Math.random() * 0xffffff));
        var entity = w.entity;
        var appliers = new DisplayObjectScalerApplierFactory(view);
        for (a in Axis2D.keys) {
            w.axisStates[a].addSizeApplier(appliers.getSizeApplier(a));
            w.axisStates[a].addPosApplier(appliers.getPosApplier(a));
        }
        var adapter = new ViewAdapter(w, view);
        entity.addComponent(adapter);
        return w;
    }

    public static function setSourceSwf(swfName:String) {
        var fac = new MovieClipAdapterLoader(swfName);
        var viewBuilder = new ViewBuilder();
        viewBuilder.regFactory(fac);
        ViewBuilderStaticWrapper.instance = viewBuilder;
    }
}
class ViewBuilder {
    var factories:Array<ViewFactory> = [];

    public function new() {}

    public function regFactory(factory:ViewFactory) {
        factories.push(factory);
    }

    static function calculateOffset(spr:DisplayObjectContainer):{x:Float, y:Float} {
        var r = spr.getBounds(spr);
        trace(r);
        return {x:r.x, y:r.y};
    }

    public function sprite(w:Widget2D, sourceId:String) {
        var dobj:DisplayObjectContainer = null;
        for (fac in factories) {
            dobj = fac.createView(sourceId);
            if (dobj != null)
                break;
        }
        if (dobj == null)
            throw "Cant build view with id " + sourceId;
//        cast(dobj, MovieClip).stop();
        var prx = new Sprite();
        prx.addChild(dobj);
//        prx.addChild(new ColoredRect(0xc0aa020));
        var adapter = new ViewAdapter(w, prx);
        w.entity.addComponent(adapter);
        var offset = calculateOffset(dobj);
        var aspectKeeper = new AspectKeeper<DisplayObjectContainer>(dobj, new Rectangle(-86, -20, 160, 196));
        w.axisStates[Axis2D.horizontal].addSizeApplier(new WidgetWidthApplier(aspectKeeper));
        w.axisStates[Axis2D.vertical].addSizeApplier(new WidgetHeightApplier(aspectKeeper));
        w.axisStates[Axis2D.horizontal].addPosApplier(new DOXPropertySetter(prx));
        w.axisStates[Axis2D.vertical].addPosApplier(new DOYPropertySetter(prx));
        return w;
    }
}
@:property("widgetWidth") class WidgetWidthApplier<T:WidgetSizeApplier> implements StatefullPropertyAccessor<Float> implements FloatPropertyAccessor {}
@:property("widgetHeight") class WidgetHeightApplier<T:WidgetSizeApplier> implements StatefullPropertyAccessor<Float> implements FloatPropertyAccessor {}
