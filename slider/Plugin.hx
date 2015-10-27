package slider;

import js.html.CanvasElement in Canvas;

import gryffin.Tools.*;
import gryffin.core.*;
import slider.gryffin.*;

import slider.core.Slider;

import tannus.html.Win;
import tannus.html.Element;
import tannus.ds.Object;
import tannus.ds.Dict;
import tannus.io.Signal;

class Plugin {
	/**
	  * Actual 'jQuery.fn.slider' Function
	  */
	public static function slider(options : Object):Void {
		//- get a reference to 'this'
		var nself:Dynamic = js.Lib.nativeThis;

		//- get [this] as an Element
		var self:Element = new Element(nself);

		//- if [self] is a CanvasElement
		if (self.is('canvas')) {
			var canvas:Canvas = cast self.toHTMLElement();

			//- if [this] Canvas hasn't already been slider-ified
			if (!history.exists(canvas)) {
				//- build a Stage from [canvas]
				var stage:Stage = new Stage( canvas );

				//- get the children of [self]
				var children:Element = self.children();
				
				//- create the Slider
				var slider:Slider = new Slider(options, children.toArray());
				
				//- add the Slider to the Stage
				stage.addChild( slider );

				//- start the Slider
				slider.ready.once(slider.start);

				//- add a record of [this] invokation
				history[canvas] = 0;

				//- Alert the rest of the code that a new Stage has been created
				created.call( stage );
			}
		}

		//- otherwise, complain about it
		else {
			throw new js.Error('Must be a CanvasElement!');
		}
	}

	/**
	  * Actually bind [this] Plugin to jQuery
	  */
	public static function bind():Void {
		var prototype:Object = new Object(untyped __js__('jQuery.fn'));
		prototype['slider'] = slider;
	}

/* === Static Fields === */

	public static var history:Dict<Canvas, Int> = {new Dict();};
	public static var created:Signal<Stage> = {new Signal();};
}
