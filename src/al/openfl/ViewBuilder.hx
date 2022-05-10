package al.openfl;
import al.openfl.display.DrawcallDataProvider;
import ec.CtxWatcher;
import al.openfl.display.FlashDisplayRoot;
import al.al2d.Axis2D;
import al.al2d.Widget2D;
import al.openfl.DisplayObjectAxisAppliers;
import al.openfl.DisplayObjectValueAppliers.DOScaleXPropertySetter;
import al.openfl.DisplayObjectValueAppliers.DOScaleYPropertySetter;
import al.openfl.DisplayObjectValueAppliers.DOXPropertySetter;
import al.openfl.DisplayObjectValueAppliers.DOYPropertySetter;
import al.core.AxisApplier.SimpleAxisApplier;
import al.core.AxisApplier;
import al.al2d.Boundbox;
import al.openfl.ColoredRect.DisplayObjectScalerApplierFactory;
import al.view.AspectKeeper;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
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
            w.axisStates[a].addSibling(appliers.getApplier(a));
        }
        var vp = DrawcallDataProvider.get(w.entity);
        vp.views.push(view);
        new CtxWatcher(FlashDisplayRoot, w.entity);
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
        var prx = new Sprite();
        prx.addChild(dobj);

        var vp = DrawcallDataProvider.get(w.entity);
        new CtxWatcher(FlashDisplayRoot, w.entity);
        vp.views.push(prx);


        var offset = calculateOffset(dobj);
        if (r == null)
            r = dobj.getBounds(dobj);
        var aspectKeeper = new AspectKeeper(createAxisForDispObj(dobj), rectToBoundbox(r));
        w.axisStates[Axis2D.horizontal].addSibling(aspectKeeper.getApplier(horizontal));
        w.axisStates[Axis2D.vertical].addSibling(aspectKeeper.getApplier(vertical));

        w.axisStates[Axis2D.horizontal].addSibling(new DOHorizontalPosApplier(prx));
        w.axisStates[Axis2D.vertical].addSibling(new DOVerticalPosApplier(prx));
        return w;
    }

    function createAxisForDispObj(v:DisplayObject) {
        var axis = new AxisCollection2D<AxisApplier>();
        axis[Axis2D.horizontal] = new SimpleAxisApplier(
        new DOXPropertySetter(v),
        new DOScaleXPropertySetter(v)
        );
        axis[Axis2D.vertical] = new SimpleAxisApplier(
        new DOYPropertySetter(v),
        new DOScaleYPropertySetter(v)
        );
        return axis;
    }

    function rectToBoundbox(r:Rectangle) {
        var bb = new Boundbox();
        bb.size[Axis2D.horizontal] = r.width;
        bb.pos[Axis2D.horizontal] = r.x;
        bb.size[Axis2D.vertical] = r.height;
        bb.pos[Axis2D.vertical] = r.y;
        return bb;
    }
}


interface ViewFactory {
//    function createView(w:Widget2D):ViewAdapter;
    function createView(id:String):DisplayObjectContainer;
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
