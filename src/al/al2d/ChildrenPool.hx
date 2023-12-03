package al.al2d;

import al.al2d.Widget2DContainer;
import haxe.ds.ReadOnlyArray;
import widgets.Widget;

class ChildrenPool<T:Widget> {
    var wc:Widget2DContainer;
    var activeCount:Int = 0;
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
            Builder.removeWidget(wc, _pool[i].widget());
        for (i in activeCount...reqCount)
            Builder.addWidget(wc, _pool[i].widget());
        wc.refresh(); // if child size can change during initData, refresh call should be separated
    }

    inline function grantButtons(n) {
        for (i in _pool.length...n)
            _pool.push(factory());
    }
}
