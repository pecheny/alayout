package al.openfl.display;
import al.ec.Entity;
import openfl.display.Sprite;
import openfl.display.DisplayObjectContainer;
import ec.CtxBinder.CtxBindable;
@:keep
class FlashDisplayRoot implements CtxBindable {
    var container:DisplayObjectContainer;

    public static var instance:CtxBindable = new FlashDisplayRoot(new Sprite());
    public function new(c) {
        this.container = c;

        trace(instance  + " " + c.name);
    }

    public function bind(e:Entity):Void {
        var prv = e.getComponent(DrawcallDataProvider);
        if (prv == null)
            return;
        for (v in prv.views)
            container.addChild(v);
    }

    public function unbind(e:Entity):Void {
        var prv = e.getComponent(DrawcallDataProvider);
        if (prv == null)
            return;
        for (v in prv.views)
            container.removeChild(v);
    }
}
