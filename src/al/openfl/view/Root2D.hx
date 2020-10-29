package al.openfl.view;
import al.al2d.Axis2D;
import al.al2d.Widget2D;
import al.al2d.Widget2DContainer;
import al.appliers.ContainerRefresher;
import al.layouts.WholefillLayout;
import openfl.display.Stage;
class Root2D {
    var w:Widget2D;
    var wc:Widget2DContainer;
    var stage:Stage;

    public function new(w:Widget2D) {
        this.w = w;
        wc = new Widget2DContainer(w);
        w.entity.addComponent(wc);
        for (a in Axis2D.keys) {
            w.axisStates[a].addSibling(new ContainerRefresher(wc));
            wc.setLayout(a, WholefillLayout.instance);
        }
        stage = openfl.Lib.current.stage;
    }



    public function addScreen(w:Widget2D) {
        wc.entity.addChild(w.entity);
        wc.addChild(w);
        wc.refresh();
    }

    public function getWidget()
        return w;
}
