package a2d;

import a2d.Widget2DContainer;
import al.layouts.AxisLayout;

typedef LayoutStorage = Map<String, AxisLayout>;

class ContainerStyler {
    var hlayouts:Map<String, AxisLayout> = new Map<String, AxisLayout>();
    var vlayouts:Map<String, AxisLayout> = new Map<String, AxisLayout>();

    public function new() {}

    public function reg(name:String, hl:AxisLayout, vl:AxisLayout) {
        hlayouts.set(name, hl);
        vlayouts.set(name, vl);
    }

    public function stylize(wc:Widget2DContainer, style:String) {
        wc.setLayout(horizontal, hlayouts[style]);
        wc.setLayout(vertical, vlayouts[style]);
    }
}
