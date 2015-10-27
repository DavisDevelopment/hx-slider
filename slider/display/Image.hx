package slider.display;

import tannus.html.Win;
import tannus.html.Element;
import tannus.io.Signal;
import tannus.io.EventDispatcher;
import tannus.geom.*;

import js.html.ImageElement in Img;

import gryffin.Tools.*;
import gryffin.core.Stage;
import gryffin.core.Entity;
import gryffin.display.Ctx;

import slider.core.Slider;

/**
  * Object-Oriented representation of an Image
  */
class Image extends Entity {
	/* Constructor Function */
	public function new(parent:Slider, ?i:Element):Void {
		super();
		
		//- the Signal which is fired when [img] has finished loading
		load = new Signal();
		getImage( i );
		pos = new Point();
		slider = parent;

		__init();
	}

/* === Instance Methods === */

	/**
	  * Initialize [this] Image
	  */
	override public function init(s : Stage):Void {
		null;
	}

	/**
	  * Render [this] Image
	  */
	override public function render(s:Stage, c:Ctx):Void {
		if (active) {
			c.drawImage(img, 0, 0, width, height, pos.x, pos.y, s.width, s.height);
		}
	}

	/**
	  * Update [this] Image
	  */
	override public function update(s : Stage):Void {
		null;
	}

/* === Utility Methods === */

	/**
	  * Further initialization of the Image
	  */
	private inline function __init():Void {
		/* call the 'load' Signal when the image is complete */
		var loaded = load.call.bind(0);
		img.onload = loaded;
		
		/* if [img] is already loaded when we get it */
		if (img.complete) {
			defer( loaded );
		}
	}

	/**
	  * Initialize the [img] field
	  */
	private inline function getImage(?i : Element):Void {
		if (i != null) {
			if (i.is('img')) {
				img = cast i.toHTMLElement();
			}
			else {
				throw 'InputError: <img> expected';
			}
		}
		else {
			img = cast (new Element('<img></img>').toHTMLElement());
		}
	}

/* === Computed Instance Fields === */

	/* the [src] attribute of the Image */
	public var src(get, set):String;
	private inline function get_src():String {
		return img.src;
	}
	private inline function set_src(v : String):String {
		return (img.src = v);
	}

	/* the width of [this] Image */
	public var width(get, never):Int;
	private inline function get_width():Int return img.naturalWidth;

	/* the height of [this] Image */
	public var height(get, never):Int;
	private inline function get_height():Int return img.naturalHeight;

	/* the index of [this] Image */
	public var index(get, never):Int;
	private inline function get_index() return slider.indexOf(this);

	/* whether [this] Image is active */
	public var active(get, never):Bool;
	private inline function get_active() return slider.isActive(this);

/* === Instance Fields === */

	public var img : Img;
	public var load : Signal<Int>;
	public var pos : Point;
	public var slider : Slider;
}
