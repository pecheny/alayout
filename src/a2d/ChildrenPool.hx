package a2d;

import a2d.Widget;

typedef ChildrenPool<T:IWidget<Axis2D>> = al.core.ChildrenPool<Axis2D, T>;

class DataChildrenPool<TData, TButton:IWidget<Axis2D> & DataView<TData>> extends ChildrenPool<TButton> {
    public function initData(data:Array<TData>) {
        setActiveNum(data.length);
        for (i in 0...data.length)
            pool[i].initData(data[i]);
    }
}

interface DataView<TData> {
    function initData(descr:TData):Void;
}
