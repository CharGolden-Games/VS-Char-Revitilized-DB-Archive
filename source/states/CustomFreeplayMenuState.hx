package states;

import backend.WeekData;
import backend.Highscore;
import backend.ReferenceStrings;
import backend.Song;

import objects.HealthIcon;
import objects.MusicPlayer;
import objects.HealthBar;

import substates.GameplayChangersSubstate;
import substates.ResetScoreSubState;

import states.MainMenuState;

import flixel.math.FlxMath;
import flixel.addons.ui.U as FlxU;
import flixel.graphics.FlxGraphic;
import flixel.addons.transition.FlxTransitionableState;

import sys.FileSystem;

class CustomFreeplayMenuState extends MusicBeatState
{
    // Generic Lists
    var catList:Array<String> = [
        'story',
        'covers',
        'extra',
        'collabs',
        'legacy'
    ];
    var catImage:FlxSprite;
    var catText:Alphabet;
    var curSelection:Int = 0;
    var catImgPath:String = 'assets/images/catagory';
    var unlockedSecretCat:Bool = false;
    var freelpayArrowLeft:FlxSprite;
    var freelpayArrowRoight:FlxSprite;
    var scaledWidth:Int;
    var scaledHeight:Int;
    var baseHeight:Int;
    var baseWidth:Int;
    var camMain:FlxCamera;

    override function create() {
        camMain = new FlxCamera();
        FlxG.cameras.add(camMain, false);
        FlxG.cameras.setDefaultDrawTarget(camMain, true);
        var BG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBG/Desat'));
        BG.color = 0x8663E4;
        BG.antialiasing = ClientPrefs.data.antialiasing;
        add(BG);
        var abberationBGBlue:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBG/DesatLines'));
        abberationBGBlue.color = 0x0000FF;
        abberationBGBlue.x = BG.x - 2;
        abberationBGBlue.y = BG.y - 2;
        abberationBGBlue.antialiasing = ClientPrefs.data.antialiasing;
        abberationBGBlue.alpha = 0.25;
        add(abberationBGBlue);
        var abberationBGRed:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBG/DesatLines'));
        abberationBGRed.color = 0xFF0000;
        abberationBGRed.x = BG.x + 2;
        abberationBGRed.y = BG.y + 2;
        abberationBGRed.antialiasing = ClientPrefs.data.antialiasing;
        abberationBGRed.alpha = 0.25;
        add(abberationBGRed);
        catImage = new FlxSprite().loadGraphic(Paths.image('catagory/catagory-missing'));
        catImage.screenCenter();
        catImage.antialiasing = ClientPrefs.data.antialiasing;
        add(catImage);
        catText = new Alphabet(catImage.x, catImage.y + 20, "Placeholder", true);
        add(catText);
        freelpayArrowLeft = new FlxSprite().loadGraphic(Paths.image('freeplay/Freeplay_DiffArrow'));
        freelpayArrowLeft.screenCenter();
        freelpayArrowLeft.x = FlxG.width * 0.25;
        freelpayArrowLeft.antialiasing = ClientPrefs.data.antialiasing;
        freelpayArrowLeft.flipX = true;
        add(freelpayArrowLeft);
        freelpayArrowRoight = new FlxSprite().loadGraphic(Paths.image('freeplay/Freeplay_DiffArrow'));
        freelpayArrowRoight.screenCenter();
        freelpayArrowRoight.x = FlxG.width * 0.7;
        freelpayArrowRoight.antialiasing = ClientPrefs.data.antialiasing;
        add(freelpayArrowRoight);
        if (unlockedSecretCat) catList.push('secret');
        changeSelection();
        super.create();
        baseHeight = Std.int(freelpayArrowRoight.height);
        baseWidth = Std.int(freelpayArrowRoight.width);
        scaledWidth = Std.int(Math.round(freelpayArrowRoight.width * 1.25));
        scaledHeight = Std.int(Math.round(freelpayArrowRoight.height * 1.25));
    }

