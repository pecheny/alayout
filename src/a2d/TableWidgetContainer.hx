package a2d;

import Axis2D;
import a2d.Placeholder2D;
import a2d.Widget2DContainer;
import al.core.AxisState;
import al.layouts.PortionLayout;

/**
    This container limits number/position of children per line according to refRow layout 
    moving the rest to new lines forming a table appearance.
**/
class TableWidgetContainer extends Widget2DContainer {
    var refRow:Array<AxisState>;
    var refCol:Array<AxisState>;
    var colFac:() -> AxisState;
    var direction:Axis2D = horizontal;

    /**
        @param refRow - array of AxisState to lay out children along 'direction'. 
        Each child would be associated with one of elements from the reference array.
        So each n-th child got position of 'n % refRow.length' reference element.
        @param colFac provide AxisState for each new row as needed.
    **/
    public function new(ph, direction, refRow, colFac:() -> AxisState) {
        super(ph, 2);
        this.colFac = colFac;
        this.direction = direction;
        for (a in Axis2D) {
            ph.axisStates[a].addSibling(new al.appliers.ContainerRefresher(this));
        }
        this.refRow = childrenAxisStates[direction] = refRow;
        this.refCol = childrenAxisStates[direction.other()] = [];
        ph.entity.addComponentByType(Widget2DContainer, this);
        setLayout(horizontal, PortionLayout.instance);
        setLayout(vertical, PortionLayout.instance);
    }

    override public function addChild(child:Placeholder2D) {
        if (children.indexOf(child) > -1)
            throw "Already a child";
        var ix = children.length % refRow.length;
        var iy = Math.floor(children.length / refRow.length);
        children.push(child);
        refRow[ix].addSibling(child.axisStates[direction]);
        if (refCol.length <= iy)
            refCol.push(colFac());
        refCol[iy].addSibling(child.axisStates[direction.other()]);

        if (refreshOnChildrenChanged) {
            refresh();
        }
    }

    override public function removeChild(child:Placeholder2D) {
        var pos = children.indexOf(child);
        if (pos < 0)
            throw "Not a child";
        var toAdd = children.slice(pos + 1);
        while (children.length > pos)
            removeLastChild();
        for (ch in toAdd)
            addChild(ch);
    }

    function removeLastChild() {
        var child = children.pop();
        var ix = children.length % refRow.length;
        var iy = Math.floor(children.length / refRow.length);
        refRow[ix].removeSibling(child.axisStates[direction]);
        refCol[iy].removeSibling(child.axisStates[direction.other()]);
        if (refCol.length > Math.ceil(children.length / refRow.length))
            refCol.pop();
    }
}
