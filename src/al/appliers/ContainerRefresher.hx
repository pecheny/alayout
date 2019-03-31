package al.appliers;
import al.al2d.Widget2DContainer;
import al.appliers.PropertyAccessors.FloatPropertyAccessor;
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

