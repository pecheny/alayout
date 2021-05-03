package al.al2d;
import haxe.ds.ReadOnlyArray;

/**
* Assuming measure unit associated with smallest window dimension,
* AspectFactors meant to provide current window size in given measure units.
*
* Examples:
* Window 1500 x 1000, AspectFactors: [1.5, 1]
* Window 1000 x 1500, AspectFactors [1, 1.5]
**/
abstract AspectRatio(ReadOnlyArray<Float>) from ReadOnlyArray<Float> to ReadOnlyArray<Float>{
    public inline function getFactor(a) return this[a];

    @:arrayAccess public inline function get(a:Int) return this[a];
}

