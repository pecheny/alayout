package a2d;
import Axis2D.ReadOnlyAVector2D;

/**
* Assuming measure unit associated with smallest window dimension,
* AspectFactors meant to provide current window size in given measure units.
*
* Examples:
* Window 1500 x 1000, AspectFactors: [1.5, 1]
* Window 1000 x 1500, AspectFactors [1, 1.5]
**/


typedef AspectRatio = ReadOnlyAVector2D<Float>;
