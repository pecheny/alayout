package a2d;

import Axis2D;
import al.core.TWidget.IWidget;


interface ProxyTransform extends IWidget<Axis2D>{
    public var target(default, null):Placeholder2D;
}