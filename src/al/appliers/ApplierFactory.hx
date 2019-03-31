package al.appliers;

import al.appliers.PropertyAccessors.FloatPropertyAccessor;
interface ApplierFactory<TKey> {
    function getPosApplier(axis:TKey):FloatPropertyAccessor;

    function getSizeApplier(axis:TKey):FloatPropertyAccessor;
}

