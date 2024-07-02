// alright START EXPLAINING SHIT - Anny 3:32 PM 4/8/24
// i stole this code from gamebanana - Anny (Professional Code Stealer)
// https://gamebanana.com/questions/29334
// modified to fit my needs lol
package states;


import flixel.effects.FlxFlicker;
import lime.tools.ApplicationData;
import openfl.display.Application;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import backend.Achievements;
import states.CacheState.secretSound;
import backend.CursorChangerShit;

import sys.FileSystem;
import sys.io.File;
import states.FreeplayState;
import states.CacheState;

class FreeplaySelectState extends MusicBeatState {

    // dedicated code for catagories
    public static var freeplayCats:Array<String> = [
    'Main',
    'Covers',
    'Others and Bonus',
    // #if MODS_ALLOWED 'Mods', #end // NO MORE MODS CATAGORY
    'Secret',
    'Collabs',
    #if SHOW_BASE_CAT 'Base' #end
    ];
    // actually with how im implementing CatData, i shouldnt need this
    // this is used to set the BG Color!!
    public static var freeplayCatColor:Array<FlxColor> = [
        0xffff7b00,
        0xff4f6285,
        0xffd35881,
        // #if MODS_ALLOWED 0xffffffff, #end
        0xff313131,
        0xFFB700FF,
        #if SHOW_BASE_CAT 0xFF383394 #end
        ];

    public static var curCategory:Int = 0;
    public var NameAlpha:Alphabet;
    var grpCats:FlxTypedGroup<Alphabet>;
    var curSelected:Int = 0;
    var BG:FlxSprite;
    var categoryIcon:FlxSprite;
    var colorTween:FlxTween;
    var intendedColor:Int;
    var path:String;
    var modsFreeplayMenu:FlxSprite;
    var leftState:Bool = false;
    var clicked:Bool = false;

    override function create()
        {
            // just in case
            if (freeplayCats.contains('mods'))
                {
                freeplayCats.remove('mods');
                } else if (freeplayCats.contains('Mods'))
                {
                freeplayCats.remove('Mods');
                }
            if (freeplayCatColor.contains(0xf1ffffff))
                {
                    freeplayCatColor.remove(0xf1ffffff);
                }
            //FlxG.mouse.visible = true;
        CursorChangerShit.showCursor(true); // lets hope this works lmao.
		if (!CacheState.localEnableCache && !ClientPrefs.data.enableCaching)
		{
			secretSound = new FlxSound().loadEmbedded(Paths.sound('SecretSound'), true);
			// just in case Caching is disabled entirely
		}

        openfl.Lib.application.window.title = "Friday Night Funkin': VS Char Revitalized | Freeplay Catagory Select | ";

        if (secretSound == null){ // because apparently it can become null????
            secretSound = new FlxSound().loadEmbedded(Paths.sound('SecretSound'), true);
        }
        secretSound.volume = 0.5;
        // So that it too has a randomized bg
        BG = new FlxSprite().loadGraphic(MainMenuState.randomizeBG());
        BG.updateHitbox();
        BG.screenCenter();
        add(BG);
        // Thanks Freeplay, i stole your code
        BG.color = freeplayCatColor[curSelected];
        intendedColor = BG.color;
        
        // if an image for a catagory exists, load it, else load the "missing" image
        path = ('./assets/images/catagory/catagory-' + freeplayCats[curSelected].toLowerCase() + '.png');
        if (!FileSystem.exists(path) != true) {
            // trace('Found it, lets go!');
            categoryIcon = new FlxSprite().loadGraphic(Paths.image('catagory/catagory-' + freeplayCats[curSelected].toLowerCase()));
        }
        else if (!FileSystem.exists(path) == true) {
            // trace('MISSING FILE OH NO!!');
            categoryIcon = new FlxSprite().loadGraphic(Paths.image('catagory/catagory-missing'));
        }

        
        categoryIcon.updateHitbox();
        if (categoryIcon.width != 512 || categoryIcon.height != 512)
            {
                categoryIcon.setGraphicSize(512, 512);
                categoryIcon.updateHitbox();
            }
        categoryIcon.screenCenter();
        categoryIcon.antialiasing = ClientPrefs.data.antialiasing;
        add(categoryIcon);

        modsFreeplayMenu = new FlxSprite(10, 0).makeGraphic(50, 50, 0xFFFF9100);
        add(modsFreeplayMenu);
        //modsFreeplayMenu = new FlxSprite().loadGraphic(Paths.image('modsFreeplayMenuButton'));
        //modsFreeplayMenu.frames = Paths.getSparrowAtlas('modsFreeplayMenuButton');
        //modsFreeplayMenu.animation.addByPrefix('Idle', 'Idle');
        //modsFreeplayMenu.animation.addByPrefix('Pressed', 'Pressed');
        //add(modsFreeplayMenu);

        // NO MORE MODS MENU BITCH. THAT'LL BE A SEPERATE CLICKABLE THINGIEMAJIG.
        // pretty much just makes text that warns about the mods menu | why is this here ITS OBVIOUS WHAT IT DOES
		/*var warnTXT:FlxText = new FlxText(0, FlxG.height - 60, 0, "The 'Mods' catagory also contains every other week due to how its setup, \nTHERE WILL BE DUPLICATES. (For compatibility's sake)", 26);
		warnTXT.scrollFactor.set();
		warnTXT.setFormat("VCR OSD Mono", 26, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(warnTXT);*/

        NameAlpha = new Alphabet(40,(FlxG.height / 2) - 282,freeplayCats[curSelected],true);
        NameAlpha.screenCenter(X);
        backend.Highscore.load();
        add(NameAlpha);
        if (FreeplayState.curCatStorage != curCategory || FreeplayState.curCatStorage != curSelected)
            {
                // MAYBE THIS WILL WORK
                curCategory = FreeplayState.curCatStorage;
                curSelected = FreeplayState.curCatStorage;
            }
        changeSelection();
        super.create();

    }

