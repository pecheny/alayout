package al.al2d;

import al.appliers.ContainerRefresher;
import macros.AVConstructor;
import al.al2d.Placeholder2D;
import al.layouts.AxisLayout;
import Axis2D.AVector2D;

typedef ContainerStyle = AVector2D<AxisLayout>;

class ContainerFactory {
    var styles:Map<String, ContainerStyle> = new Map();

    public function new() {}

    public function regStyle(name, h:AxisLayout, v:AxisLayout) {
        styles[name] = AVConstructor.create(Axis2D, h, v);
    }

    public function create(w:Placeholder2D, styleName:String) {
        var style = styles.get(styleName);
        var wc = new Widget2DContainer(w, Axis2D.aliases.length);
        for (a in Axis2D) {
            wc.setLayout(a, style[a]);
            w.axisStates[a].addSibling(new ContainerRefresher(wc));
        }
        w.entity.addComponent(wc);
        return wc;
    }
}
