package al.core;

import al.core.AxisApplier;

class MultiRefresher implements AxisApplier {
    var targets:Array<Void->Void> = [];

    public function new() {}

    public function add(r) {
        targets.push(r);
    }

    public function apply(pos:Float, size:Float):Void {
        for (c in targets)
            c();
    }
}
