package al.openfl.display;

import openfl.display.DisplayObject;
import al.ec.Entity;
class DrawcallDataProvider {
    public var views(default, null):Array<DisplayObject> = [];

    public function new() {
    }

    public static function get(entity:Entity):DrawcallDataProvider {
        if (entity.hasComponent(DrawcallDataProvider))
            return entity.getComponent(DrawcallDataProvider);
        var dp = new DrawcallDataProvider();
        entity.addComponent(dp);
        return dp;
    }
}
