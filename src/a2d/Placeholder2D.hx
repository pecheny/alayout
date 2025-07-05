package a2d;

import al.core.Placeholder;

typedef Placeholder2D = Placeholder<Axis2D>;

/**
 *  Options of units  to define zize in gl-like environments, when 'native' units depends on window size.
 *  @see al.al2d.AspectEatio
**/
@:enum abstract ScreenMeasureUnit(Axis<ScreenMeasureUnit>) to Axis<ScreenMeasureUnit> to Int {
    /** Size inpixels */
    var px;

    /** Fraction of smallest screen side */
    var sfr;

    /** Fraction of the parent. */
    var pfr;
}
