package slider.core;

import gryffin.core.Entity;
import gryffin.core.Stage;
import gryffin.display.Ctx;

import slider.display.Image;
import slider.core.SliderSettings;

import tannus.html.Element;
import tannus.html.Win;
import tannus.ds.Object;
import tannus.ds.AsyncPool;
import tannus.io.VoidSignal;
import tannus.geom.*;

class Slider extends Entity {
	/* Constructor Function */
	public function new(opts:Object, children:Array<Element>):Void {
		super();

		options = opts;
		settings = new SliderSettings(options);
		trace( settings );
		ready = new VoidSignal();
		active = 0;
		loaded = false;

		processChildren( children );
	}

/* === Instance Methods === */

	/**
	  * Get the Image at the given index
	  */
	public function image(index : Int):Null<Image> {
		return images[index];
	}

	/**
	  * Determine whether the given Image is the active one
	  */
	public function isActive(img : Image):Bool {
		return (indexOf(img) == active);
	}

	/**
	  * Get the index of the given Image
	  */
	public function indexOf(img : Image):Int {
		return (loaded ? (images.indexOf(img)) : -1);
	}

	/**
	  * Move to the next slide
	  */
	public function frame():Void {
		if (loaded) {
			trace('Moving to the next Frame');
			active++;
			if (active >= images.length)
				active = 0;
		}
		queueNext();
	}


/* === Utility Methods === */

	/**
	  * Start [this] Slider's cycle
	  */
	public function start():Void {
		queueNext();
	}

	/**
	  * Queue up the next invokation in the cycle
	  */
	private function queueNext():Void {
		Win.current.setTimeout(frame, Math.round(settings.slideDuration));
	}

	/**
	  * Figure out what to do with each child of the Canvas
	  */
	private function processChildren(children : Array<Element>):Void {
		var imgs:Array<Element> = new Array();
		/* Validate the Elements */
		for (child in children) {
			if (child.is('img')) {
				imgs.push( child );
			}
			else {
				throw new js.Error('What the fuck are you doing?');
			}
		}

		/* Load the Images */
		loadAll(imgs, function(_images) {
			images = _images;
			trace( images );
			for (img in images)
				stage.addChild( img );
			ready.fire();
			loaded = true;
		});
	}

	/**
	  * Take an Array of <img> Elements, and create an Array of Image objects
	  */
	private function loadAll(els:Array<Element>, cb:Array<Image>->Void):Void {
		var pool:AsyncPool<Image> = new AsyncPool();

		for (e in els) {
			pool.push(function(done) {
				var img:Image = new Image(this, e);
				img.load.once(untyped done.bind(img));
			});
		}

		pool.run( cb );
	}

/* === Instance Fields === */

	public var options : Object;
	public var settings : SliderSettings;
	public var images : Array<Image>;
	public var ready : VoidSignal;
	public var active : Int;

	private var loaded : Bool;
}
