package al.animation;
import al.layouts.data.LayoutData.Size;
import al.layouts.data.LayoutData.Position;
import al.appliers.ContainerRefresher;
import al.core.AxisState;
import al.layouts.AxisLayout;
import al.layouts.data.LayoutData.PositionType;
import al.layouts.data.LayoutData.SizeType;
import al.layouts.PortionLayout;
import al.layouts.WholefillLayout;
import al.animation.Animation;
import ec.Entity;
class AnimationTreeBuilder {
    public function new() {
    }

    public function build(rec:AnimationContainerRec) {
        var w = animationWidget(new Entity(), rec);
        switch rec {
            case {layout:l, children:children}  if (l != null && children != null): {
//                trace(rec  + " " + l);
                var con = animationContainer(w, getLayout(l));
                for (ch in children) {
                    addChild(con, build(ch));
                }
                con.refresh();
            };
            case _:
        }
        return w;
    }

    public static var tree:AnimationContainerRec = {
        layout:"portion",
        children:[
            {size:{value:1. }},
            {size:{value:1. }},
            {size:{value:1. }},
        ]
    }

    public function addChild(wc:AnimContainer, w:AnimWidget) {
        wc.entity.addChild(w.entity);
        wc.addChild(w);
    }

    public function animationWidget(e:Entity, rec:AxisRec):AnimWidget {
        var size = if (rec.size != null)
            new Size(rec.size.type != null ? rec.size.type : portion, rec.size.value);
        else
            new Size(portion, 1);
        var timeAxis = new AxisState(new Position(), size);
        var animationWidget = new AnimWidget([TimeAxis.time => timeAxis]);
        e.addComponent(animationWidget);
        return animationWidget;
    }

    var layouts:Map<String, AxisLayout> = [
        "portion" => PortionLayout.instance,
        "wholefill" => WholefillLayout.instance
    ];

    public function addLayout(alias:String, l:AxisLayout) {
        layouts[alias] = l;
    }

    function getLayout(name) {
        if (!layouts.exists(name))
            throw 'there is no $name layout';
        return layouts[name] ;
    }

    function animationContainer(aw:AnimWidget, l):AnimContainer {
        var ac = new AnimContainer(aw);
        aw.axisStates[TimeAxis.time].addSibling(new ContainerRefresher(ac));
        ac.setLayout(TimeAxis.time, l, global);
        aw.entity.addComponent(ac);
        return ac;
    }
}

typedef AnimationContainerRec = {
    >AxisRec,
    ?layout:String,
    ?children:Array<AnimationContainerRec>
}

typedef AxisRec = {
    ?size:SizeRec,
    ?pos:PosRec
}

typedef SizeRec = {
    ?type:SizeType,
    value:Float
}
typedef PosRec = {
    ?type:PositionType,
    value:Float
}


