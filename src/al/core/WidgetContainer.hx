package al.core;

import ec.IComponent;
// import al.core.Placeholder;
import al.ec.Entity.Component;
import al.layouts.AxisLayout;
import ec.Entity;
import ec.Signal;
import haxe.ds.ReadOnlyArray;
import macros.AVConstructor;

using Lambda;
using al.core.WidgetContainer.Utils;

// typedef SimpleContainer<TAxis:Axis<TAxis>> = WidgetContainer<TAxis, Placeholder<TAxis>>;

interface WContainer<T> extends IComponent {
    function addChild(ch:T):Void;
    function removeChild(ch:T):Void;
    public function refresh() :Void;
    public function getChildren():ReadOnlyArray<T>;
}

@:generic
class WidgetContainer<TAxis:Axis<TAxis>, TChild:Placeholder<TAxis>> extends Component implements Refreshable implements ContentSizeProvider<TAxis>
        implements WContainer<TChild> {
    var holder:TChild;
    var children:Array<TChild> = [];
    var layoutMap:AVector<TAxis, AxisLayout>;
    var childrenAxisStates:AVector<TAxis, Array<AxisState>>;
    var contentSize:AVector<TAxis, Null<Float>>;

    public var contentSizeChanged(default, null) = new Signal<TAxis->Void>();

    public var refreshOnChildrenChanged = false;
    @:isVar public var refreshOnContext(get, set):Bool;

    function get_refreshOnContext():Bool {
        return refreshOnContext;
    }

    @:keep
    function onContext(_:Entity) {
        refresh();
    }

    function set_refreshOnContext(value:Bool):Bool {
        if (value && !refreshOnContext)
            entity.onContext.listen(onContext);
        if (!value)
            entity.onContext.remove(onContext);
        return value;
    }

    public function new(holder, n) {
        layoutMap = AVConstructor.empty(n);
        childrenAxisStates = AVConstructor.empty(n);
        // todo add support of Null<T> as value in AVConstructor
        contentSize = cast new haxe.ds.Vector<Null<Float>>(n); // AVConstructor.factoryCreate(TAxis, a -> cast null, n);
        setHolder(holder);
    }

    function setHolder(h) {
        this.holder = h;
    }

    public function setLayout(axis:TAxis, layout:AxisLayout) {
        layoutMap[axis] = layout;
        if (!childrenAxisStates.hasValueFor(axis))
            childrenAxisStates[axis] = [];
        return this;
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
            if (layoutMap[axis] == null)
                continue;
            var parent = holder.axisStates[axis];
            var oldSize = if (contentSize.hasValueFor(axis)) contentSize[axis] else -1;
            contentSize[axis] = layoutMap[axis].arrange(parent.getPos(), parent.getSize(), childrenAxisStates[axis]);
            if (contentSize[axis] != oldSize)
                contentSizeChanged.dispatch(axis);
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
    function refresh():Void;
}

interface ContentSizeProvider<TAxis:AxisKeyBase> {
    var contentSizeChanged(default, null):Signal<TAxis->Void>;

    function getContentSize(a:TAxis):Float;
}

typedef AxisKeyBase = Int;
