package al.animation;

import ec.Component;
import ec.Entity;

@:build(ec.macros.Macros.buildGetOrCreate())
class Animator extends Component {
    var channels:Array<Float->Void> = []; // befor init only

    public function setT(t:Float) {
        for (ch in channels)
            ch(t);
    }

    public function addAnim(h) {
        channels.push(h);
    }
}
