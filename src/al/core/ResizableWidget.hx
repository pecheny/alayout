package al.core;

import al.core.TWidget.IWidget;
import ec.Signal;

interface ResizableWidget<TAxis:Axis<TAxis>> extends ContentSizeProvider<TAxis> extends IWidget<TAxis> {}

interface ContentSizeProvider<TAxis:Axis<TAxis>> {
	var contentSizeChanged(default, null):Signal<TAxis->Void>;

	function getContentSize(a:TAxis):Float;
}