    override function update(elapsed:Float) {
        if (controls.UI_RIGHT_P) {
            FlxG.sound.play(Paths.sound('scrollMenu'));
            changeSelection(1);
        }
        if (controls.UI_LEFT_P) {
            FlxG.sound.play(Paths.sound('scrollMenu'));
            changeSelection(-1);
        }
        if (controls.BACK) {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new MainMenuState());
        }
        if (controls.ACCEPT) {
            var ogZoom = camMain.zoom;
            FlxTween.tween(camMain, {zoom: 2}, 1, {ease: FlxEase.elasticInOut, onComplete: function(twn:FlxTween){
                MusicBeatState.switchState(new SongMenuState(catList[curSelection]));
                //camMain.zoom = ogZoom;
            }});
        }
        if (controls.UI_LEFT) {
            freelpayArrowLeft.loadGraphic(Paths.image('freeplay/Freeplay_DiffArrow2'));
            freelpayArrowLeft.setGraphicSize(scaledWidth);
            freelpayArrowLeft.updateHitbox();
        }
        if (controls.UI_LEFT_R) {
            freelpayArrowLeft.loadGraphic(Paths.image('freeplay/Freeplay_DiffArrow'));
            freelpayArrowLeft.setGraphicSize(baseWidth);
            freelpayArrowLeft.updateHitbox();
        }
        if (controls.UI_RIGHT) {
            freelpayArrowRoight.loadGraphic(Paths.image('freeplay/Freeplay_DiffArrow2'));
            freelpayArrowRoight.setGraphicSize(scaledWidth);
            freelpayArrowRoight.updateHitbox();
        }
        if (controls.UI_RIGHT_R) {
            freelpayArrowRoight.loadGraphic(Paths.image('freeplay/Freeplay_DiffArrow'));
            freelpayArrowRoight.setGraphicSize(baseWidth);
            freelpayArrowRoight.updateHitbox();
        }
    }

    function changeSelection(change:Int = 0) {
        curSelection += change;
        if (curSelection < 0)
            curSelection = catList.length-1;
        if (curSelection >= catList.length)
            curSelection = 0;

        trace('Cur Catagory: ' + catList[curSelection]);
        catImage.destroy();
        var catagoryImg:String = catList[curSelection];
        switch (catList[curSelection]) {// ONLY ADD IF YOU WANT TO USE A SEPERATE FILE NAME.
            case 'story':
                catagoryImg = 'main';
        }
        if (FileSystem.exists('./$catImgPath/catagory-$catagoryImg.png')) {
            catImage = new FlxSprite().loadGraphic(Paths.image('catagory/catagory-$catagoryImg'));
            catImage.screenCenter();
            catImage.antialiasing = ClientPrefs.data.antialiasing;
            if (catImage.width != 512 || catImage.height != 512) catImage.setGraphicSize(512);
            add(catImage);
        } else {
            catImage = new FlxSprite().loadGraphic(Paths.image('missingImage'));
            catImage.screenCenter();
            catImage.antialiasing = ClientPrefs.data.antialiasing;
            if (catImage.width != 512 || catImage.height != 512) catImage.setGraphicSize(512);
            add(catImage);
            trace('"./$catImgPath/catagory-$catagoryImg" NOT FOUND, DOUBLE CHECK THE PATH AND IMAGE EXISTS.');
        }
        catText.destroy();
        catText = new Alphabet(0, 100, catList[curSelection], true);
        catText.screenCenter(X);
        add(catText);
    }
}

class SongMenuState extends MusicBeatState {
    // Generic Lists
    var songs:Array<String> = [];
    var catSongList:Array<Array<String>> = [
        // Story
        ['tutorial', 'saloon-trouble', 'conflicting-views', 'ambush'],
        // Covers
        ['triple-trouble', 'junkyard'],
        // Extra
        ['blubber', 'defeat-char-mix', 'defeat-odd-mix'],
        // Secret
        ['origins', 'obligatory-bonus-song'],
        // Collabs
        ['high-ground-old', 'high-ground', 'high-grounder'],
        // Legacy
        ['free-movies-free', '3-problems', 'slow', 'you-can-walk', 'vesania', 'infinite', 'shenanigans']
    ];
    var catList:Array<String> = [
        'story',
        'covers',
        'extra',
        'secret',
        'collabs',
        'legacy'
    ];
    var curSongList:Int = 0;
    var curIcon:HealthIcon;
    var curSelected:Int = 0;
    var tempText:FlxText;
    var missingText:FlxText;
    var missingTextBG:FlxSprite;
    var songIcon:FlxSprite;

