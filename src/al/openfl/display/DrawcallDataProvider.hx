package al.openfl.display;

import ec.EntityHolder;
import openfl.display.DisplayObject;
import al.ec.Entity;

class DrawcallDataProvider extends EntityHolder {
    // todo make readonly
    public var views(default, null):Array<DisplayObject> = [];

    public function new() {
    }

    public function addView(v:DisplayObject) {
        views.push(v);
        entity.dispatchContext(entity);
    }

    public static function get(entity:Entity):DrawcallDataProvider {
        if (entity.hasComponent(DrawcallDataProvider))
            return entity.getComponent(DrawcallDataProvider);
        var dp = new DrawcallDataProvider();
        entity.addComponent(dp);
        return dp;
    }
}
