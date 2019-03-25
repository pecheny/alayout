package al.view;
//class ContainerStorageAccessor implements FloatPropertyAccessor {
//    var value:Float;
//    var container:Widget2DContainer;
//
//    public function new(container:Widget2DContainer) {
//        this.container = container;
//    }
//
//    public function setValue(val:Float):Void {
//        value = val;
//        container.refresh();
//    }
//
//    public function getValue():Float {
//        return value;
//    }
//}
//
//class ContainerStorageFactory implements ApplierFactory<Axis2D> {
//    var container:Widget2DContainer;
//
//    public function new(container:Widget2DContainer) {
//        this.container = container;
//    }
//
//    public function getPosApplier(axis:Axis2D):FloatPropertyAccessor {
//        return new ContainerStorageAccessor(container);
//    }
//
//    public function getSizeApplier(axis:Axis2D):FloatPropertyAccessor {
//        return new ContainerStorageAccessor(container);
//    }
//}

//class ProxyContainerPropertyAccessor implements FloatPropertyAccessor {
//    var container:Widget2DContainer;
//    var accessor:FloatPropertyAccessor;
//
//    public function new(container:Widget2DContainer, accessor:FloatPropertyAccessor) {
//        this.container = container;
//        this.accessor = accessor;
//    }
//
//    public function setValue(val:Float):Void {
//        accessor.setValue(val);
//        container.refresh();
//    }
//
//    public function getValue():Float {
//        return accessor.getValue();
//    }
//}


//class ProxyContainerPropertyAccessorFactory implements ApplierFactory<Axis2D> {
//    var container:Widget2DContainer;
//    var factory:ApplierFactory<Axis2D>;
//
//    public function new(container:Widget2DContainer, factory:ApplierFactory<Axis2D>) {
//        this.container = container;
//        this.factory = factory;
//    }
//
//    public function getPosApplier(axis:Axis2D):FloatPropertyAccessor {
//        return new ProxyContainerPropertyAccessor(container, factory.getPosApplier(axis));
//    }
//
//    public function getSizeApplier(axis:Axis2D):FloatPropertyAccessor {
//        return new ProxyContainerPropertyAccessor(container, factory.getSizeApplier(axis));
//    }
//}



