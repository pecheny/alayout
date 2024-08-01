package al.utils;

import Axis2D;
import al.al2d.Placeholder2D;
import al.core.AxisState;
import al.core.Placeholder.MultiparentPlaceholder;
import al.core.Placeholder.PlainPlaceholder;
import al.ec.Entity;
import ec.MultiparentEntity;
import macros.AVConstructor;

/**
	PlaceholderBuilder – abstract builder class to shorten placeholder construction. Straightforward way of construction is a bit boilerplate and messy since it involves construction of AxisState instance per axis. And the axisState therefore requires instances of ISize and Position.
	The main idea consists of following:
	- incapsulate details of AxisState construction into the AxisFactory implementation;
	- put set of those factories into a builder according to a given axes set;
	- provide compact api to configure the factories.

	Additional feature is optional dependency container injection.
**/

class PlaceholderBuilder<T:AxisFactory> {
	var factories:AVector2D<T>;
	var _ctx:Entity;

	public var keepStateAfterBuild = false;

	public function b(name:String = null):Placeholder2D {
		var axisStates = AVConstructor.factoryCreate(Axis2D, a -> factories[a].create());
		var w:Placeholder2D;
		var e:ec.Entity;

		if (_ctx != null) {
			var entity = new MultiparentEntity(name);
			e = entity;
			entity.addParent(_ctx);
			var mph = new MultiparentPlaceholder(axisStates);
			mph.setEntity(entity);
			w = mph;
			entity.addComponent(w);
		} else {
			var entity = new Entity(name);
			e = entity;
			w = new PlainPlaceholder(axisStates);
		}
		e.addComponentByType(Placeholder2D, w);
		if (!keepStateAfterBuild)
			reset();
		return w;
	}

	/**
		Provided entity would be used as a source of dependencies not presented in the visual hierarchy.
		Model/Controller belonging its own hierarchy can be injected into a view this way.
	**/
	public function ctx(e:Entity) {
		_ctx = e;
		return this;
	}

	function reset() {
		_ctx = null;
	}
}

interface AxisFactory {
	function create():AxisState;
}
