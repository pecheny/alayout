package al.al2d;

import al.al2d.Widget2DContainer;
import haxe.ds.ReadOnlyArray;
import al.al2d.Widget;

class ChildrenPool<T:IWidget> {
    var wc:Widget2DContainer;
    public var activeCount (default, null):Int = 0;
    var _pool:Array<T> = [];

    public var pool(get, null):ReadOnlyArray<T>;

    public function new(wc, fac:Void->T) {
        this.wc = wc;
        this.factory = fac;
    }

    function get_pool():ReadOnlyArray<T> {
        return _pool;
    }

    public dynamic function factory():T {
        return null;
    }

    public function setActiveNum(reqCount) {
        var activeCount = wc.getChildren().length;
        grantButtons(reqCount);
        for (i in reqCount...activeCount)
            Builder.removeWidget(wc, _pool[i].ph);
        for (i in activeCount...reqCount)
            Builder.addWidget(wc, _pool[i].ph);
        this.activeCount = reqCount;
        wc.refresh(); // if child size can change during initData, refresh call should be separated
    }

    inline function grantButtons(n) {
        for (i in _pool.length...n)
            _pool.push(factory());
    }
}
