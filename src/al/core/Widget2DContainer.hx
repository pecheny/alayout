package al.core;
import al.core.AxisState;
import al.layouts.data.LayoutData.Axis2D;
import al.layouts.AxisLayout;
import engine.Updatable;
import ecs.Entity.Component;
class Widget2DContainer implements Updatable extends Component {
    var holder:Widget2D;
    var children:Array<Widget2D> = [];
    var layoutMap:Map<Axis2D, AxisLayout> = new Map();
    // ??
    var childrenAxisStates:Map<Axis2D, Array<AxisState>> = new Map();
    public static inline var TYPE = "Widget2DContainer";

    public function new(holder) {
        super(TYPE);
        this.holder = holder;
        for (k in Axis2D.keys) {
            childrenAxisStates[k] = [];
        }
    }

    public function setHolder(h) {
        this.holder = h;
    }

    public function setLayout(axis:Axis2D, layout:AxisLayout) {
        layoutMap[axis] = layout;
    }

    public function addChild(child:Widget2D) {
        if (children.indexOf(child) > -1)
            throw "Already child";
        children.push(child);
        for (axis in Axis2D.keys) {
            childrenAxisStates[axis].push(child.axisStates[axis]);
        }
    }

    public function update(dt:Float):Void {
        refresh();
    }

    public function refresh() {
        for (axis in Axis2D.keys)
            layoutMap[axis].arrange(holder.axisStates[axis], childrenAxisStates[axis]);
    }
}

