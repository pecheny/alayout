package example;

import al.al2d.Axis2D;
import al.Builder;
import al.openfl.OpenflViewAdapter.ViewAdapter;
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

        b.onAddedToContainer.listen(
            function (wc, w) {
                var doChild:ViewAdapter = w.entity.getComponent(ViewAdapter);
                if (doChild == null)
                    return;
                openfl.Lib.current.addChild(doChild.view);
            }
        );

        var sprite = alias -> wb.sprite( b.widget(), alias);

        var root = new Root2D(b.widget());
        addChild(root.rootView);

        var screen = b
        .align(Axis2D.horizontal)
        .container([
            wb.rect(b.widget()),
            wb.rect(b.widget()),
            b.weight(2, sprite("FingertapL")),
            b.weight(2,
            b.align(Axis2D.vertical)
            .container([
                b.weight(2, sprite("FingertapR")),
                b.weight(1, sprite("FingertapL")),
            ])),
        ]);

        root.addScreen(screen);
        new StageResizer(root.getWidget().axisStates);
    }


}


