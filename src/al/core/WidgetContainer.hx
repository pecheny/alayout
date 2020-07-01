package al.core;
import al.ec.Entity.Component;
import al.core.AxisCollection;
import al.layouts.AxisLayout;
import haxe.ds.ReadOnlyArray;
using Lambda;
class WidgetContainer<TAxis:AxisKeyBase, TChild:Widget<TAxis>> extends Component implements Refreshable {
    var holder:TChild;
    var children:Array<TChild> = [];
    var layoutMap:AxisCollection<TAxis, AxisLayout> = new AxisCollection();
    var childrenAxisStates:AxisCollection<TAxis, Array<AxisState>> = new AxisCollection();
    var mode:LayoutPosMode = global;

    public function new(holder) {
        setHolder(holder);
    }

    public function setHolder(h) {
        this.holder = h;
    }

    public function setLayout(axis:TAxis, layout:AxisLayout, mode:LayoutPosMode = global) {
        this.mode = mode;
        layoutMap[axis] = layout;
        if (!childrenAxisStates.hasValueFor(axis))
            childrenAxisStates[axis] = [];
    }

    public function addChild(child:TChild) {
        if (children.indexOf(child) > -1)
            throw "Already child";
        children.push(child);
        for (axis in layoutMap.keys()) {
            var a:TAxis = axis;
            childrenAxisStates[axis].push(child.axisStates[axis]);
        }
    }

    public function getChildren():ReadOnlyArray<TChild> {
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

typedef AxisKeyBase = Int;
@:enum abstract LayoutPosMode(Bool) {
    var global:LayoutPosMode = cast true;
    var local:LayoutPosMode = cast false;
    public inline function isGlobal() return this;
}