package al.appliers.buildmacro;
import haxe.macro.Context;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Type.ClassType;
using haxe.macro.Context;
class AccessorMacro {
    inline static var TARGET_TYPE_INDEX = 0;
    inline static var VALUE_TYPE_INDEX = 1;

    static var STATEFULL_INTERFACE_NAME = ~/PropertyAccessor.*/;
    inline static var TARGET_FIELD_NAME = "target";


    public static function build() {
        var cl = Context.getLocalClass().get();
        var trgType = cl.params[0].t.toComplexType();
        var valType:ComplexType;
        for (intf in cl.interfaces) {
            trace(cl.name + " " + intf);
            valType = switch (intf){
                case ({t:_.get() => {name:interfaceName}, params:[ tv]}): tv.toComplexType();
                case _:null;
            };
            if (valType != null)
                break;
        }
        var types = new TypesPair(trgType, valType);

        var fields = Context.getBuildFields();
        var propertyName =
        switch(cl.meta.extract(":property")[0]) {
            case {params:[{expr:EConst(CString(val))}]} : val;
            case _ : throw "Wrong";
        }
        fields.push({
            name:"target",
            kind:FVar(types.getTargetType(), null),
            pos:Context.currentPos()
        });
        fields.push({
            name:"new",
            kind:FFun({
                args:[{name:"target", type:types.getTargetType()}],
                expr:macro this.target = target,
                ret:null
            }),
            pos:Context.currentPos(),
            access:[APublic]
        });
        fields.push({
            name:"getValue",
            kind:FFun({
                args:[],
                expr:macro return target.$propertyName,
                ret:types.getValueType()
            }),
            pos:Context.currentPos(),
            access:[APublic]
        });

        fields.push({
            name:"setValue",
            kind:FFun({
                args:[{name:"val", type:types.getValueType()}],
                expr:macro { target.$propertyName = val;},
                ret:null
            }),
            pos:Context.currentPos(),
            access:[APublic]
        });

        return fields;
    }


}
abstract TypesPair(Array<ComplexType>) {
    public inline function new(targetT, valueeT) this = [targetT, valueeT];

    public inline function getTargetType() return this[0];

    public inline function getValueType() return this[1];
}