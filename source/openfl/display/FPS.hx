package openfl.display;

import haxe.Timer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end
#if flash
import openfl.Lib;
#end

#if openfl
import openfl.system.System;
#end

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FPS extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 10, color, true);
		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";
		#if IS_DEBUG background = true;
		backgroundColor = 0x506469; #end

		cacheCount = 0;
		currentTime = 0;
		times = [];

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end
	}

	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);
		if (currentFPS > ClientPrefs.data.framerate) currentFPS = ClientPrefs.data.framerate;

		if (currentCount != cacheCount /*&& visible*/)
		{
			text = "FPS: " + currentFPS;
			var memoryMegas:Float = 0;
			
			#if openfl
			if (System.totalMemory < 1000000000)
				{
					memoryMegas = Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000, 1));
					text += " - Memory: " + memoryMegas + " MB";
				} else {
					memoryMegas = Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000000, 1));
					text += " - Memory: " + memoryMegas + " GB";
				}
			#end

			textColor = 0xFFFF8800;
			if (Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000000, 1)) > 3 || currentFPS <= ClientPrefs.data.framerate / 1.5)
			{
				textColor = 0xFFFF5E00;
			} else if (Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000000, 1)) > 4 || currentFPS <= ClientPrefs.data.framerate / 2)
			{
				textColor = 0xFFDF5A01;
			} else if (Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000000, 1)) > 6 || currentFPS <= ClientPrefs.data.framerate / 4)
			{
				textColor = 0xFFFF0000;
			}

			#if (gl_stats && !disable_cffi && (!html5 || !canvas))
			text += "\ntotalDC: " + Context3DStats.totalDrawCalls();
			text += "\nstageDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE);
			text += "\nstage3DDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE3D);
			#end

			text += "\n";
		}

		cacheCount = currentCount;
	}
}
