package al.view;
import openfl.display.Stage;
import al.al2d.Widget2DContainer;
import al.appliers.ContainerRefresher;
import al.layouts.WholefillLayout;
import openfl.events.Event;
import openfl.display.Sprite;
import openfl.display.DisplayObjectContainer;
import al.al2d.Widget2D;
import al.view.OpenflViewAdapter.ViewAdapter;
import al.al2d.Axis2D;
class Root2D {
    var w:Widget2D;
    var wc:Widget2DContainer;
    public var rootView(default, null):DisplayObjectContainer;
    var stage:Stage;

    public function new(w:Widget2D) {
        this.w = w;
        wc = new Widget2DContainer(w);
        w.entity.addComponent(wc);
        for (a in Axis2D.keys) {
            w.axisStates[a].addSizeApplier(new ContainerRefresher(wc));
            wc.setLayout(a, WholefillLayout.instance);
        }
        stage = openfl.Lib.current.stage;
        stage.addEventListener(Event.RESIZE, updateRootSize);
        updateRootSize(null);
        rootView = new Sprite();
        addView(w, rootView);
    }

    inline function addView(w:Widget2D, v:DisplayObjectContainer) {
        var adapter = new ViewAdapter(w, v);
        w.entity.addComponent(adapter);
        return adapter;
    }

    public function addScreen(w:Widget2D) {
        wc.entity.addChild(w.entity);
        var doContatiner:ViewAdapter = wc.entity.getComponent(ViewAdapter);
        var doChild:ViewAdapter = w.entity.getComponent(ViewAdapter);
        doContatiner.addChild(doChild);
        wc.addChild(w);
        wc.refresh();
    }

    function updateRootSize(e) {
        w.axisStates[Axis2D.horizontal].applySize(stage.stageWidth);
        w.axisStates[Axis2D.vertical].applySize(stage.stageHeight);
    }
}
