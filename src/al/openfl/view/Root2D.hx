package al.openfl.view;
import Axis2D;
import al.al2d.Placeholder2D;
import al.al2d.Widget2DContainer;
import al.appliers.ContainerRefresher;
import al.layouts.WholefillLayout;
import openfl.display.Stage;
class Root2D {
    var w:Placeholder2D;
    var wc:Widget2DContainer;
    var stage:Stage;

    public function new(w:Placeholder2D) {
        this.w = w;
        wc = new Widget2DContainer(w, 2);
        w.entity.addComponent(wc);
        for (a in Axis2D) {
            w.axisStates[a].addSibling(new ContainerRefresher(wc));
            wc.setLayout(a, WholefillLayout.instance);
        }
        stage = openfl.Lib.current.stage;
    }



    public function addScreen(w:Placeholder2D) {
        wc.entity.addChild(w.entity);
        wc.addChild(w);
        wc.refresh();
    }

    public function getWidget()
        return w;
}
