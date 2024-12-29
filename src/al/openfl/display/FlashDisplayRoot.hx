package al.openfl.display;

import al.ec.Entity;
import ec.CtxWatcher.CtxBinder;
import openfl.display.DisplayObjectContainer;

@:keep
class FlashDisplayRoot implements CtxBinder {
    var container:DisplayObjectContainer;

    public function new(c) {
        this.container = c;
    }

    public function bind(e:Entity):Void {
        var prv = e.getComponent(DrawcallDataProvider);
        if (prv == null)
            return;
        for (v in prv.views) {
            container.addChild(v);
        }
    }

    public function unbind(e:Entity):Void {
        var prv = e.getComponent(DrawcallDataProvider);
        if (prv == null)
            return;
        for (v in prv.views)
            container.removeChild(v);
    }
}
