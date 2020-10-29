package example;

import al.openfl.display.FlashDisplayRoot;
import al.al2d.Axis2D;
import al.Builder;
import al.openfl.StageResizer;
import al.openfl.view.Root2D;
import al.openfl.ViewBuilder;
import openfl.display.Sprite;

class Main2 extends Sprite {
    public function new() {
        super();
        var b = new Builder();
        var fac = new MovieClipAdapterLoader("fingers");
        var wb = new ViewBuilder();
        wb.regFactory(fac);

        var sprite = alias -> wb.sprite(b.widget(), alias);

        var root = new Root2D(b.widget());
        root.getWidget().entity.addComponent(new FlashDisplayRoot(openfl.Lib.current));

        var screen = b
        .align(Axis2D.horizontal)
        .container([
            wb.rect(b.widget(portion, 0.5, portion, 1)),
            wb.rect(b.widget(portion, 0.5, portion, 1)),
            wb.sprite(Builder.widget2d(), "FingertapL"),
            b.align(Axis2D.vertical)
            .container([
                wb.sprite(Builder.widget2d(), "FingertapL"),
                wb.sprite(Builder.widget2d(), "FingertapR"),
            ]),
        ]);

        root.addScreen(screen);
        new StageResizer(root.getWidget().axisStates);
    }


}


