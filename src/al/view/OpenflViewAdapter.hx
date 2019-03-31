package al.view;
import al.al2d.Widget2D;
import al.view.ViewAdapterBase.ViewContainer;
import openfl.display.DisplayObjectContainer;
class OpenflViewAdapter extends ViewAdapterBase implements ViewContainer{
    public var view:DisplayObjectContainer;
    public var widget:Widget2D;

    public function new(widget:Widget2D, view:DisplayObjectContainer) {
        super();
        this.widget = widget;
        this.view = view;
    }

    public function addChild(view:ViewAdapter):Void {
        this.view.addChild(view.view);
    }
}
typedef ViewAdapter = OpenflViewAdapter;

