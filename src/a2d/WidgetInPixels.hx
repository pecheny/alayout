package a2d;

import Axis2D;
import a2d.Widget;
import al.core.WidgetContainer.Refreshable;
import macros.AVConstructor;

class WidgetInPixels extends Widget implements Refreshable {
    public var size(default, null):AVector2D<Float> = AVConstructor.create(0, 0);

    @:once var stage:Stage;

    public function refresh() {
        if (!_inited)
            return;
        for (a in Axis2D) {
            var ws = stage.getAspectRatio()[a] / ph.axisStates[a].getSize();
            size[a] = stage.getWindowSize()[a] / ws;
        }
    }
}