    public function new(cat:String = 'default', catInt:Int = 0) {
        super();
        if (cat != 'default'){
        switch (cat.toLowerCase()) {
            case 'story':
                curSongList = 0;
            case 'covers':
                curSongList = 1;
            case 'extra':
                curSongList = 2;
            case 'collabs':
                curSongList = 4;
            case 'legacy':
                curSongList = 5;
            case 'secret':
                curSongList = 3;
        }
        } else {
            curSongList = catInt; // PlayState sets this.
        }
        songs = catSongList[curSongList];
    }
    var tmpTimer:FlxTimer;
    var bg:FlxSprite;
    var switchPages:FlxText;
    var uiSwitchButton:String;

    override function create() {
        uiSwitchButton = removeArrayHinting(ClientPrefs.getKeys('ui_switch'));
        bg = new FlxSprite().loadGraphic(Paths.image('menuBG/Desat'));
        bg.color = 0xFF0080;
        bg.antialiasing = ClientPrefs.data.antialiasing;
        add(bg);
        var abberationBGBlue:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBG/DesatLines'));
        abberationBGBlue.color = 0x0000FF;
        abberationBGBlue.x = bg.x - 2;
        abberationBGBlue.y = bg.y - 2;
        abberationBGBlue.antialiasing = ClientPrefs.data.antialiasing;
        abberationBGBlue.alpha = 0.25;
        add(abberationBGBlue);
        var abberationBGRed:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBG/DesatLines'));
        abberationBGRed.color = 0xFF0000;
        abberationBGRed.x = bg.x + 2;
        abberationBGRed.y = bg.y + 2;
        abberationBGRed.antialiasing = ClientPrefs.data.antialiasing;
        abberationBGRed.alpha = 0.25;
        add(abberationBGRed);
        tempText = new FlxText(0,0,FlxG.width,"THIS STATE NOT FINISHED\nCURRENT SONG LIST: " + catSongList[curSongList], 32);
        tempText.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BROWN);
        tempText.screenCenter();
        add(tempText);
        switchPages = new FlxText(0, 0, FlxG.width, 'Press $uiSwitchButton to change tabs!', 24);
        switchPages.setFormat(Paths.font('vcr.ttf'), 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BROWN);
        add(switchPages);
        
        curIcon = new HealthIcon('face');
        curIcon.x = FlxG.width * 0.7;
        curIcon.y = FlxG.height * 0.8;
        add(curIcon);

        var songIcoTxt:FlxText = new FlxText(0, 0, 0, 'Song Icon:', 24);
        songIcoTxt.x = curIcon.x;
        songIcoTxt.y = curIcon.y - 50;
        songIcoTxt.setFormat(Paths.font('vcr.ttf'), 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BROWN);
        add(songIcoTxt);
        
		missingTextBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		missingTextBG.alpha = 0.6;
		missingTextBG.visible = false;
		add(missingTextBG);
		
		missingText = new FlxText(50, 0, FlxG.width - 100, '', 24);
		missingText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		missingText.scrollFactor.set();
		missingText.visible = false;
		add(missingText);

