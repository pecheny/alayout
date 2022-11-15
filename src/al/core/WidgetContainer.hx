package al.core;
import macros.AVConstructor;
import ec.Signal;
import al.ec.Entity.Component;
import al.layouts.AxisLayout;
import haxe.ds.ReadOnlyArray;
using Lambda;
using al.core.WidgetContainer.Utils;
@:generic
class WidgetContainer<TAxis:Axis<TAxis>, TChild:Widget<TAxis>> extends Component implements Refreshable implements ContentSizeProvider<TAxis> {
    var holder:TChild;
    var children:Array<TChild> = [];
    var layoutMap:AVector<TAxis, AxisLayout>;
    var childrenAxisStates:AVector<TAxis, Array<AxisState>> ;
    var mode:LayoutPosMode = global;
    var contentSize:AVector<TAxis, Null<Float>> ;
    public var contentSizeChanged(default, null) = new Signal<TAxis -> Void>();

    public var refreshOnChildrenChanged = false;

    public function new(holder, n) {
        layoutMap = AVConstructor.empty(n);
        childrenAxisStates = AVConstructor.empty(n);
        // todo add support of Null<T> as value in AVConstructor
        contentSize = cast new haxe.ds.Vector<Null<Float>>(n);//AVConstructor.factoryCreate(TAxis, a -> cast null, n);
        setHolder(holder);

    }

    function setHolder(h) {
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
        for (axis in layoutMap.axes()) {
            var a:TAxis = axis;
            childrenAxisStates[axis].push(child.axisStates[axis]);
        }
        if (refreshOnChildrenChanged) {
            refresh();
        }
    }

    public function removeChild(child:TChild) {
        if (children.indexOf(child) < 0)
            throw "not a child";
        children.remove(child);
        for (axis in layoutMap.axes()) {
            var a:TAxis = axis;
            childrenAxisStates[axis].remove(child.axisStates[axis]);
        }
        if (refreshOnChildrenChanged) {
            refresh();
        }
    }

    public function getChildren():ReadOnlyArray<TChild> {
        return children;
    }

    public function getContentSize(a:TAxis):Float {
        if (contentSize.hasValueFor(a))
            return contentSize[a];
        return 0;
    }

    public function refresh() {
        for (axis in layoutMap.axes()) {
            if (layoutMap[axis] == null) continue;
            var parent = holder.axisStates[axis];
            var oldSize = if (contentSize.hasValueFor(axis)) contentSize[axis] else -1;
            contentSize[axis] = layoutMap[axis].arrange(parent.getPos(), parent.getSize(), childrenAxisStates[axis], mode);
            if (contentSize[axis] != oldSize) contentSizeChanged.dispatch(axis);
        }
    }

    public function widget() {
        return holder;
    }
}

class Utils {
    public static function hasValueFor<TAxis:Axis<TAxis>, TVal>(av:AVector<TAxis, TVal>, a:TAxis) {
        return av[a] != null;
    }
}

interface Refreshable {
    function refresh():Void ;
}

interface ContentSizeProvider<TAxis:AxisKeyBase> {
    var contentSizeChanged(default, null):Signal<TAxis -> Void>;

    function getContentSize(a:TAxis):Float;
}

typedef AxisKeyBase = Int;
@:enum abstract LayoutPosMode(Bool) {
    var global:LayoutPosMode = cast true;
    var local:LayoutPosMode = cast false;

    public inline function isGlobal() return this;
}