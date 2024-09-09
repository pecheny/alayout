package al.core;

import a2d.Placeholder2D;
import al.core.Placeholder;
import al.ec.Entity;

class TWidget<TAxis:Axis<TAxis>> implements IWidget<TAxis> {
    public var ph(get, null):Placeholder<TAxis>;
    public var entity(get, null):Entity;

    public function new(p:Placeholder<TAxis>) {
        this.ph = p;
        watch(p.entity);
    }

    public function get_ph():Placeholder<TAxis> {
        return ph;
    }

    public function get_entity() {
        return ph.entity;
    }
}

@:autoBuild(ec.macros.InitMacro.build())
interface IWidget<TAxis:Axis<TAxis>> {
    public var ph(get, null):Placeholder<TAxis>;
    public var entity(get, null):Entity;
}
