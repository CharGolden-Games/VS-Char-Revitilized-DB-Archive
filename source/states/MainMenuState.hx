package states;

import flixel.system.FlxAssets.FlxGraphicAsset;
import substates.GameplayChangersSubstate;
import backend.WeekData;
import backend.Achievements;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;

import flixel.input.keyboard.FlxKey;
import lime.app.Application;

import objects.AchievementPopup;
import states.editors.MasterEditorMenu;
import states.gallery.MasterGalleryMenu;
import options.OptionsState;
import substates.DebugPrompt;

#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = " Psych Engine v0.7.1h | Funkin' 0.2.8"; // Just cause. its fun to tell people im using an older version of psych, with some things from 0.7.3 i backported
	public static var charEngineVersion:String = '0.9.1'; // Used for making sure im not an idiot, and properly update the engine version lmao.
	public static var vsCharVersion:String = 'Alpha 1.1.5'; // Used for updating
	public static var discordRPCString:String;
	public static var curSelected:Int = 0;
	public var MenuOptionImage = new FlxSprite().loadGraphic(Paths.image('menuimage'));
	public static var randomBG:FlxGraphicAsset;
	var hasRandomizedBG:Bool = false;
	public static var bgPaths:Array<String> = 
	[
		// REMAKE THESE!!!!
		'menuBG/Micheal',
		'menuBG/CharMenacing',
		'menuBG/TheGangsAllHere',
	];

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	public var justPressedDebugKey:Bool = false;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		#if MODS_ALLOWED 'mods', #end
		#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'toolbox',
		'gallery',
		'credits',
		#if SHOW_DONATE_OPTION 'donate', #end //in case you still want it
		'options'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;


	override function create()
	{
		openfl.Lib.application.window.title = "Friday Night Funkin': VS Char Revitalized | Main Menu | ";
		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		if (!hasRandomizedBG)
			{
		randomizeBG();
			}
		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(randomBG);
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.color = 0xFFfde871;
		add(bg);

			MenuOptionImage.frames = Paths.getSparrowAtlas('menuimage');
				MenuOptionImage.animation.addByPrefix('story_mode', "menu-storymode");
				MenuOptionImage.animation.addByPrefix('options', "menu-options");
				MenuOptionImage.animation.addByPrefix('gallery', "menu-gallery");
				MenuOptionImage.animation.addByPrefix('toolbox', "menu-toolbox");
				#if MODS_ALLOWED MenuOptionImage.animation.addByPrefix('mods', "menu-mods"); #end
				#if ACHIEVEMENTS_ALLOWED MenuOptionImage.animation.addByPrefix('awards', "menu-awards"); #end
				MenuOptionImage.animation.addByPrefix('credits', "menu-credits");
				MenuOptionImage.animation.addByPrefix('freeplay', "menu-freeplay");
				#if SHOW_DONATE_OPTION MenuOptionImage.animation.addByPrefix('donate', "menu-donate"); #end // Just in case you wanna show the donate option
				if(!ClientPrefs.data.lowQuality) {
				MenuOptionImage.antialiasing = ClientPrefs.data.antialiasing; // uhh it looks like shit without this lol.
				MenuOptionImage.setGraphicSize(Std.int(MenuOptionImage.width * 0.75));
				MenuOptionImage.scrollFactor.set(0, 0);
				MenuOptionImage.offset.set(-832, -273); 
				add(MenuOptionImage);	
	}

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite().loadGraphic(randomizeBG());
		magenta.antialiasing = ClientPrefs.data.antialiasing;
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.color = 0xFFfd719b;
		add(magenta);


		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			// menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}
		
		FlxG.camera.follow(camFollow, null, 0);
		var psychVersionShit:FlxText = new FlxText(FlxG.width * 0.7, 44, 0, "Based on:" + psychEngineVersion, 12);
		psychVersionShit.scrollFactor.set();
		psychVersionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		psychVersionShit.x = FlxG.width - (psychVersionShit.width + 5);
		add(psychVersionShit);
		var charEngineVersionShit:FlxText = new FlxText(FlxG.width * 0.7, 24, 0, "Char Engine v" + charEngineVersion, 12);
		charEngineVersionShit.scrollFactor.set();
		charEngineVersionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		charEngineVersionShit.x = FlxG.width - (charEngineVersionShit.width + 5);
		add(charEngineVersionShit);
		if (StringTools.startsWith(vsCharVersion.toLowerCase(), 'alpha')) // so it auto does it lmao.
			{
				discordRPCString = "VS Char Revitalized " + vsCharVersion;
			} else if (StringTools.startsWith(vsCharVersion.toLowerCase(), ' alpha')) {
				discordRPCString = "VS Char Revitalized" + vsCharVersion;
			} else {
				discordRPCString = "VS Char Revitalized v" + vsCharVersion.trim();
			}
		var vsCharVersionShit:FlxText = new FlxText(FlxG.width * 0.7, 4, 0, discordRPCString, 12);
		vsCharVersionShit.scrollFactor.set();
		vsCharVersionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		vsCharVersionShit.x = FlxG.width - (vsCharVersionShit.width + 5);
		add(vsCharVersionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementPopup('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;
	var curOption:String;

	override function update(elapsed:Float)
	{
		switch (optionShit[curSelected]) {
			case 'story_mode':
				curOption = 'Story Mode | The main stories!';
			case 'freeplay':
				curOption = 'Freeplay | Browse the song list! also the 0.7.3 music player';
			case 'mods':
				curOption = 'Mods | You better not have installed any sussy mods.';
			case 'awards':
				curOption = 'Awards | See what you won!';
			case 'toolbox':
				curOption = 'Toolbox | The new home of the Editor Menu lmao';
			case 'gallery':
				curOption = 'Gallery | Look at all the pretty pictures!!';
			case 'credits':
				curOption = 'Credits | See who helped make the mod!';
				//lmao this was "game" instead of "mod" before, which is wrong.
			case 'options':
				curOption = 'Options | Configure yo shiz';
		}
		
		openfl.Lib.application.window.title = "Friday Night Funkin': VS Char Revitalized | Main Menu | " + curOption;
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}
		FlxG.camera.followLerp = FlxMath.bound(elapsed * 9 / (FlxG.updateFramerate / 60), 0, 1);

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(ClientPrefs.data.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplaySelectState());
									case 'toolbox':
										MusicBeatState.switchState(new MasterEditorMenu());
									case 'gallery':
										FlxG.sound.playMusic(Paths.music('shop', 'shared'), 2);
										MusicBeatState.switchState(new MasterGalleryMenu());
									#if MODS_ALLOWED case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									#end
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										LoadingState.loadAndSwitchState(new OptionsState());
										OptionsState.onPlayState = false;
										if (PlayState.SONG != null)
										{
											PlayState.SONG.arrowSkin = null;
											PlayState.SONG.splashSkin = null;
										}
								}
							});
						}
					});
				}
			}
		}
		#if desktop
			if (controls.justPressed('debug_1'))
			{
				CursorChangerShit.showCursor(true);
				openSubState(new DebugPrompt('HEY thats in TOOLBOX NOW', 0, goToEditorMenu, null, false, 'Take Me!', 'Ok'));
			}
			else if (controls.justPressed('debug_2'))
				{
					trace('TO THE EXPERIMENTAL MENU!!!!');
					MusicBeatState.switchState(new ComputerMainMenuState());
				}
			#end

		super.update(elapsed);
		
		if (!ClientPrefs.data.lowQuality){
		var menuoption:String = optionShit[curSelected];
		MenuOptionImage.animation.play(menuoption);}
			menuItems.forEach(function(spr:FlxSprite)
		{
			// spr.screenCenter(X);
		});
	}


	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			//spr.updateHitbox();
			spr.scale.x = 0.7;
			spr.scale.y = 0.7;

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				spr.scale.x = 1;
				spr.scale.y = 1;
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x - 300, spr.getGraphicMidpoint().y - add);
				// spr.centerOffsets();
			}

		}); 
	}
	public static function randomizeBG():flixel.system.FlxAssets.FlxGraphicAsset
	{
		var chance:Int = FlxG.random.int(0, bgPaths.length - 1);
		randomBG = Paths.image(bgPaths[chance]);
		return Paths.image(bgPaths[chance]);
	}
	function goToEditorMenu() 
		{
			MusicBeatState.switchState(new MasterEditorMenu());
		}
}
