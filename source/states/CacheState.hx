package states;

import haxe.ui.events.ItemEvent;
import sys.FileSystem;
import animateatlas.AtlasFrameMaker;
import animateatlas.JSONData.AnimationData;
import flixel.addons.plugin.taskManager.FlxTask;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import backend.ClientPrefs;
import backend.TracePassThrough as CustomTrace;
import backend.WeekData;

class CacheState extends MusicBeatState
{
    public static var leftState:Bool = false;
    public static var firstView:Bool;

    var messageText:FlxText;
    var messageWindow:FlxSprite; // technically unused till the assets are done
    var messageButtonTextOk:FlxText; 
    var messageButtonTextOff:FlxText;
    var messageButtonBG:FlxSprite; // technically unused till the assets are done
    var messageButtonBG2:FlxSprite; // technically unused till the assets are done
    var charLoadRun:FlxSprite; 
    var plexiLoadRun:FlxSprite;
    var trevorLoadRun:FlxSprite; // unused till the assets are done
    var loadBar:FlxSprite;
    public static var localEnableCache:Bool = true; // for calling via TitleState, if you skip the damn warning it will ALWAYS cache bitch.
    var cacheText:FlxText;
    var totalSongs:Int = 0;


    var curSelected:Int = 0;
    // array for tracking mouseover lmao
    var curButton:Array<String> = [
        'Ok',
        'Off'
    ];

    // Cached Sounds when you enable it
    public static var secretSound:FlxSound;

