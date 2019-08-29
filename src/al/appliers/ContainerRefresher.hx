package al.appliers;
import al.core.WidgetContainer.Refreshable;
import al.appliers.PropertyAccessors.FloatPropertyAccessor;
class ContainerRefresher implements FloatPropertyAccessor {
    var container:Refreshable;

    public function new(container:Refreshable) {
        this.container = container;
    }

    public function setValue(val:Float):Void {
        container.refresh();
    }

    public function getValue():Float {
        throw "Not implemented";
    }
}

