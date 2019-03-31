package al.core;
import al.layouts.AxisLayout;
import al.ec.Entity.Component;
using Lambda;
class WidgetContainer<TAxis:String> extends Component {
    var holder:Widget<TAxis>;
    var children:Array<Widget<TAxis>> = [];
    var layoutMap:Map<TAxis, AxisLayout> = new Map<TAxis, AxisLayout>();
    var childrenAxisStates:Map<TAxis, Array<AxisState>> = new Map();

    public function new(holder) {
        this.holder = holder;
    }

    public function setHolder(h) {
        this.holder = h;
    }

    public function setLayout(axis:TAxis, layout:AxisLayout) {
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

    public function refresh() {
        for (axis in layoutMap.keys())
            layoutMap[axis].arrange(holder.axisStates[axis], childrenAxisStates[axis]);
    }
}
