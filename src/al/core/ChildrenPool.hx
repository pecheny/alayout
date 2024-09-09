package al.core;

import al.core.TWidget.IWidget;
import al.core.WidgetContainer.WContainer;
import haxe.ds.ReadOnlyArray;

class ChildrenPool<TAxis:Axis<TAxis>, T:IWidget<TAxis>> {
    var wc:WContainer<Placeholder<TAxis>>;

    public var activeCount(default, null):Int = 0;

    var _pool:Array<T> = [];

    public var pool(get, null):ReadOnlyArray<T>;

    public function new(wc, fac:Int->T) {
        this.wc = wc;
        this.factory = fac;
    }

    function get_pool():ReadOnlyArray<T> {
        return _pool;
    }

    public dynamic function factory(id:Int):T {
        return null;
    }

    public function setActiveNum(reqCount) {
        var activeCount = wc.getChildren().length;
        grantButtons(reqCount);
        for (i in reqCount...activeCount) {
            var w = _pool[i].ph;
            wc.removeChild(cast w);
            wc.entity.removeChild(w.entity);
        }
        for (i in activeCount...reqCount) {
            var w = _pool[i].ph;
            wc.addChild(cast w);
        }
        // wc.add and e.add separated due to input collision
        // if button regs in InputSystem before laying out,
        // wrong hover and tap would trigger until moving pointer
        wc.refresh(); // if child size can change during initData, refresh call should be separated
        for (i in activeCount...reqCount) {
            var w = _pool[i].ph;
            wc.entity.addChild(w.entity);
        }
        this.activeCount = reqCount;
    }

    inline function grantButtons(n) {
        for (i in _pool.length...n)
            _pool.push(factory(i));
    }
}
