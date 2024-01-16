package al.al2d;

import al.al2d.Placeholder2D;
import al.ec.Entity;

class Widget implements IWidget {
    public var ph(get, null):Placeholder2D;
    public var entity(get, null):Entity;

    public function new(p:Placeholder2D) {
        this.ph = p;
        watch(p.entity);
    }

    public function get_ph():Placeholder2D {
        return ph;
    }

    public function get_entity() {
        return ph.entity;
    }
}

@:autoBuild(ec.macros.InitMacro.build())
interface IWidget {
    public var ph(get, null):Placeholder2D;
    public var entity(get, null):Entity;
}
