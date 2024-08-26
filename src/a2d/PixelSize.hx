package a2d;
import a2d.Stage;
import al.layouts.data.LayoutData.ISize;
class PixelSize implements ISize {
    var screen:Stage;
    var a:Axis2D;
    public var value:Float = 0;

    public function new(a, s, v) {
        this.a = a;
        this.screen = s;
        this.value = v;
    }

    public function getPortion() {
        return 0;
    }

    public function getFixed() {
        return 2 * screen.getAspectRatio()[a] * value / screen.getWindowSize()[a];
    }
}