        songIcon = new FlxSprite().loadGraphic(Paths.image('missingImage'));
        songIcon.screenCenter();
        add(songIcon);
        changeSelection();
    }

    function removeArrayHinting(array:Array<String>):String {
        var temp:String = Std.string(array);
        temp = temp.replace('[', '');
        temp = temp.replace(']', '');
        temp = temp.replace(',', '/');
        return temp;
    }

        
    var missingTween:FlxTween;
    var missingBGTween:FlxTween;
    override function update(elapsed:Float) {
        if (controls.UI_RIGHT_P) {
            FlxG.sound.play(Paths.sound('scrollMenu'));
            changeSelection(1);
        }
        if (controls.UI_LEFT_P) {
            FlxG.sound.play(Paths.sound('scrollMenu'));
            changeSelection(-1);
        }
        if (controls.BACK) {
            MusicBeatState.switchState(new CustomFreeplayMenuState());
        }
        if (controls.ACCEPT) {
			persistentUpdate = false;
			var songLowercase:String = Paths.formatToSongPath(songs[curSelected]);
			var poop:String = songLowercase + '-hard';
			trace(poop);

			try
			{
				PlayState.SONG = Song.loadFromJson(poop, songLowercase);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = 0;
                PlayState.sendToSongMenu = true;
                PlayState.songMenuStorage = curSongList;
			}
			catch(e:Dynamic)
			{
                if (missingTween != null) missingTween.cancel(); 
                if (missingBGTween != null) missingBGTween.cancel();
				trace('ERROR! $e');

				var errorStr:String = e.toString();
				if(errorStr.startsWith('[file_contents,assets/data/')) errorStr = 'Missing file: ' + errorStr.substring(34, errorStr.length-1); //Missing chart
				missingText.text = 'ERROR WHILE LOADING CHART:\n$errorStr';
				missingText.screenCenter(Y);
                missingText.alpha = 1;
                missingTextBG.alpha = 0.6;
				missingText.visible = true;
				missingTextBG.visible = true;
                missingTween = FlxTween.tween(missingText, {alpha: 0}, 2.5, {onComplete: function(twn:FlxTween){
                    missingText.visible = false;
                }});
                missingBGTween = FlxTween.tween(missingTextBG, {alpha: 0}, 2.5, {onComplete: function(twn:FlxTween){
                    missingTextBG.visible = false;
                }});
				FlxG.sound.play(Paths.sound('cancelMenu'));
				super.update(elapsed);
				return;
			}
			LoadingState.loadAndSwitchState(new PlayState());

			FlxG.sound.music.volume = 0;
            
			#if (MODS_ALLOWED && DISCORD_ALLOWED)
			DiscordClient.loadModRPC();
			#end
        }
        if (controls.UI_SWITCH_P) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
            switchPage();
        }
    }

    function changeSelection(change:Int = 0) {
        curSelected += change;
        if (curSelected < 0)
            curSelected = catSongList[curSongList].length-1;
        if (curSelected >= catSongList[curSongList].length)
            curSelected = 0;

        curIcon.destroy();
        curIcon = new HealthIcon(songCheck(catSongList[curSongList][curSelected]));
        curIcon.x = FlxG.width * 0.7;
        curIcon.y = FlxG.height * 0.8;
        add(curIcon);
        tempText.destroy();
        tempText = new FlxText(0,0,FlxG.width,"THIS STATE NOT FINISHED\nCURRENT SONG: " + catSongList[curSongList][curSelected], 32);
        tempText.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BROWN);
        tempText.screenCenter(X);
        add(tempText);
        switchPages.destroy();
        var curTab:String = catList[curSongList];
        switchPages = new FlxText(0, 0, 0, 'Press $uiSwitchButton to change tabs!\nCurrent Tab: $curTab', 24);
        switchPages.setFormat(Paths.font('vcr.ttf'), 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BROWN);
        switchPages.x = 0; // it keeps moving to the center????
        add(switchPages);

        songIcon.destroy();
        var image:FlxGraphic;
        if (songs[curSelected] == 'blubber') image = Paths.image('freeplay/coverArt/blubberSquare'); else image = Paths.image('missingImage');
        songIcon = new FlxSprite().loadGraphic(image);
        songIcon.setGraphicSize(384);
        songIcon.updateHitbox();
        songIcon.screenCenter();
        songIcon.antialiasing = ClientPrefs.data.antialiasing;
        add(songIcon);
        
        missingTextBG.destroy();
        missingText.destroy();
		missingTextBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		missingTextBG.alpha = 0.6;
		missingTextBG.visible = false;
		add(missingTextBG);
		
		missingText = new FlxText(50, 0, FlxG.width - 100, '', 24);
		missingText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		missingText.scrollFactor.set();
		missingText.visible = false;
		add(missingText);

        //trace('Cur Song: ' + catSongList[curSongList][curSelected]);
    }

    function songCheck(song:String):String { // TODO: MAKE THIS BETTER >:(
        var icon:String = 'face';
        var foundIcon:Bool = false;
        var pos:Int = 0;
        for (array in ReferenceStrings.songIcons) {
            if (!foundIcon) {
            pos++;
            trace('curPos $pos');
                //trace('curArray: $array');
                for (songName in array[1]) {
                        if (song == songName) {
                            trace('icon for $songName is: ' + array[0][0]);
                            foundIcon = true;
                            icon = array[0][0];
                            pos = pos - 1; // Because it will always be offset by 1.
                            bg.color = ReferenceStrings.songColors[pos]; // Temp change the color instantly instead of tween :3
                        }
                    }
            trace('curPos $pos');
                }
            }
        return icon;
    }

    function switchPage() {
        curSongList++;
        var newPage = curSongList;
        if (curSongList >= catSongList.length)
            newPage = 0;
        MusicBeatState.switchState(new SongMenuState('default', newPage));
    }
}