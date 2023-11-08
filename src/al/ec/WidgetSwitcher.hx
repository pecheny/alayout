package al.ec;
import al.core.Placeholder;
class WidgetSwitcher<T:Axis<T>> {
    var root:Placeholder<T>;
    var current:Placeholder<T>;

    public function new(root:Placeholder<T>) {
        this.root = root;
    }

    public function switchTo(target:Placeholder<T>) {
        if (current != null) {
            unbind(current);
            current = null;
        }

        if (target != null) {
            bind(target);
            current = target;
        }
    }

    public function bind(target:Placeholder<T>) {
        for (a in root.axisStates.axes()) {
            var state = root.axisStates[a];
            var chState = target.axisStates[a];
            state.addSibling(chState);
            chState.apply(state.getPos(), state.getSize());
        }
        root.entity.addChild(target.entity);
    }

    public function unbind(target:Placeholder<T>) {
        for (a in root.axisStates.axes()) {
            var state = root.axisStates[a];
            var chState = target.axisStates[a];
            state.removeSibling(chState);
        }
        root.entity.removeChild(target.entity);
    }

    public function widget() {
        return root;
    }
}