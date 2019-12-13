package al.view;
import al.ec.Entity.Component;
import al.openfl.OpenflViewAdapter.ViewAdapter;
class ViewAdapterBase extends Component {
    public function new() {}
}
interface ViewContainer {
    function addChild(view:ViewAdapter):Void;
}
