package al.view;
import al.view.OpenflViewAdapter.ViewAdapter;
import ec.Entity.Component;
class ViewAdapterBase extends Component {
    public static inline var TYPE = "ViewAdapter";
    public function new() {
        super(TYPE);
    }
}
interface ViewContainer {
    function addChild(view:ViewAdapter):Void;
}
