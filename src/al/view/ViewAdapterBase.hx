package al.view;
import al.ec.Entity.Component;
import al.view.OpenflViewAdapter.ViewAdapter;
class ViewAdapterBase extends Component {
    public function new() {}
}
interface ViewContainer {
    function addChild(view:ViewAdapter):Void;
}