    override public function update(elapsed:Float){
        
        openfl.Lib.application.window.title = "Friday Night Funkin': VS Char Revitalized | Freeplay Catagory Select | " + freeplayCats[curSelected];

        if (controls.UI_LEFT_P)
            changeSelection(-1);
        if (controls.UI_RIGHT_P)
            changeSelection(1);
        if (controls.BACK) {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            leftState = true;
            if (secretSound.playing)
                {
                    //trace('Playing, stopping it.');
                    FlxG.sound.music.volume = 1;
                    secretSound.pause();
                }
                MusicBeatState.switchState(new MainMenuState());
        }

        if (controls.ACCEPT){
            if (secretSound.playing)
                {
                    //trace('Playing, stopping it.');
                    FlxG.sound.music.volume = 1;
                    secretSound.pause();
                }
            leftState = true;
            MusicBeatState.switchState(new FreeplayState());
        }

        curCategory = curSelected;
        if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(modsFreeplayMenu))
        {
            freeplayCats.insert(3, 'Mods');
            freeplayCatColor.insert(3, 0xf1ffffff);
            trace('Clicked Mods');
            clicked = true;
            curSelected = 3;
            FlxG.sound.play(Paths.sound('confirmMenu'));

            if (ClientPrefs.data.flashing) {
            FlxFlicker.flicker(modsFreeplayMenu,1, 0.1, false, true, function(flk:FlxFlicker) {
                new FlxTimer().start(0.5, function (tmr:FlxTimer) {
                leftState = true;
                MusicBeatState.switchState(new FreeplayState());
                });
            }); }
            else {
                FlxTween.tween(modsFreeplayMenu, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween)
                    {
                        leftState = true;
                        MusicBeatState.switchState(new FreeplayState());
            }
        });
            }
        }

        if (FlxG.mouse.overlaps(modsFreeplayMenu) && !clicked)
            {
                CursorChangerShit.cursorStyle = Hand;
            }
            else {
                CursorChangerShit.cursorStyle = Default;
            }
        super.update(elapsed);

        if (leftState)
            {
                FlxG.mouse.visible = false;
            }

    }


    function changeSelection(change:Int = 0) {
        curSelected += change;
        if (curSelected < 0)
            curSelected = freeplayCats.length - 1;
        if (curSelected >= freeplayCats.length)
            curSelected = 0;

       if (freeplayCats[curSelected].toLowerCase() == 'secret')
            {
                if (!secretSound.playing)
                    {
                        //trace('Not playing, playing it now.');
                        FlxG.sound.music.volume = 0.3;
                        secretSound.play(false);
                    }
                else if (secretSound.playing)
                    {
                        //trace('Already playing, making sure the volume is lowered');
                        FlxG.sound.music.volume = 0.3;
                    }

            }
            else if (freeplayCats[curSelected].toLowerCase() != 'secret')
                {
                    if (!secretSound.playing)
                        {
                            //trace('Not playing, Doing nothing.');
                            FlxG.sound.music.volume = 1;
                        }
                    else if (secretSound.playing)
                        {
                            //trace('Playing, stopping it.');
                            FlxG.sound.music.volume = 1;
                            secretSound.pause();
                        }
                }

        NameAlpha.destroy();
        NameAlpha = new Alphabet(40,(FlxG.height / 2) - 282,freeplayCats[curSelected],true);
        NameAlpha.screenCenter(X);
        add(NameAlpha);
        // and this shit grabs the color and tweens the BG! just like Freeplay! because its the same code, the only thing changed is some variables due to how this state is setup.
		var newColor:Int = freeplayCatColor[curSelected];
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(BG, 1, BG.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
        }
        // if an image for a catagory exists, load it, else load the "missing" image
        path = ('./assets/images/catagory/catagory-' + freeplayCats[curSelected].toLowerCase() + '.png');
        if (!FileSystem.exists(path) != true) {
            // trace('Found it, lets go!');
            categoryIcon.loadGraphic(Paths.image('catagory/catagory-' + (freeplayCats[curSelected].toLowerCase())));
        }
        else if (!FileSystem.exists(path) == true) {
            // trace('MISSING FILE OH NO!!');
            categoryIcon.loadGraphic(Paths.image('catagory/catagory-missing'));
        }
        categoryIcon.updateHitbox();
        if (categoryIcon.width != 512 || categoryIcon.height != 512)
            {
                categoryIcon.setGraphicSize(512, 512);
                categoryIcon.updateHitbox();
            }
            categoryIcon.antialiasing = ClientPrefs.data.antialiasing;
        categoryIcon.screenCenter();
        add(categoryIcon);
       



        FlxG.sound.play(Paths.sound('scrollMenu'));

    }

}
