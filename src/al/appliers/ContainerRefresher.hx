package al.appliers;
import al.appliers.PropertyAccessors.FloatPropertyAccessor;
import al.core.Widget2DContainer;
class ContainerRefresher implements FloatPropertyAccessor {
    var container:Widget2DContainer;

    public function new(container:Widget2DContainer) {
        this.container = container;
    }

    public function setValue(val:Float):Void {
        container.refresh();
    }

    public function getValue():Float {
        throw "Not implemented";
    }
}

