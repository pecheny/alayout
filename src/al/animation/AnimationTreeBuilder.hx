package al.animation;
import macros.AVConstructor;
import al.layouts.data.LayoutData;
import al.appliers.ContainerRefresher;
import al.core.AxisState;
import al.layouts.AxisLayout;
import al.layouts.data.LayoutData.PositionType;
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

    public function addChild(wc:AnimContainer, w:AnimationPlaceholder) {
        wc.entity.addChild(w.entity);
        wc.addChild(w);
    }

    var defaultSizeRec = {
        type:SizeType.fraction,
        value:1.
    }
    public function animationWidget(e:Entity, rec:AxisRec):AnimationPlaceholder {
        var sizeRec:SizeRec =
        if (rec.size == null) defaultSizeRec else rec.size;

        if (sizeRec.type == null)
            sizeRec.type = fraction;


        var size = switch sizeRec.type {
            case fixed: new FixedSize(sizeRec.value); //todo /2 its fixed size in units of the parent
            case fraction: new FractionSize(sizeRec.value);
//            case px: new PixelSize(axis, screen, value);
        }
        var timeAxis = new AxisState(new Position(), size);
        var animationWidget = new AnimationPlaceholder(AVConstructor.create(timeAxis));
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

    function animationContainer(aw:AnimationPlaceholder, l):AnimContainer {
        var ac = new AnimContainer(aw);
        aw.axisStates[TimeAxis.time].addSibling(new ContainerRefresher(ac));
        ac.setLayout(TimeAxis.time, l);
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
@:enum abstract SizeType(Int){
    var fraction;
    var fixed;
}

