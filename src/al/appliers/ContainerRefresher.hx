package al.appliers;
import al.core.AxisApplier;
import al.core.WidgetContainer.Refreshable;
class ContainerRefresher implements AxisApplier {
    var container:Refreshable;

    public function new(container:Refreshable) {
        this.container = container;
    }

    public function apply(pos:Float, size:Float):Void {
        container.refresh();
    }

}

