package slider.core;

import tannus.ds.Object;

/**
  * The settings for a Slider
  */
class SliderSettings {
	/* Constructor Function */
	public function new(o : Object):Void {
		slideDuration = (o['slide_duration'] || 2000);
		transition = (o['transition'] || 'jump');
	}

/* === Instance Fields === */

	public var slideDuration : Float;
	public var transition : SlideTransition;
}
