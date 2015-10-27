package slider.display;

import gryffin.core.Stage;
import gryffin.core.Entity;
import gryffin.display.Ctx;

import tannus.geom.*;
import tannus.graphics.Color;
import tannus.math.Percent;

class Loading extends Entity {
	/* Constructor Function */
	public function new():Void {
		super();
		pos = new Point();
		progress = 0;
		size = 30;
		color = '#FF0000';
	}

/* === Instance Methods === */

	/**
	  * Update [this] Loading icon
	  */
	override public function update(s : Stage):Void {
		progress++;
		pos = s.rect.center;
		if (progress.value > 100)
			progress.value = 0;
	}

	/**
	  * Render [this] Loading icon
	  */
	override public function render(s:Stage, c:Ctx):Void {
		c.save();
		/* draw the circle */
		c.beginPath();
		c.strokeStyle = '#666';
		c.lineWidth = 6;
		c.arc(pos.x, pos.y, size, 0, 2*Math.PI, false);
		c.stroke();
		c.closePath();

		/* draw the 'loaded' portion */
		c.beginPath();
		c.strokeStyle = color.toString();
		c.lineWidth = 6;
		c.lineCap = 'round';
		c.arc(pos.x, pos.y, size, 0, angle.radians, false);
		c.stroke();
		c.closePath();
		c.restore();
	}

/* === Computed Instance Fields === */

	/**
	  * The angle and shit
	  */
	public var angle(get, never):Angle;
	private inline function get_angle():Angle {
		return new Angle(progress.of(360));
	}

/* === Instance Fields === */

	public var pos : Point;
	public var progress : Percent;
	public var color : Color;
	public var size : Float;
}
