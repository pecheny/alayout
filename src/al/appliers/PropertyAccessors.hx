package al.appliers;

@:autoBuild(al.appliers.buildmacro.AccessorMacro.build())
interface PropertyAccessor<Tval> {
    function setValue(val:Float):Void;
    function getValue():Float;
}

interface FloatPropertyWriter {
    function setValue(val:Float):Void;
}

interface FloatPropertyReader {
    function getValue():Float;
}

interface FloatPropertyAccessor extends FloatPropertyReader extends FloatPropertyWriter {
}

