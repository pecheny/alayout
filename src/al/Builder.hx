package al;
import al.Builder.DOT2D;
import openfl.display.DisplayObject;
import al.appliers.PropertyAccessors.PropertyAccessor;
import al.al2d.Axis2D;
import al.al2d.Widget2D;
import al.al2d.Widget2DContainer;
import al.appliers.ContainerRefresher;
import al.appliers.PropertyAccessors.DOXPropertySetter;
import al.appliers.PropertyAccessors.DOYPropertySetter;
import al.appliers.PropertyAccessors.FloatPropertyAccessor;
import al.appliers.PropertyAccessors.StoreApplier;
import al.core.AxisState;
import al.layouts.PortionLayout;
import al.layouts.WholefillLayout;
import al.view.AspectKeeper;
import al.view.ColoredRect.DisplayObjectScalerApplierFactory;
import al.view.ColoredRect;
import al.view.OpenflViewAdapter;
import ec.Entity;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
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

    function makeContainer(w:Widget2D, children:Array<Widget2D>, vfac:Widget2D->Void) {
        var wc = new Widget2DContainer(w);
        for (a in Axis2D.keys) {
            w.axisStates[a].addSizeApplier(new ContainerRefresher(wc));
        }
        vfac(w);
        w.entity.addComponent(wc);
        alignContainer(wc,
        if (alignStack.length > 0) {
            alignStack.pop();
        } else {
            trace("Warn: empty align stack");
            Axis2D.horizontal;
        });
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
        return weight(wg, empty());
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
        if (doChild != null)
            doContatiner.addChild(doChild);
        wc.addChild(w);
    }

    public function container(children:Array<Widget2D>) {
        var w = empty();
        var wc = makeContainer(w, children, w->addView(w, new Sprite()));
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

    public function rect(w:Widget2D) {
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


    public function sprite(w:Widget2D, sourceId:String, r:Rectangle = null) {
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
        if (r==null)
            r = dobj.getBounds(dobj);
        var aspectKeeper = new AspectKeeper(new DOT2D(dobj), r);
        w.axisStates[Axis2D.horizontal].addSizeApplier(new WidgetWidthApplier(aspectKeeper));
        w.axisStates[Axis2D.vertical].addSizeApplier(new WidgetHeightApplier(aspectKeeper));
        w.axisStates[Axis2D.horizontal].addPosApplier(new DOXPropertySetter(prx));
        w.axisStates[Axis2D.vertical].addPosApplier(new DOYPropertySetter(prx));
        return w;
    }
}

class DOT2D implements Target2D {
    var target:DisplayObject;
    public function new (trg) {
        this.target = trg;
    }

    public var x(get, set):Float;
    public var y(get, set):Float;
    public var scaleX(get, set):Float;
    public var scaleY(get, set):Float;

    function set_x(value:Float):Float {
        return target.x = value;
    }

    function get_y():Float {
        return target.y;
    }

    function set_y(value:Float):Float {
        return target.y = value;
    }

    function get_scaleX():Float {
        return target.scaleX;
    }

    function set_scaleX(value:Float):Float {
        return target.scaleX = value;
    }

    function get_x():Float {
        return target.x;
    }

    function get_scaleY():Float {
        return target.scaleY;
    }

    function set_scaleY(value:Float):Float {
        return target.scaleY = value;
    }

}
@:property("widgetWidth") class WidgetWidthApplier<T:WidgetSizeApplier> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
@:property("widgetHeight") class WidgetHeightApplier<T:WidgetSizeApplier> implements PropertyAccessor<Float> implements FloatPropertyAccessor {}
