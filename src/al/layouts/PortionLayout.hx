package al.layouts;

import al.layouts.data.LayoutData.FixedSize;
import al.layouts.data.LayoutData.ISize;
import al.core.WidgetContainer.LayoutPosMode;
import al.core.AxisState;

class PortionLayout implements AxisLayout {
	public static var instance(default, null) = new PortionLayout();

	public function new(gap:ISize = null) {
		if (gap != null)
			this.gap = gap;
	}

	var gap:ISize = new FixedSize(0.);

	public function arrange(pos:Float, size:Float, children:Array<AxisState>, mode:LayoutPosMode) {
		if (children.length == 0)
			return 0.;
		var fixedValue = gap.getFixed();
		var portionsSum = gap.getPortion();
		var coord = mode.isGlobal() ? pos : 0;
		var origin = coord;

		for (child in children) {
			if (!child.isArrangable())
				continue;

			portionsSum += child.size.getPortion();
			fixedValue += child.size.getFixed();
			portionsSum += gap.getPortion();
			fixedValue += gap.getFixed();
		}
		if (portionsSum == 0)
			portionsSum = 1;

		var totalValue = mode.isGlobal() ? size : 1;
		var distributedValue = totalValue - fixedValue;
		inline function getSize(isize:ISize) {
			var size:Float = 0.0;
			size += distributedValue * isize.getPortion() / portionsSum;
			size += isize.getFixed();
			return size;
		}
		coord += getSize(gap);
		for (child in children) {
			if (!child.isArrangable()) // todo handle unmanaged percent size here
				continue;
			var size = getSize(child.size);
			child.apply(coord, size);
			coord += size;
			coord += getSize(gap);
		}
		return coord - origin;
	}
}
