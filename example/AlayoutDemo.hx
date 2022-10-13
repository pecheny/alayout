package ;

import al.layouts.data.LayoutData.FractionSize;
import al.openfl.display.FlashDisplayRoot;
import al.Builder as B;
import al.openfl.StageResizer;
import al.openfl.view.Root2D;
import al.openfl.ViewBuilder;
import openfl.display.Sprite;

using al.Builder;
class AlayoutDemo extends Sprite {
    public function new() {
        super();
        var fac = new MovieClipAdapterLoader("fingers");
        var wb = new ViewBuilder();
        wb.regFactory(fac);

        var sprite = alias -> wb.sprite(B.widget(), alias);

        var root = new Root2D(B.widget());
        root.getWidget().entity.addComponent(new FlashDisplayRoot(openfl.Lib.current));

        var screen = B
        .h().withChildren([
            wb.rect(B.widget(new FractionSize(0.5), new FractionSize(1))),
            wb.rect(B.widget(new FractionSize(0.5), new FractionSize(1))),
            wb.sprite(B.widget(), "FingertapL"),
            B.v().withChildren([
                wb.sprite(B.widget(), "FingertapL"),
                wb.sprite(B.widget(), "FingertapR"),
            ]),
        ]);

        root.addScreen(screen);
        new StageResizer(root.getWidget().axisStates);
    }
}


