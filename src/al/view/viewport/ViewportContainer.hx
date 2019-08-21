package al.view.viewport;
class ViewportContainer implements Viewportable {
    var viewportables:Array<Viewportable> = [];
    var x:Int;
    var y:Int;
    var w:Int;
    var h:Int;

    public function new() {}

    public function addViewportable(v:Viewportable) {
        viewportables.push(v);
        v.setViewport(x,y,w,h);
    }

    public function setViewport(x:Int, y:Int, w:Int, h:Int):Void {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        for (v in viewportables)
            v.setViewport(x, y, w, h);
    }
}

