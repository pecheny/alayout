package al.core;
import al.ec.Entity.Component;
import al.layouts.AxisLayout;
import haxe.ds.ReadOnlyArray;
using Lambda;
class WidgetContainer<TAxis:String> extends Component implements Refreshable {
    var holder:Widget<TAxis>;
    var children:Array<Widget<TAxis>> = [];
    var layoutMap:Map<TAxis, AxisLayout> = new Map<TAxis, AxisLayout>();
    var childrenAxisStates:Map<TAxis, Array<AxisState>> = new Map();
    var mode:LayoutPosMode = global;

    public function new(holder) {
        this.holder = holder;
    }

    public function setHolder(h) {
        this.holder = h;
    }

    public function setLayout(axis:TAxis, layout:AxisLayout, mode:LayoutPosMode = global) {
        this.mode = mode;
        layoutMap[axis] = layout;
        if (!childrenAxisStates.exists(axis))
            childrenAxisStates[axis] = [];
    }

    public function addChild(child:Widget<TAxis>) {
        if (children.indexOf(child) > -1)
            throw "Already child";
        children.push(child);
        for (axis in layoutMap.keys()) {
            childrenAxisStates[axis].push(child.axisStates[axis]);
        }
    }

    public function getChildren():ReadOnlyArray<Widget<TAxis>> {
        return children;
    }

    public function refresh() {
        for (axis in layoutMap.keys()) {
            layoutMap[axis].arrange(holder.axisStates[axis], childrenAxisStates[axis], mode);
        }
    }
}

interface Refreshable {
    function refresh():Void ;
}


@:enum abstract LayoutPosMode(Bool) {
    var global:LayoutPosMode = cast true;
    var local:LayoutPosMode = cast false;
    public inline function isGlobal() return this;
}