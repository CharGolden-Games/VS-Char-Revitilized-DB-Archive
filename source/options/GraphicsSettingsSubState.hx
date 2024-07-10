package options;

import objects.Character;

class GraphicsSettingsSubState extends BaseOptionsMenu
{
	var antialiasingOption:Int;
	var boyfriend:Character = null;
	public function new()
	{
		title = 'Graphics';
		rpcTitle = 'Graphics Settings Menu'; //for Discord Rich Presence

		boyfriend = new Character(840, 170, 'bf', true);
		boyfriend.setGraphicSize(Std.int(boyfriend.width * 0.75));
		boyfriend.updateHitbox();
		boyfriend.dance();
		boyfriend.animation.finishCallback = function (name:String) boyfriend.dance();
		boyfriend.visible = false;

		//I'd suggest using "Low Quality" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Low Quality', //Name
			'If checked, disables some background details,\ndecreases loading times and improves performance.', //Description
			'lowQuality', //Save data variable name
			'bool'); //Variable type
		addOption(option);

		var option:Option = new Option('Anti-Aliasing',
			'If unchecked, disables anti-aliasing, increases performance\nat the cost of sharper visuals.',
			'antialiasing',
			'bool');
		option.onChange = onChangeAntiAliasing; //Changing onChange is only needed if you want to make a special interaction after it changes the value
		addOption(option);
		antialiasingOption = optionsArray.length-1;

		var option:Option = new Option('Shaders', //Name
			"If unchecked, disables shaders.\nIt's used for some visual effects, and also CPU intensive for weaker PCs.", //Description
			'shaders',
			'bool');
		addOption(option);

		/*var option:Option = new Option('Combustible Lemons',
		"All right, I've been thinking, when life gives you lemons, don't make lemonade! Make life take the lemons back! Get mad! I don't want your damn lemons! What am I supposed to do with these? Demand to see life's manager! Make life rue the day it thought it could give Cave Johnson lemons! Do you know who I am? I'm the man whose gonna burn your house down! with the lemons!",
		'combustibleLemons',
		'bool');
		addOption(option);*/

		var option:Option = new Option('GPU Caching', //Name
			"If checked, allows the GPU to be used for caching textures, decreasing RAM usage.\nDon't turn this on if you have a shitty Graphics Card.", //Description
			'cacheOnGPU',
			'bool');
		addOption(option);

		#if !html5 //Apparently other framerates isn't correctly supported on Browser? Probably it has some V-Sync shit enabled by default, idk
		var option:Option = new Option('Framerate',
			"Pretty self explanatory, isn't it?",
			'framerate',
			'int');
		addOption(option);

		option.minValue = 60;
		option.maxValue = 360;
		option.displayFormat = '%v FPS';
		option.onChange = onChangeFramerate;
		#end

		super();
		insert(1, boyfriend);
	}

	function onChangeAntiAliasing()
	{
		for (sprite in members)
		{
			var sprite:FlxSprite = cast sprite;
			if(sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) {
				sprite.antialiasing = ClientPrefs.data.antialiasing;
			}
		}
	}

	function onChangeFramerate()
	{
		if(ClientPrefs.data.framerate > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = ClientPrefs.data.framerate;
			FlxG.drawFramerate = ClientPrefs.data.framerate;
		}
		else
		{
			FlxG.drawFramerate = ClientPrefs.data.framerate;
			FlxG.updateFramerate = ClientPrefs.data.framerate;
		}
	}

	override function changeSelection(change:Int = 0)
	{
		super.changeSelection(change);
		boyfriend.visible = (antialiasingOption == curSelected);
	}
}