    override function create()
        {
            super.create(); // maybe?????

            WeekData.reloadWeekFiles(true);

            var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBG/cacheBG'));
            bg.screenCenter();
            bg.setGraphicSize(Std.int(bg.width * 1.15));
            bg.alpha = 0.5;
		    add(bg);

            var RESETSAVE:FlxText = new FlxText(0, 0, 0, 'PRESS R TO RESET YOUR SAVE', 10);
            RESETSAVE.setFormat('vcr.ttf', 10, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
            add(RESETSAVE);

            firstView = ClientPrefs.data.firstCacheStateView;
            leftState = false;
            localEnableCache = false; // for not caching the sound twice.

            loadBar = new FlxSprite().loadGraphic(Paths.image('loadRun/loadBar'));
            loadBar.y = FlxG.height - 40;
            add(loadBar);
            trace(Std.string(loadBar.width));

            if (!FileSystem.exists('./assets/images/loadRun/loadRun.png') != true)
                {
                    CustomTrace.trace("Char's Run Anim Found in loadRun.png", 'info');
                    charLoadRun = new FlxSprite().loadGraphic(Paths.image('loadRun/loadRun'));
                    charLoadRun.frames = Paths.getSparrowAtlas('loadRun/loadRun');
                }
            else
                {
                    CustomTrace.trace("Char's Run Anim not Found in loadRun.png", 'warn');
                    charLoadRun = new FlxSprite().loadGraphic(Paths.image('loadRun/charLoadRun'));
                    charLoadRun.frames = Paths.getSparrowAtlas('loadRun/charLoadRun');
                }
            charLoadRun.y = loadBar.y - 300;
            charLoadRun.x = FlxG.width * 0.68;
            charLoadRun.animation.addByPrefix('charLoadRun', 'charLoadRun', 26, true);
            charLoadRun.setGraphicSize(100);
            charLoadRun.antialiasing = true;
            add(charLoadRun);

            if (!FileSystem.exists('./assets/images/loadRun/loadRun.png') != true)
                {
                    trace("Plexi's Run Anim Found in loadRun.png");
                    plexiLoadRun = new FlxSprite().loadGraphic(Paths.image('loadRun/loadRun'));
                    plexiLoadRun.frames = Paths.getSparrowAtlas('loadRun/loadRun');
                }
            else
                {
                    trace("Plexi's Run Anim not Found in loadRun.png");
                    plexiLoadRun = new FlxSprite().loadGraphic(Paths.image('loadRun/plexiLoadRun'));
                    plexiLoadRun.frames = Paths.getSparrowAtlas('loadRun/plexiLoadRun');
                }
            plexiLoadRun.y = loadBar.y - 295;
            plexiLoadRun.x = charLoadRun.x + 95;
            plexiLoadRun.animation.addByPrefix('plexiLoadRun', 'plexiLoadRun', 26, true);
            plexiLoadRun.setGraphicSize(100);
            plexiLoadRun.antialiasing = true;
            add(plexiLoadRun);

            FlxTween.tween(charLoadRun, {x: -150}, 4, {ease: FlxEase.cubeOut});
            FlxTween.tween(plexiLoadRun, {x: -70}, 4, {ease: FlxEase.cubeOut});
            
            /* 
            if (!FileSystem.exists('./assets/images/loadRun/loadRun.png') != true)
                {
                    trace("Trevor's Run Anim Found in loadRun.png");
                    trevorLoadRun = new FlxSprite().loadGraphic(Paths.image('loadRun/loadRun'));
                    trevorLoadRun.frames = Paths.getSparrowAtlas('loadRun/loadRun');
                }
            else
                {
                    trace("Trevor's Run Anim not Found in loadRun.png");
                    trevorLoadRun = new FlxSprite().loadGraphic(Paths.image('loadRun/plexiLoadRun'));
                    trevorLoadRun.frames = Paths.getSparrowAtlas('loadRun/plexiLoadRun');
                }
            */
            //trevorLoadRun.y = loadBar.y - 90;
            //trevorLoadRun.x = plexiLoadRun.x + 100;
            //trevorLoadRun.animation.addByPrefix('trevorLoadRun', 'trevorLoadRun', 26, true);
            //trevorLoadRun.setGraphicSize(100);
            //trevorLoadRun.antialiasing = true;
            //add(trevorLoadRun);
            //trevorLoadRun.animation.play('trevorLoadRun');

            messageWindow = new FlxSprite().makeGraphic(700, 580, 0xFFAF7B40);
            messageWindow.x = FlxG.width * 0.225;
            messageWindow.y = FlxG.height * 0.05;
            add(messageWindow);

            CursorChangerShit.showCursor(true);

            //FlxTween.tween(trevorLoadRun, {x: 0}, 4, {ease: FlxEase.cubeOut});
            
            
            if (firstView)
                {
                    ClientPrefs.data.noteSkin = 'Pop';
                    ClientPrefs.saveSettings();
                    openfl.Lib.application.window.title = "Friday Night Funkin': VS Char Revitalized | Flashing Lights Warning!!";
                    messageText = new FlxText(FlxG.width * 0.3, FlxG.height * 0.1, FlxG.width * 0.5, 
                        "Welcome to VS Char Revitalized Alpha 1!
                        \nThis Mod contains FLASHING LIGHTS.
                        \nif you don't wanna see that press 'Enter/Space'
                        \n else, press 'Escape/Backspace'", 32);
                        messageText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
                        messageText.screenCenter(X);
		                add(messageText);
                        messageText.alpha = 0;
                        messageWindow.alpha = 0;
                        FlxTween.tween(messageText, {alpha: 1}, 1);
                        FlxTween.tween(messageWindow, {alpha: 1}, 1);
                }
                else 
                    {
                        openfl.Lib.application.window.title = "Friday Night Funkin': VS Char Revitalized | Cache Option!";
                        messageText = new FlxText(FlxG.width * 0.3, FlxG.height * 0.1, FlxG.width * 0.5, 
                            "Welcome to VS Char Revitalized Alpha 1!
                            \nthis mod caches sounds to avoid states taking a while to load,\nDo you want to enable caching?
                            \n(This also affects update caching)",32);
                            messageText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
                            messageText.screenCenter(X);
                            add(messageText);

                            messageButtonBG = new FlxSprite().makeGraphic(100, 50, 0xFFFF8800);
                            messageButtonBG.x = FlxG.width * 0.31;
                            messageButtonBG.y = FlxG.height - 165;
                            //messageButtonBG.frames = Paths.getSparrowAtlas('loadRun/button');
                            //messageButtonBG.animation.addByPrefix('idle', 'buttonIdle', 26, true);
                            //messageButtonBG.animation.addByPrefix('hover', 'buttonHover', 26, true);
                            //messageButtonBG.animation.addByPrefix('press', 'buttonPress', 26, false);
                            add(messageButtonBG);
                            //messageButtonBG2.animation.play('idle');

                            messageButtonBG2 = new FlxSprite().makeGraphic(100, 50, 0xFFFF8800);
                            messageButtonBG2.x = FlxG.width * 0.625;
                            messageButtonBG2.y = FlxG.height - 165;
                            //messageButtonBG2.frames = Paths.getSparrowAtlas('loadRun/button');
                            //messageButtonBG2.animation.addByPrefix('idle', 'buttonIdle', 26, true);
                            //messageButtonBG2.animation.addByPrefix('hover', 'buttonHover', 26, true);
                            //messageButtonBG2.animation.addByPrefix('press', 'buttonPress', 26, false);
                            add(messageButtonBG2);
                            //messageButtonBG2.animation.play('idle');

                            messageButtonTextOk = new FlxText(FlxG.width * 0.25, FlxG.height - 160, FlxG.width * 0.2,
                                'Yes');
                            messageButtonTextOk.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
                            add(messageButtonTextOk);

                            messageButtonTextOff = new FlxText(messageButtonTextOk.x + 400, FlxG.height - 160, FlxG.width * 0.2,
                                'No');
                            messageButtonTextOff.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
                            add(messageButtonTextOff);

                            messageText.alpha = 0;
                            messageWindow.alpha = 0;
                            messageButtonBG.alpha = 0;
                            messageButtonBG2.alpha = 0;
                            messageButtonTextOff.alpha = 0;
                            messageButtonTextOk.alpha = 0;

                            FlxTween.tween(messageText, {alpha: 1}, 1);
                            FlxTween.tween(messageWindow, {alpha: 1}, 1);
                            FlxTween.tween(messageButtonBG, {alpha: 1}, 1);
                            FlxTween.tween(messageButtonBG2, {alpha: 1}, 1);
                            FlxTween.tween(messageButtonTextOff, {alpha: 1}, 1);
                            FlxTween.tween(messageButtonTextOk, {alpha: 1}, 1, {onComplete: function(twn:FlxTween){
                                changeSelection();
                            }});
                             // hopefully this fixes the animation bug??? Flixel is so annoying rn my god man.
                            
                    }
                    cacheText = new FlxText(0, 0, 0, 'Caching Songs');
                    cacheText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
                    cacheText.screenCenter();
                    cacheText.alpha = 0;
                    add(cacheText);
                    for (i in 0...WeekData.weeksList.length) {
                        var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
                        
                        for (song in leWeek.songs)
                        {
                            totalSongs++;
                        }
                    }
        }


        var timer:FlxTimer = new FlxTimer();
        var addedTxt:Bool = false;
        var resetWarningActive:Bool;
        var nEWMessageWindowlmao:FlxSprite;
        var saveResetText:FlxText;
        var songsCached:Int = 0;
        var cachingDone:Bool = false;
        override function update(elapsed:Float) {
             charLoadRun.animation.play('charLoadRun');
            plexiLoadRun.animation.play('plexiLoadRun');
            
            if (controls.RESET && !resetWarningActive || FlxG.keys.pressed.R && !resetWarningActive)
                {
                    nEWMessageWindowlmao = new FlxSprite().makeGraphic(300, 300, FlxColor.RED);
                    nEWMessageWindowlmao.color = 0x940000;
                    nEWMessageWindowlmao.screenCenter(XY);
                    nEWMessageWindowlmao.height = 100;
                    nEWMessageWindowlmao.updateHitbox();
                    nEWMessageWindowlmao.alpha = 0.75;
                    add(nEWMessageWindowlmao);
                    saveResetText = new FlxText(nEWMessageWindowlmao.x, nEWMessageWindowlmao.y, nEWMessageWindowlmao.width, 'ARE YOU ABSOLUTELY POSITIVELY SURE YOU WANNA DELETE YOUR SAVE?????
                    \n\n\n\nENTER = YES, ESC = NO', 35);
                    saveResetText.setFormat('funkin.otf', 35, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
                    add(saveResetText);
                    resetWarningActive = true;
                }
            var back:Bool = controls.BACK;
            if (firstView && !resetWarningActive)
                {
                    if (controls.ACCEPT || controls.BACK && !leftState)
				            if(!back) {
                                FlxTween.tween(messageWindow, {alpha: 0}, 1);
					            ClientPrefs.data.flashing = false;
                                ClientPrefs.data.firstCacheStateView = false;
					            ClientPrefs.saveSettings();
					            FlxG.sound.play(Paths.sound('confirmMenu'));
					            FlxFlicker.flicker(messageText, 1, 0.1, false, true, function(flk:FlxFlicker) {
						        new FlxTimer().start(0.5, function (tmr:FlxTimer) {
							    FlxG.resetState();
						        });
					        });
				            } else {
					            FlxG.sound.play(Paths.sound('cancelMenu'));
                                ClientPrefs.data.firstCacheStateView = false;
                                ClientPrefs.saveSettings();
					            FlxTween.tween(messageText, {alpha: 0}, 1, {
						        onComplete: function (twn:FlxTween) {
							    FlxG.resetState();
                                FlxTween.tween(messageWindow, {alpha: 0}, 1);
						}
					});
				}      
            }
            else
                {
                    if (FlxG.mouse.overlaps(messageButtonBG) && !leftState || FlxG.mouse.overlaps(messageButtonBG2) && !leftState)
                        {
                            CursorChangerShit.cursorStyle = Hand;
                        }

                        
                        else {
                            CursorChangerShit.cursorStyle = Default;
                        }


                    if (FlxG.mouse.overlaps(messageButtonBG) && curButton[curSelected] != 'Ok'  && !resetWarningActive && !leftState)
                        {
                            FlxG.sound.play(Paths.sound('scrollMenu'));
                            changeSelection(-1);
                        }


                    else if (FlxG.mouse.overlaps(messageButtonBG2) && curButton[curSelected] != 'Off'  && !resetWarningActive && !leftState)
                        {
                            FlxG.sound.play(Paths.sound('scrollMenu'));
                            changeSelection(1);
                        }


                    if (controls.UI_LEFT_P  && !resetWarningActive && !leftState)
                        {
                            FlxG.sound.play(Paths.sound('scrollMenu'));
                            changeSelection(-1);
                        }


                    if (controls.UI_RIGHT_P  && !resetWarningActive && !leftState)
                        {
                            FlxG.sound.play(Paths.sound('scrollMenu'));
                            changeSelection(1);
                        }


                        // long ass if condition tf
                if (controls.ACCEPT && !leftState && !addedTxt  && !resetWarningActive 
                    || FlxG.mouse.pressed && FlxG.mouse.overlaps(messageButtonBG) && !leftState  && !resetWarningActive 
                    || FlxG.mouse.pressed && FlxG.mouse.overlaps(messageButtonBG2) && !leftState  && !resetWarningActive)
                    {
                        FlxG.sound.play(Paths.sound('confirmMenu'));
                        switch (curSelected)
                        {
                            //just in case
                            default:
                                ClientPrefs.data.enableCaching = true;
                                ClientPrefs.saveSettings();
                                leftState = true;
                            case 0:
                                ClientPrefs.data.enableCaching = true;
                                ClientPrefs.saveSettings();
                                leftState = true;
                            case 1:
                                ClientPrefs.data.enableCaching = false;
                                ClientPrefs.saveSettings();
                                leftState = true;
                        }
                            
                        
            }
        }
            if (leftState)
                {

				    FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
                    /*
                    switch (curSelected)
                    {
                        case 0:
                            messageButtonBG.animation.play('pressed');
                        case 1:
                            messageButtonBG2.animation.play('pressed');
                    }
                    */
                    var isCached:Bool = false;
                    FlxTween.tween(messageWindow, {alpha: 0}, 1);
                    FlxTween.tween(messageButtonBG, {alpha: 0}, 1);
                    FlxTween.tween(messageButtonBG2, {alpha: 0}, 1);
                    FlxTween.tween(messageButtonTextOff, {alpha: 0}, 1);
                    FlxTween.tween(messageButtonTextOk, {alpha: 0}, 1);
                    cacheText.alpha = 1;
				    FlxTween.tween(messageText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
                        if (ClientPrefs.data.enableCaching && !isCached)
                            {
                                isCached = true;
                                preCache();
                            }}});
        } if (resetWarningActive && controls.ACCEPT) {
            FlxG.save.erase();
            FlxG.resetGame(); // because otherwise it might commit die lmao.
        } else if (resetWarningActive && controls.BACK) {
            saveResetText.destroy();
            nEWMessageWindowlmao.destroy();
            resetWarningActive = false;
        }
        super.update(elapsed); // WITH THIS SUPER COMMAND I FIXED CACHE STATE HAHAHAHAHHAHHA
    }

        function preCache()
        {
            if (!cachingDone) {
            var weeksLoaded:Array<String> = WeekData.weeksList;
            secretSound = new FlxSound().loadEmbedded(Paths.sound('SecretSound'), true);
            trace('weekdata weeksList: $weeksLoaded');
                        trace('Total Songs: $totalSongs');
                        for (i in 0...WeekData.weeksList.length) {
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
                                var sound:FlxSound = new FlxSound().loadEmbedded(Paths.voices(Paths.formatToSongPath(song[0])));
                                var sound:FlxSound = new FlxSound().loadEmbedded(Paths.inst(Paths.formatToSongPath(song[0]))); // cache the songs lmao
                                trace('Caching: ' + song[0]);
                                songsCached++;
                            }
                            trace('Cached Songs: $songsCached / $totalSongs');
                        }
                        }
                        if (songsCached == totalSongs) {
                            cachingDone = true;
                            cacheText.text = 'Songs Cached!';
                        }
                        if (!timer.active && cachingDone)
                            {
                                timer.start(2, backToMenu);
                            }
        }

        function backToMenu(timer:FlxTimer){
            MusicBeatState.switchState(new TitleState());
            }


        function changeSelection(change:Int = 0) {

            curSelected += change;
            if (curSelected < 0)
                curSelected = 1;
            if (curSelected > 1)
                curSelected = 0;
            if (!leftState) {
            switch (curSelected)
                {
                    // just in case
                    default:
                        messageButtonTextOff.destroy();
                        messageButtonTextOk.destroy();

                        messageButtonTextOk = new FlxText(FlxG.width * 0.25, FlxG.height - 160, FlxG.width * 0.2,
                            'Yes');
                        messageButtonTextOk.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
                        add(messageButtonTextOk);
                        messageButtonTextOff = new FlxText(messageButtonTextOk.x + 400, FlxG.height - 160, FlxG.width * 0.2,
                            'No');
                        messageButtonTextOff.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
                        add(messageButtonTextOff);
                    case 0:
                        messageButtonTextOff.destroy();
                        messageButtonTextOk.destroy();

                        messageButtonTextOk = new FlxText(FlxG.width * 0.25, FlxG.height - 160, FlxG.width * 0.2,
                            'Yes');
                        messageButtonTextOk.setFormat("VCR OSD Mono", 32, FlxColor.YELLOW, CENTER);
                        add(messageButtonTextOk);
                        messageButtonTextOff = new FlxText(messageButtonTextOk.x + 400, FlxG.height - 160, FlxG.width * 0.2,
                            'No');
                        messageButtonTextOff.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
                        add(messageButtonTextOff);
                        //messageButtonBG.animation.play('hover');
                    case 1:
                        messageButtonTextOff.destroy();
                        messageButtonTextOk.destroy();

                        messageButtonTextOk = new FlxText(FlxG.width * 0.25, FlxG.height - 160, FlxG.width * 0.2,
                            'Yes');
                        messageButtonTextOk.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
                        add(messageButtonTextOk);
                        messageButtonTextOff = new FlxText(messageButtonTextOk.x + 400, FlxG.height - 160, FlxG.width * 0.2,
                            'No');
                        messageButtonTextOff.setFormat("VCR OSD Mono", 32, FlxColor.YELLOW, CENTER);
                        add(messageButtonTextOff);
                        //messageButtonBG2.animation.play('hover');
                }
            }
        }
}