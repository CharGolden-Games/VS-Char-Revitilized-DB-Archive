package states;

import flixel.addons.ui.U;
import backend.WeekData;
import backend.Highscore;
import backend.Song;
import backend.CreditsData;
import backend.FreeplayPortraitChar;

import objects.HealthIcon;
import objects.FreeplayBacker;
import objects.MusicPlayer;

import substates.GameplayChangersSubstate;
import substates.ResetScoreSubState;

import flixel.math.FlxMath;
import states.FreeplaySelectState;
import sys.FileSystem;
import backend.TracePassThrough as CustomTrace;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	private static var curSelected:Int = 0;
	var lerpSelected:Float = 0;
	var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = Difficulty.getDefault();

	var scoreBG:FlxSprite;
	var freeplayPortrait:FlxSprite;
	var curCharText:Alphabet;
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;
	var timesPressed:Int = 0;
	var fallenChairLmao:FlxSprite;
	var secretActivated:Bool = false;
	var playedSound:Bool = false;
	
	var creditsData:CreditsFile;
	var creditsSongName:String;
	var creditsSongArtist:String;
	var camHUD:FlxCamera;
	var camOther:FlxCamera;

	private var fplayBackerGroup:FlxTypedGroup<FreeplayBacker>;
	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	var bg:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;

	var missingTextBG:FlxSprite;
	var missingText:FlxText;

	var bottomString:String;
	var bottomText:FlxText;
	var bottomBG:FlxSprite;

	var player:MusicPlayer;
	public static var curCatStorage:Int = 0;
	var songTextBase:FlxSprite;

	override function create()
	{
		camHUD = new FlxCamera();
		camOther = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camOther, false);
		FlxG.cameras.add(camHUD, false);
		camHUD.zoom = 0.50;
		FlxG.cameras.setDefaultDrawTarget(camOther, true); //MAYBE HAVING MULTIPLE CAMERAS WILL WORK. I WANT THE FUNNY CHAIR EASTER EGG.
		

		CreditsData.isFreeplay = true;

		openfl.Lib.application.window.title = "Friday Night Funkin': VS Char Revitalized | Freeplay | ";

		//trace('curCatagory = ' + FreeplaySelectState.freeplayCats[FreeplaySelectState.curCategory].toLowerCase());
		if (FreeplaySelectState.freeplayCats[FreeplaySelectState.curCategory].toLowerCase() != 'mods')
			{
		curCatStorage = FreeplaySelectState.curCategory;
			} else {
				// because i don't want the mods thingie fucking up the shit lmao.
				curCatStorage = 5;
			}
			//trace('curCatStorage: ' + curCatStorage);
		//Paths.clearStoredMemory();
		//Paths.clearUnusedMemory();
		
		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		for (i in 0...WeekData.weeksList.length) {
			if(weekIsLocked(WeekData.weeksList[i])) continue;

			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];

			for (j in 0...leWeek.songs.length)
			{
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3)
				{
					colors = [146, 113, 253];
				}
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
			}
		}
		Mods.loadTopMod();

		bg = new FlxSprite().loadGraphic(MainMenuState.randomizeBG());
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);
		bg.screenCenter();

		// pre seperate class code
		/*
		songTextBase = new FlxSprite(500, 320).loadGraphic(Paths.image('freeplay/Freeplay_TextBase'));
		songTextBase.setGraphicSize(Std.int(songTextBase.width * 1.5), Std.int(songTextBase.height));
		songTextBase.updateHitbox();
		add(songTextBase);*/
		fplayBackerGroup = new FlxTypedGroup<FreeplayBacker>();
		add(fplayBackerGroup);
		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(570, 390, songs[i].songName, true);
			songText.targetY = i;
			grpSongs.add(songText);
			songText.scaleX = Math.min(0.5, 980 / songText.width);
			songText.scaleY = Math.min(0.5, 980 / songText.height);
			songText.snapToPosition();
			Mods.currentModDirectory = songs[i].folder;
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			var fplayBacker:FreeplayBacker = new FreeplayBacker(Paths.image('freeplay/Freeplay_TextBase'), Std.int(songText.width) + 20, Std.int(songText.height) + 20);
			icon.sprTracker = songText;
			fplayBacker.sprTracker = songText;

			// too laggy with a lot of songs, so i had to recode the logic for it
			songText.visible = songText.active = songText.isMenuItem = false;
			icon.visible = icon.active = false;
			fplayBacker.visible = icon.visible;

			// using a FlxGroup is too much fuss!
			fplayBackerGroup.add(fplayBacker);
			iconArray.push(icon);
			add(icon);
			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
		WeekData.setDirectoryFromWeek();

		scoreText = new FlxText(0, 100, 0, "", 32);
		scoreText.setFormat(Paths.font("funkin.otf"), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);

		scoreBG = new FlxSprite().loadGraphic(Paths.image('freeplay/Freeplay_SideBG'));
		add(scoreBG);

		freeplayPortrait = new FlxSprite().loadGraphic(Paths.image('freeplay/Freeplay_MissingPortrait'));
		freeplayPortrait.x = scoreBG.x;
		freeplayPortrait.y = FlxG.height - freeplayPortrait.height;
		freeplayPortrait.antialiasing = ClientPrefs.data.antialiasing;
		add(freeplayPortrait);

		curCharText = new Alphabet(freeplayPortrait.x, freeplayPortrait.y - 50, 'Player Character: "Unknown"');
		curCharText.setScale(0.25);
		add(curCharText);

		diffText = new FlxText(0, 10, 0, "", 100);
		diffText.setFormat(Paths.font("funkin.otf"), 100, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		add(diffText);

		add(scoreText);


		missingTextBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		missingTextBG.alpha = 0.6;
		missingTextBG.visible = false;
		add(missingTextBG);
		
		missingText = new FlxText(50, 0, FlxG.width - 100, '', 24);
		missingText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		missingText.scrollFactor.set();
		missingText.visible = false;
		add(missingText);

		if(curSelected >= songs.length) curSelected = 0;
		bg.color = songs[curSelected].color;
		intendedColor = bg.color;
		lerpSelected = curSelected;

		curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(lastDifficultyName)));

		bottomBG = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		bottomBG.alpha = 0.6;
		add(bottomBG);

		var leText:String = "Press SPACE to listen to the Song / Press CTRL to open the Gameplay Changers Menu / Press RESET to Reset your Score and Accuracy.";
		bottomString = leText;
		var size:Int = 16;
		bottomText = new FlxText(bottomBG.x, bottomBG.y + 4, FlxG.width, leText, size);
		bottomText.setFormat(Paths.font("funkin.otf"), size, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		bottomText.scrollFactor.set();
		add(bottomText);
		
		player = new MusicPlayer(this);
		add(player);
		
		changeSelection();
		updateTexts();
		super.create();
	}

	override function closeSubState() {
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color));
	}

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}

	var instPlaying:Int = -1;
	public static var vocals:FlxSound = null;
	var holdTime:Float = 0;
	var curSongFriendlyName:String;
	var delayTimer:FlxTimer = new FlxTimer();
	override function update(elapsed:Float)
	{
		if (player.playingMusic) {
			freeplayPortrait.visible = false;
			curCharText.visible = false;
		} else {
			freeplayPortrait.visible = true;
			curCharText.visible = true;
		}
		  //////////////////////////////// 
		 //Yummy Secret Chair thingie.///
		////////////////////////////////
		
		if (FlxG.keys.justPressed.C && !secretActivated) {
			timesPressed = timesPressed + 1;
			trace('timesPressed + 1, new value = ' + timesPressed);
		}
		if (timesPressed == 10 && !secretActivated) {
			trace('SECRET ACTIVATED');
			secretActivated = true;

			fallenChairLmao = new FlxSprite(FlxG.width * 0.1, FlxG.height - 2660).loadGraphic(Paths.image('freeplay/ChairLmao')); // so it can be recycled.
			fallenChairLmao.angle = -90;
			fallenChairLmao.camera = camHUD;
			fallenChairLmao.setGraphicSize(Std.int(fallenChairLmao.width * 0.5));
			fallenChairLmao.x = FlxG.random.int(-800, 800);
			add(fallenChairLmao);

			FlxTween.tween(fallenChairLmao, {y: 300}, 5, {ease: FlxEase.bounceOut, onComplete: function(twn:FlxTween){
				FlxG.sound.play(Paths.sound('perfect'));
				timesPressed = 0;
				secretActivated = false;
				fallenChairLmao.alpha = 0.7;
				fallenChairLmao.destroy();
		}});
			if (!delayTimer.active){
				delayTimer.start(1.5, function(tmr:FlxTimer){FlxG.sound.play(Paths.sound('metalPipe'));});
			}
		}
		// this too is now softcoded
		/*switch (songs[curSelected].songName.toLowerCase()) {
			default:
				curSongFriendlyName = U.FUL(songs[curSelected].songName) + ' | Not defined or is not from this mod!';
			case 'tutorial':
				curSongFriendlyName = "Tutorial Char's Mix | Anny (Char)";
			case 'high-ground':
				curSongFriendlyName = 'High Ground | ODDBLUE';
			case 'higher-ground':
				curSongFriendlyName = "High Ground Char's Mix | Anny (Char)";
			case 'triple-trouble':
				curSongFriendlyName = 'Triple Trouble (Char Cover V3) | MarStarBro';
			case 'defeat-odd-mix':
				curSongFriendlyName = 'Defeat ODDBLUE Mix | ODDBLUE';
			case 'defeat-char-mix':
				curSongFriendlyName = 'Defeat Char Mix (Defeat ODDBLUE Mix V1) | ODDBLUE';
			case 'pico2':
				curSongFriendlyName = 'Pico 2 | THE BEST PICO EVER | Relgaoh | Chart by Char | REQUIRES ORIGINAL SONG DOWNLOADED TO PLAY PROPERLY';
		}*/
		creditsData = CreditsData.getCreditsFile(songs[curSelected].songName); // moved from LUA AND made it modular 😎
		if (creditsData == null){
			creditsData = CreditsData.dummy(songs[curSelected].songName); // because it causes it to fucking die if i don't add this lmao.
		}
			creditsSongName = creditsData.songName;
			creditsSongArtist = creditsData.songArtist;
		if (songs[curSelected].songName.toLowerCase() == 'pico2') {
			curSongFriendlyName = creditsSongName.trim() + ' | ' + creditsSongArtist.trim() + ' | Chart by Char | REQUIRES ORIGINAL SONG DOWNLOADED TO PLAY PROPERLYY';
		} else {
		curSongFriendlyName = creditsSongName.trim() + ' | ' + creditsSongArtist.trim();
		}

		openfl.Lib.application.window.title = "Friday Night Funkin': VS Char Revitalized | Freeplay | " + curSongFriendlyName + ' | ' + U.FUL(Difficulty.getString(curDifficulty));
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		lerpScore = Math.floor(FlxMath.lerp(intendedScore, lerpScore, Math.exp(-elapsed * 24)));
		lerpRating = FlxMath.lerp(intendedRating, lerpRating, Math.exp(-elapsed * 12));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(CoolUtil.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

		if (!player.playingMusic)
		{
			scoreText.text = 'PERSONAL BEST: ' + lerpScore + ' (' + ratingSplit.join('.') + '%)';
			positionHighscore();
			
			if(songs.length > 1)
			{
				if(FlxG.keys.justPressed.HOME)
				{
					curSelected = 0;
					changeSelection();
					holdTime = 0;	
				}
				else if(FlxG.keys.justPressed.END)
				{
					curSelected = songs.length - 1;
					changeSelection();
					holdTime = 0;	
				}
				if (controls.UI_UP_P)
				{
					changeSelection(-shiftMult);
					holdTime = 0;
				}
				if (controls.UI_DOWN_P)
				{
					changeSelection(shiftMult);
					holdTime = 0;
				}

				if(controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
				}

				if(FlxG.mouse.wheel != 0)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
					changeSelection(-shiftMult * FlxG.mouse.wheel, false);
				}
			}

			if (controls.UI_LEFT_P)
			{
				changeDiff(-1);
				_updateSongLastDifficulty();
			}
			else if (controls.UI_RIGHT_P)
			{
				changeDiff(1);
				_updateSongLastDifficulty();
			}
		}

		if (controls.BACK)
		{
			if (player.playingMusic)
			{
				FlxG.sound.music.stop();
				destroyFreeplayVocals();
				FlxG.sound.music.volume = 0;
				instPlaying = -1;

				player.playingMusic = false;
				player.switchPlayMusic();

				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
				FlxTween.tween(FlxG.sound.music, {volume: 1}, 1);
			}
			else 
			{
				persistentUpdate = false;
				if(colorTween != null) {
					colorTween.cancel();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new FreeplaySelectState());
			}
		}

		if(FlxG.keys.justPressed.CONTROL && !player.playingMusic)
		{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		else if(FlxG.keys.justPressed.SPACE)
		{
			var hasError:Bool = false;
			if(instPlaying != curSelected && !player.playingMusic)
			{
				destroyFreeplayVocals();
				FlxG.sound.music.volume = 0;

				try {
				Mods.currentModDirectory = songs[curSelected].folder;
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
				} catch(e:Dynamic)
			{
				trace('ERROR! $e');

				var errorStr:String = e.toString();
				if(errorStr.startsWith('[file_contents,assets/data/')) errorStr = 'Missing file: ' + errorStr.substring(34, errorStr.length-1); //Missing chart
				missingText.text = 'ERROR WHILE LOADING CHART:\n$errorStr';
				missingText.screenCenter(Y);
				missingText.visible = true;
				missingTextBG.visible = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));

				updateTexts(elapsed);
				super.update(elapsed);
				hasError = true;
				return;
			}
				if (PlayState.SONG.needsVoices && !hasError)
				{
					vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
					FlxG.sound.list.add(vocals);
					vocals.persist = true;
					vocals.looped = true;
				}
				else if (vocals != null && !hasError)
				{
					vocals.stop();
					vocals.destroy();
					vocals = null;
				}
				
				if (!hasError) FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.8);
				if(vocals != null && !hasError) //Sync vocals to Inst
				{
					vocals.play();
					vocals.volume = 0.8;
				}
				instPlaying = curSelected;

				player.playingMusic = true;
				player.curTime = 0;
				player.switchPlayMusic();
			}
			else if (instPlaying == curSelected && player.playingMusic && !hasError)
			{
				player.pauseOrResume(player.paused);
			}
		}
		else if (controls.ACCEPT && !player.playingMusic)
		{
			persistentUpdate = false;
			var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
			var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
			/*#if MODS_ALLOWED
			if(!FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
			#else
			if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
			#end
				poop = songLowercase;
				curDifficulty = 1;
				trace('Couldnt find file');
			}*/
			trace(poop);

			try
			{
				PlayState.SONG = Song.loadFromJson(poop, songLowercase);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;

				trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
				if(colorTween != null) {
					colorTween.cancel();
				}
			}
			catch(e:Dynamic)
			{
				trace('ERROR! $e');

				var errorStr:String = e.toString();
				if(errorStr.startsWith('[file_contents,assets/data/')) errorStr = 'Missing file: ' + errorStr.substring(34, errorStr.length-1); //Missing chart
				missingText.text = 'ERROR WHILE LOADING CHART:\n$errorStr';
				missingText.screenCenter(Y);
				missingText.visible = true;
				missingTextBG.visible = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));

				updateTexts(elapsed);
				super.update(elapsed);
				return;
			}
			LoadingState.loadAndSwitchState(new PlayState());

			FlxG.sound.music.volume = 0;
					
			destroyFreeplayVocals();
			#if (MODS_ALLOWED && DISCORD_ALLOWED)
			DiscordClient.loadModRPC();
			#end
		}
		else if(controls.RESET && !player.playingMusic)
		{
			persistentUpdate = false;
			openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}

		updateTexts(elapsed);
		super.update(elapsed);
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	function changeDiff(change:Int = 0)
	{
		if (player.playingMusic)
			return;

		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = Difficulty.list.length-1;
		if (curDifficulty >= Difficulty.list.length)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		lastDifficultyName = Difficulty.getString(curDifficulty);
		if (Difficulty.list.length > 1)
			diffText.text = '< ' + lastDifficultyName.toUpperCase();
		else
			diffText.text = '< ' + lastDifficultyName.toUpperCase();

		positionHighscore();
		missingText.visible = false;
		missingTextBG.visible = false;
	}

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if (player.playingMusic)
			return;

		_updateSongLastDifficulty();
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		var lastList:Array<String> = Difficulty.list;
		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;
			
		var newColor:Int = songs[curSelected].color;
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			bullShit++;
			item.alpha = 0.6;
			if (item.targetY == curSelected)
				item.alpha = 1;
		}
		
		Mods.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;
		Difficulty.loadFromWeek();
		
		var savedDiff:String = songs[curSelected].lastDifficulty;
		var lastDiff:Int = Difficulty.list.indexOf(lastDifficultyName);
		if(savedDiff != null && !lastList.contains(savedDiff) && Difficulty.list.contains(savedDiff))
			curDifficulty = Math.round(Math.max(0, Difficulty.list.indexOf(savedDiff)));
		else if(lastDiff > -1)
			curDifficulty = lastDiff;
		else if(Difficulty.list.contains(Difficulty.getDefault()))
			curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(Difficulty.getDefault())));
		else
			curDifficulty = 0;

		changeDiff();
		_updateSongLastDifficulty();

		
		

		freeplayPortrait.destroy();

		var char:FreeplayPortrait = FreeplayPortraitChar.returnChar(songs[curSelected].songName);
		var path:String = './assets/images/freeplay/portraits/Freeplay_' + char.char +'Portrait.png';
		var path2:String = './assets/images/freeplay/portraits/Freeplay_' + char.char +'.png'; //in case you forget the Portrait part.
		var curChar:String = '';

		if (!FileSystem.exists(path) && !FileSystem.exists(path2)) {
			//CustomTrace.trace('NEITHER "' + path + '" NOR "' + path2 + '" FOUND.', 'fatal');
			curChar = 'MissingPortrait'; 
		}
		else {
			if (FileSystem.exists(path)) {
				//CustomTrace.trace('"' + path + '" Was found.', 'info');
				curChar = char.char + 'Portrait';
			} else if (FileSystem.exists(path2)) {
				//CustomTrace.trace('"' + path2 + '" Was found.', 'info');
				curChar = char.char;
			}
		}

		freeplayPortrait = new FlxSprite().loadGraphic(Paths.image('freeplay/portraits/Freeplay_' + curChar));
		freeplayPortrait.x = scoreBG.x;
		freeplayPortrait.y = FlxG.height - freeplayPortrait.height;
		freeplayPortrait.antialiasing = ClientPrefs.data.antialiasing;
		add(freeplayPortrait);
		if (freeplayPortrait.width > 332) {
			freeplayPortrait.setGraphicSize(332);
			freeplayPortrait.updateHitbox();
			freeplayPortrait.x = scoreBG.x;
			freeplayPortrait.y = FlxG.height - freeplayPortrait.height;
		}

		curCharText.destroy();
		curCharText = new Alphabet(freeplayPortrait.x + 25, freeplayPortrait.y - 50, 'Player Character: "' + char.playerName + '"');
		curCharText.setScale(0.25);
		add(curCharText);
		// so that ^ doesn't render above the following lmao.
		bottomBG.destroy();
		bottomBG = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		bottomBG.alpha = 0.6;
		add(bottomBG);

		bottomText.destroy();
		var leText:String = "Press SPACE to listen to the Song / Press CTRL to open the Gameplay Changers Menu / Press RESET to Reset your Score and Accuracy.";
		bottomString = leText;
		var size:Int = 16;
		bottomText = new FlxText(bottomBG.x, bottomBG.y + 4, FlxG.width, leText, size);
		bottomText.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		bottomText.scrollFactor.set();
		add(bottomText);

		missingTextBG.destroy();
		missingTextBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		missingTextBG.alpha = 0.6;
		missingTextBG.visible = false;
		add(missingTextBG);
		
		missingText.destroy();
		missingText = new FlxText(50, 0, FlxG.width - 100, '', 24);
		missingText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		missingText.scrollFactor.set();
		missingText.visible = false;
		add(missingText);
	}

	inline private function _updateSongLastDifficulty()
	{
		songs[curSelected].lastDifficulty = Difficulty.getString(curDifficulty);
	}

	private function positionHighscore() {
		scoreText.x = scoreBG.x + 20;
		diffText.x = scoreBG.x;
	}

	var _drawDistance:Int = 4;
	var _lastVisibles:Array<Int> = [];
	public function updateTexts(elapsed:Float = 0.0)
	{
		lerpSelected = FlxMath.lerp(curSelected, lerpSelected, Math.exp(-elapsed * 9.6));
		for (i in _lastVisibles)
		{
			grpSongs.members[i].visible = grpSongs.members[i].active = false;
			iconArray[i].visible = iconArray[i].active = false;
			fplayBackerGroup.members[i].visible = iconArray[i].visible;
		}
		_lastVisibles = [];

		var min:Int = Math.round(Math.max(0, Math.min(songs.length, lerpSelected - _drawDistance)));
		var max:Int = Math.round(Math.max(0, Math.min(songs.length, lerpSelected + _drawDistance)));
		for (i in min...max)
		{
			var item:Alphabet = grpSongs.members[i];
			item.visible = item.active = true;
			item.x = ((item.targetY - lerpSelected) * item.distancePerItem.x) + item.startPosition.x;
			item.y = ((item.targetY - lerpSelected) * 1.3 * item.distancePerItem.y) + item.startPosition.y;

			var icon:HealthIcon = iconArray[i];
			icon.visible = icon.active = true;

			var fplayBacker:FreeplayBacker = fplayBackerGroup.members[i];
			fplayBacker.visible = icon.visible;
			_lastVisibles.push(i);
		}
	}

	override function destroy():Void
	{
		super.destroy();

		FlxG.autoPause = ClientPrefs.data.autoPause;
		if (!FlxG.sound.music.playing)
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
	}	
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";
	public var lastDifficulty:String = null;

	public function new(song:String, week:Int, songCharacter:String, color:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Mods.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}