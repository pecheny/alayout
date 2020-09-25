package al.appliers;

import al.core.AxisApplier;
interface ApplierFactory<TKey> {

    public function getApplier(a:TKey):AxisApplier;
}

