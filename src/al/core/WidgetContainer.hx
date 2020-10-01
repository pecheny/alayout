package al.core;
import Array;
import al.ec.Entity.Component;
import al.core.AxisCollection;
import al.layouts.AxisLayout;
import haxe.ds.ReadOnlyArray;
using Lambda;
class WidgetContainer<TAxis:AxisKeyBase, TChild:Widget<TAxis>> extends Component implements Refreshable implements ContentSizeProvider<TAxis> {
    var holder:TChild;
    var children:Array<TChild> = [];
    var layoutMap:AxisCollection<TAxis, AxisLayout> = new AxisCollection();
    var childrenAxisStates:AxisCollection<TAxis, Array<AxisState>> = new AxisCollection();
    var mode:LayoutPosMode = global;
    var contentSize:AxisCollection<TAxis, Float> = new AxisCollection();

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

    public function getContentSize(a:TAxis) {
        if (contentSize.hasValueFor(a))
            return contentSize[a];
        return 0;
    }

    public function refresh() {
        for (axis in layoutMap.keys()) {
            contentSize[axis] = layoutMap[axis].arrange(holder.axisStates[axis], childrenAxisStates[axis], mode);
        }
    }

    public function widget() {
        return holder;
    }
}

interface Refreshable {
    function refresh():Void ;
}

interface ContentSizeProvider<TAxis:AxisKeyBase> {
    function getContentSize(a:TAxis):Float;
}

typedef AxisKeyBase = Int;
@:enum abstract LayoutPosMode(Bool) {
    var global:LayoutPosMode = cast true;
    var local:LayoutPosMode = cast false;

    public inline function isGlobal() return this;
}