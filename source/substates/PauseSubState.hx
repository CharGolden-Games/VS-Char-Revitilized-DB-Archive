package substates;

import backend.WeekData;
import backend.Highscore;
import backend.Song;

import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.U;
import flixel.graphics.FlxGraphic;

import flixel.util.FlxStringUtil;

import states.StoryMenuState;
import states.FreeplayState;
import options.OptionsState;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = [];
	var menuItemsOG:Array<String> = ['Resume', 'Restart Song', 'Change Difficulty', 'Options', 'Gameplay Modifiers', 'Toggle Botplay', 'Exit to menu'];
	var newMenuItems:Array<String> = ['Resume', 'Restart Song', 'Toggle Botplay', 'Exit to menu'];
	var difficultyChoices = [];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	var practiceText:FlxText;
	var skipTimeText:FlxText;
	var skipTimeTracker:Alphabet;
	var curTime:Float = Math.max(0, Conductor.songPosition);

	var missingTextBG:FlxSprite;
	var missingText:FlxText;
	var pauseCredit:String;
	var missTxt:FlxText;
	var blueballedTxt:FlxText;
	var levelInfo:FlxText;
	var pauseBG:FlxSprite;
	var resumeButton:FlxSprite;
	var restartButton:FlxSprite;
	var botplayButton:FlxSprite;
	var exitButton:FlxSprite;
	var freeplayImage:FlxSprite;

	public static var songName:String = '';

	public function new(x:Float, y:Float)
	{
		Paths.image('pauseMenu/pauseMenuAssets');
		Paths.image('pauseMenu/songImages/imageMissingPause');

		var num:Int = 0;
			if(!PlayState.instance.startingSong)
			{
				num = 1;
				menuItemsOG.insert(3, 'Skip Time');
				if(PlayState.isStoryMode)
					{
						if (!PlayState.chartingMode){
					menuItemsOG.insert(3 + num, 'Skip Song');
						}	
					}
			}

			
		super();
		if(Difficulty.list.length < 2) menuItemsOG.remove('Change Difficulty'); //No need to change difficulty if there is only one!

		if(PlayState.chartingMode)
		{
			menuItemsOG.insert(2, 		'Leave Charting Mode');
			menuItemsOG.insert(4 + num, 'Toggle Practice Mode');
			menuItemsOG.insert(5 + num, 'Exit to Charter');
		}
		menuItems = menuItemsOG;

		for (i in 0...Difficulty.list.length) {
			var diff:String = Difficulty.getString(i);
			difficultyChoices.push(diff);
		}
		difficultyChoices.push('BACK');


		pauseMusic = new FlxSound();
		if(songName != null && !PlayState.isPixelStage) {
			pauseMusic.loadEmbedded(Paths.music(songName), true, true);
		} else if (songName != 'None' && !PlayState.isPixelStage) {
			pauseMusic.loadEmbedded(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)), true, true);
		} else if(songName != null && PlayState.isPixelStage) {
			pauseMusic.loadEmbedded(Paths.music(songName + '8bit'), true, true);
		} else if (songName != 'None' && PlayState.isPixelStage) {
			pauseMusic.loadEmbedded(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic + '8bit')), true, true);
		}
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);
		
		//trace('spawning menu');
		//spawnNewMenu();
		//menuSpawned = true;

		var songCredit:String;
		/*switch (PlayState.SONG.song.toLowerCase())
		{
			// Setup like this to mimic the 3.0 release of base game's song credits
			// TODO: make this shit softcoded
			default:
				songCredit = PlayState.SONG.song + ' - Not Provided';
			case 'triple-trouble':
				songCredit = 'Triple Trouble - MarStarBro';
			case 'high-ground':
				songCredit = 'High Ground - ODDBLUE';
			case 'higher-ground':
				songCredit = "High Ground Char's Mix - Anny (Char)";
			case 'pico2':
				songCredit = 'BEST PICO EVER, PICO 2 - Relgaoh';
			case 'defeat-char-mix':
				songCredit = "Defeat Char Mix - ODDBLUE";
			case 'defeat-odd-mix':
				songCredit = "Defeat ODDBLUE Mix - ODDBLUE";
			case 'tutorial':
				songCredit = 'Tutorial - Kawai Sprite'; // "Tutorial Char's Mix - Anny (Char)"; // not until i finish it lol
		}*/
		// made this shit softcoded lmao
		if (PlayState.creditsData == null) {
			songCredit = U.FUL(PlayState.SONG.song) + ' - Not Provided';
		} else {
		songCredit = PlayState.creditsSongName.trim() + ' - ' + PlayState.creditsSongArtist.trim();
		}

		levelInfo = new FlxText(20, 15, 0, songCredit, 32);
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		
		switch (ClientPrefs.data.pauseMusic.toLowerCase())
		{
			default:
				pauseCredit = 'Dunno This One | Probably your mom :smug:';
			case 'none':
				pauseCredit = 'Silence | But who made silence?';
			case 'shop':
				pauseCredit = "Shop - Nico's Nextbots Remix | WHYEthan (Formerly ODDBLUE)";
			case 'breakfast':
				pauseCredit = "Breakfast | Kawai Sprite";
			case 'tea time':
				pauseCredit = "Tea Time | iFlicky";
		}
		if (PlayState.isPixelStage) {
			if (ClientPrefs.data.pauseMusic.toLowerCase() == 'breakfast')
				{
					pauseCredit = "Breakfast | Kawai Sprite | BitCrush Edit by me\nNo, i wouldn't steal the new weekend1 update week6 pause music";
				}
		}
	
	
		var creditTxt:FlxText = new FlxText(20, FlxG.height - 32, 0, "Pause Music: " + pauseCredit, 16);
		creditTxt.scrollFactor.set();
		if (PlayState.isPixelStage) creditTxt.y = FlxG.height - 44;
		creditTxt.setFormat(Paths.font('vcr.ttf'), 16);
		creditTxt.updateHitbox();
		add(creditTxt);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, Difficulty.getString().toUpperCase(), 32);
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		if (PlayState.deathCounter < 5)
			{
		blueballedTxt = new FlxText(20, 15 + 64, 0, "Died " + PlayState.deathCounter + " times", 32);
			} else if (PlayState.deathCounter >= 5)
			{
		blueballedTxt = new FlxText(20, 15 + 64, 0, "Died " + PlayState.deathCounter + " times LMAO LOSER", 32);
			}
		blueballedTxt.scrollFactor.set();
		blueballedTxt.setFormat(Paths.font('vcr.ttf'), 32);
		blueballedTxt.updateHitbox();
		add(blueballedTxt);

		if (PlayState.isStoryMode) {
			if (PlayState.campaignMisses < 20) {
		missTxt = new FlxText(20, 15 + 96, 0, "Week Misses: " + PlayState.campaignMisses, 32);
		} else if (PlayState.campaignMisses >= 20) {
		missTxt = new FlxText(20, 15 + 96, 0, "Week Misses: " + PlayState.campaignMisses + "\n i know where you live...", 32);
			}
		missTxt.scrollFactor.set();
		missTxt.setFormat(Paths.font('vcr.ttf'), 32);
		missTxt.updateHitbox();
		add(missTxt);
		}

		practiceText = new FlxText(20, 15 + 101, 0, "What? the song too hard for ya?", 32);
		practiceText.scrollFactor.set();
		practiceText.setFormat(Paths.font('vcr.ttf'), 32);
		practiceText.x = FlxG.width - (practiceText.width + 20);
		practiceText.updateHitbox();
		practiceText.visible = PlayState.instance.practiceMode;
		add(practiceText);

		var chartingText:FlxText = new FlxText(20, 15 + 101, 0, "user opened the charter\nRATTLE EM' BOYS", 32);
		chartingText.scrollFactor.set();
		chartingText.setFormat(Paths.font('vcr.ttf'), 32);
		chartingText.x = FlxG.width - (chartingText.width + 20);
		chartingText.y = FlxG.height - (chartingText.height + 20);
		chartingText.updateHitbox();
		chartingText.visible = PlayState.chartingMode;
		add(chartingText);

		blueballedTxt.alpha = 0;
		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;
		if (PlayState.isStoryMode) {
		missTxt.alpha = 0;
		}
		creditTxt.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		blueballedTxt.x = FlxG.width - (blueballedTxt.width + 20);
		if (PlayState.isStoryMode) {
		missTxt.x = FlxG.width - (missTxt.width + 20);
		}
		creditTxt.x = FlxG.width - (creditTxt.width + 20);


		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(blueballedTxt, {alpha: 1, y: blueballedTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});
		if (PlayState.isStoryMode) {
		FlxTween.tween(missTxt, {alpha: 1, y: missTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});
		}
		FlxTween.tween(creditTxt, {alpha: 1, y: creditTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		missingTextBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		missingTextBG.alpha = 0.6;
		missingTextBG.visible = false;
		add(missingTextBG);
		
		missingText = new FlxText(50, 0, FlxG.width - 100, '', 24);
		missingText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		missingText.scrollFactor.set();
		missingText.visible = false;
		add(missingText);

		regenMenu();
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	var holdTime:Float = 0;
	var cantUnpause:Float = 0.1;
	var menuSpawned:Bool = false;
	override function update(elapsed:Float)
	{
		cantUnpause -= elapsed;
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;
		
		if (menuSpawned) {
			if (resumeButton != null) {
				if (menuItems[curSelected] == 'Resume') {
					resumeButton.animation.play('hover');
				} else {
					resumeButton.animation.play('idle');
				}
			}

			if (restartButton != null) {
				if (menuItems[curSelected] == 'Restart Song') {
					restartButton.animation.play('hover');
				} else {
					restartButton.animation.play('idle');
				}
			}

			if (botplayButton != null) {
				if (menuItems[curSelected] == 'Toggle Botplay') {
					botplayButton.animation.play('hover');
				} else {
					botplayButton.animation.play('idle');
				}
			}

			if (exitButton != null) {
				if (menuItems[curSelected] == 'Exit to menu') {
					exitButton.animation.play('hover');
				} else {
					exitButton.animation.play('idle');
				}
			}
			if (resumeButton != null && restartButton != null && botplayButton != null && exitButton != null) {
				//resumeButton.updateHitbox();
				//restartButton.updateHitbox();
				//botplayButton.updateHitbox();
				//exitButton.updateHitbox();
				var offsetX = resumeButton.animation.curAnim.name == 'hover' ? 20 : 0;
				var offsetY = resumeButton.animation.curAnim.name == 'hover' ? 20 : 0;

				resumeButton.x = 20 - offsetX;

				restartButton.x = 20 - offsetX;
				exitButton.x = 20 - offsetX;

				resumeButton.y = 20 - offsetY;
				restartButton.y = (resumeButton.y + resumeButton.height) + (20 - offsetY);
				botplayButton.y = restartButton.y;
				exitButton.y = (botplayButton.y + resumeButton.height) + (20 - offsetY);

				botplayButton.x = restartButton.width + (20 - offsetX);
			}
		}

		super.update(elapsed);
		updateSkipTextStuff();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		var daSelected:String = menuItems[curSelected];
		switch (daSelected)
		{
			case 'Skip Time':
				if (controls.UI_LEFT_P)
				{
					if (PlayState.isPixelStage) {
						FlxG.sound.play(Paths.sound('scrollMenu8Bit'), 0.4);
					} else {
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
					}
					curTime -= 1000;
					holdTime = 0;
				}
				if (controls.UI_RIGHT_P)
				{
					if (PlayState.isPixelStage) {
						FlxG.sound.play(Paths.sound('scrollMenu8Bit'), 0.4);
					} else {
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
					}
					curTime += 1000;
					holdTime = 0;
				}

				if(controls.UI_LEFT || controls.UI_RIGHT)
				{
					holdTime += elapsed;
					if(holdTime > 0.5)
					{
						curTime += 45000 * elapsed * (controls.UI_LEFT ? -1 : 1);
					}

					if(curTime >= FlxG.sound.music.length) curTime -= FlxG.sound.music.length;
					else if(curTime < 0) curTime += FlxG.sound.music.length;
					updateSkipTimeText();
				}
		}

		if (accepted && (cantUnpause <= 0 || !controls.controllerMode))
		{
			if (menuItems == difficultyChoices)
			{
				try{
					if(menuItems.length - 1 != curSelected && difficultyChoices.contains(daSelected)) {

						var name:String = PlayState.SONG.song;
						var poop = Highscore.formatSong(name, curSelected);
						PlayState.SONG = Song.loadFromJson(poop, name);
						PlayState.storyDifficulty = curSelected;
						MusicBeatState.resetState();
						FlxG.sound.music.volume = 0;
						PlayState.changedDifficulty = true;
						PlayState.chartingMode = false;
						return;
					}					
				}catch(e:Dynamic){
					trace('ERROR! $e');

					var errorStr:String = e.toString();
					if(errorStr.startsWith('[file_contents,assets/data/')) errorStr = 'Missing file: ' + errorStr.substring(27, errorStr.length-1); //Missing chart
					missingText.text = 'ERROR WHILE LOADING CHART:\n$errorStr';
					missingText.screenCenter(Y);
					missingText.visible = true;
					missingTextBG.visible = true;
					FlxG.sound.play(Paths.sound('cancelMenu'));

					super.update(elapsed);
					return;
				}


				menuItems = menuItemsOG;
				regenMenu();
			}

			switch (daSelected)
			{
				case "Exit to Charter":
					PlayState.instance.notes.clear();
					PlayState.instance.unspawnNotes = [];
					PlayState.instance.finishSong(true);
				case "Resume":
					close();
				case 'Change Difficulty':
					menuItems = difficultyChoices;
					deleteSkipTimeText();
					regenMenu();
				case 'Toggle Practice Mode':
					PlayState.instance.practiceMode = !PlayState.instance.practiceMode;
					PlayState.changedDifficulty = true;
					practiceText.visible = PlayState.instance.practiceMode;
				case 'Gameplay Modifiers':
					close();
					PlayState.instance.openChangersMenu();
					GameplayChangersSubstate.onPlayState = true;
				case "Restart Song":
					restartSong();
				case "Leave Charting Mode":
					restartSong();
					PlayState.chartingMode = false;
				case 'Skip Time':
					if(curTime < Conductor.songPosition)
					{
						PlayState.startOnTime = curTime;
						restartSong(true);
					}
					else
					{
						if (curTime != Conductor.songPosition)
						{
							PlayState.instance.clearNotesBefore(curTime);
							PlayState.instance.setSongTime(curTime);
						}
						close();
					}
				case 'Skip Song':
					close();
					PlayState.instance.notes.clear();
					PlayState.instance.unspawnNotes = [];
					PlayState.instance.finishSong(true);
				case 'Toggle Botplay':
					PlayState.instance.cpuControlled = !PlayState.instance.cpuControlled;
					PlayState.changedDifficulty = true;
					PlayState.instance.botplayTxt.visible = PlayState.instance.cpuControlled;
					PlayState.instance.botplayTxt.alpha = 1;
					PlayState.instance.botplaySine = 0;
				case 'Options':
					PlayState.instance.paused = true; // For lua
					PlayState.instance.vocals.volume = 0;
					OptionsState.onPlayState = true;
					MusicBeatState.switchState(new OptionsState());
					if(ClientPrefs.data.pauseMusic != 'None')
					{
						FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)), pauseMusic.volume);
						FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.8);
						FlxG.sound.music.time = pauseMusic.time;
					}
				case "Exit to menu":
					#if desktop DiscordClient.resetClientID(); #end
					PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;

					Mods.loadTopMod();
					if(PlayState.isStoryMode) {
						MusicBeatState.switchState(new StoryMenuState());
					} else {
						MusicBeatState.switchState(new FreeplayState());
					}
					PlayState.cancelMusicFadeTween();
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
					PlayState.changedDifficulty = false;
					PlayState.chartingMode = false;
					FlxG.camera.followLerp = 0;
			}
		}
	}

		function spawnNewMenu() {
			if (!menuSpawned) {
				var image:String = 'pauseMenu/pauseMenuAssets';
				var sourceImg:FlxGraphic = Paths.image(image);

				pauseBG = new FlxSprite().loadGraphic(sourceImg);
				resumeButton = new FlxSprite().loadGraphic(sourceImg);
				restartButton = new FlxSprite().loadGraphic(sourceImg);
				botplayButton = new FlxSprite().loadGraphic(sourceImg);
				exitButton = new FlxSprite().loadGraphic(sourceImg);

				sourceImg = Paths.image('pauseMenu/songImages/imageMissingPause');
				
				freeplayImage = new FlxSprite().loadGraphic(sourceImg);
				freeplayImage.setGraphicSize(256);
				freeplayImage.antialiasing = ClientPrefs.data.antialiasing;

				pauseBG.frames = Paths.getSparrowAtlas(image);
				resumeButton.frames = Paths.getSparrowAtlas(image);
				restartButton.frames = Paths.getSparrowAtlas(image);
				botplayButton.frames = Paths.getSparrowAtlas(image);
				exitButton.frames = Paths.getSparrowAtlas(image);

				pauseBG.animation.addByPrefix('anim', 'PauseMenuBG', 24);

				resumeButton.animation.addByPrefix('idle', 'Resume Idle');
				restartButton.animation.addByPrefix('idle', 'Restart Small Idle');
				botplayButton.animation.addByPrefix('idle', 'Botplay Idle');
				exitButton.animation.addByPrefix('idle', 'Exit Idle');

				resumeButton.animation.addByPrefix('hover', 'Resume Hover');
				restartButton.animation.addByPrefix('hover', 'Restart Small Hover');
				botplayButton.animation.addByPrefix('hover', 'Botplay Hover');
				exitButton.animation.addByPrefix('hover', 'Exit Hover');

				pauseBG.animation.play('anim');
				resumeButton.animation.play('idle');
				restartButton.animation.play('idle');
				botplayButton.animation.play('idle');
				exitButton.animation.play('idle');

				resumeButton.updateHitbox();
				restartButton.updateHitbox();
				botplayButton.updateHitbox();
				exitButton.updateHitbox();

				resumeButton.y = 20;
				restartButton.y = resumeButton.y + resumeButton.height + 20;
				botplayButton.y = restartButton.y;
				exitButton.y = botplayButton.y + resumeButton.height + 20;

				botplayButton.x = resumeButton.width + 20;

				add(freeplayImage);
				add(pauseBG);
				add(resumeButton);
				add(restartButton);
				add(botplayButton);
				add(exitButton);
			} else {
				trace('Already spawned the new menu!');
			}
		}

	function deleteSkipTimeText()
	{
		if(skipTimeText != null)
		{
			skipTimeText.kill();
			remove(skipTimeText);
			skipTimeText.destroy();
		}
		skipTimeText = null;
		skipTimeTracker = null;
	}

	public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if(noTrans)
		{
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
		}
		MusicBeatState.resetState();
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (PlayState.isPixelStage) {
			FlxG.sound.play(Paths.sound('scrollMenu8Bit'), 0.4);
		} else {
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));

				if(item == skipTimeTracker)
				{
					curTime = Math.max(0, Conductor.songPosition);
					updateSkipTimeText();
				}
			}
		}
		missingText.visible = false;
		missingTextBG.visible = false;
	}

	function regenMenu():Void {
		for (i in 0...grpMenuShit.members.length) {
			var obj = grpMenuShit.members[0];
			obj.kill();
			grpMenuShit.remove(obj, true);
			obj.destroy();
		}

		for (i in 0...menuItems.length) {
			var item = new Alphabet(90, 320, menuItems[i], true);
			item.isMenuItem = true;
			item.targetY = i;
			grpMenuShit.add(item);

			if(menuItems[i] == 'Skip Time')
			{
				skipTimeText = new FlxText(0, 0, 0, '', 64);
				skipTimeText.setFormat(Paths.font("vcr.ttf"), 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				skipTimeText.scrollFactor.set();
				skipTimeText.borderSize = 2;
				skipTimeTracker = item;
				add(skipTimeText);

				updateSkipTextStuff();
				updateSkipTimeText();
			}
		}
		curSelected = 0;
		changeSelection();
	}
	
	function updateSkipTextStuff()
	{
		if(skipTimeText == null || skipTimeTracker == null) return;

		skipTimeText.x = skipTimeTracker.x + skipTimeTracker.width + 60;
		skipTimeText.y = skipTimeTracker.y;
		skipTimeText.visible = (skipTimeTracker.alpha >= 1);
	}

	function updateSkipTimeText()
	{
		skipTimeText.text = FlxStringUtil.formatTime(Math.max(0, Math.floor(curTime / 1000)), false) + ' / ' + FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / 1000)), false);
	}
}
