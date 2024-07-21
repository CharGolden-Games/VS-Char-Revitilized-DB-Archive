package states.gallery;

import states.gallery.MasterGalleryMenu;

// cant find files if you dont have the damn LIBRARIES
import sys.FileSystem;
import sys.io.File;

class StoryGalleryState extends MusicBeatState
{
    var BG:FlxSprite;
    var path:String = './assets/images/gallery/story/';
    var galleryImage:FlxSprite;
    var descriptionText:FlxText;
    var descTextField:Array<String> = [
        "Char Grilled Cheese:
        \nHe's quite the dumbass. 
        \nBut that doesn't mean he can't tell
        \nwhen he's in danger! its just...
        \nvery very hard to.",
        "Trevor:
        \nThis guy hails from Tridite City!
        \nOne of Char's best friends even if he
        \nhasn't been with him and Plexi much,
        \nbeing called there more often recently.",
        "Plexi:
        \nThis Quirky lil' protogen is one of
        \nChar's best friends!
        \nkeeps Char out of trouble... Reluctantly.",
        "Micheal:
        \nEver since they first met,
        \nMicheal has been trying to get back at
        \nChar after he beat him several years ago.",
        "Char Grilled Cheese (Origin Design):
        \nWhen he was so much of a cocky dumba-
        \nHe didnt notice that one of the people\nhe fought against wasn't even human...",
        "Micheal (Origin Design):
        \nChar's First encounter with Micheal\nafter he re-encountered char,\nand had decided to mess with him.
        \nhe looks very different compared to his 
        \nmore recent events.",
        "Plexi Fake/Clone:
        \nThis is a curious case.
        \nOriginally, Plexi Clone and Plexi Fake
        \nwere seperated instead of how they are
        \nnow, but one day Fake went missing 
        \nonly to be found when Clone had been
        \nacting weird, revealing they were now
        \nthe same person.",
        "Trevor Clone:
        \nOriginally was going to be part of
        \nthe story but has been retconned.",
        "Trevor Fake:
        \nOriginally was going to be part of
        \nthe story but has been retconned.",
        "Zavi (Previously Char Fake):
        \nThis Char is actually smart, and
        \nusing that, manipulates his way to
        \nhis desired results.",
        "Char Clone:
        \nOriginally was going to be part of
        \nthe story but has been retconned.",
        "Plexi Clone (Classic):
        \nOriginally were going to be seperate\nbut thats been retconned.",
        "Plexi Fake (Classic):
        \nOriginally were going to be seperate\nbut thats been retconned."
    ];
    var galleryImages:Array<String> = [
        'Char_modern',
        'Trevor_modern',
        'Plexi_ingame',
        'Micheal_modern',
        'Char_origin',
        'Micheal_origin',
        'PlexiFC_modern',
        'TrevorC_classic',
        'TrevorF_classic',
        'Zavi_modern',
        'CharC_classic',
        'PlexiC_classic',
        'PlexiF_classic'
    ];
    private var curSelected = 0;

    override function create() {
        // FlxG.camera.bgColor = FlxColor.WHITE;
        trace('Story Gallery');
        #if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Browsing the Gallery | Browsing Story Images", null);
		#end

        BG = new FlxSprite().loadGraphic(Paths.image('menuBG/GalleryBlue'));
        BG.setGraphicSize(1350);
        BG.updateHitbox();
        BG.screenCenter();
		add(BG);
        if (!FileSystem.exists(path + galleryImages[curSelected] + '.png') != true) 
            {
                trace(path + galleryImages[curSelected] + '.png Found!');
                galleryImage = new FlxSprite().loadGraphic(Paths.image('gallery/story/' + galleryImages[curSelected]));
            }
            else if (!FileSystem.exists(path + galleryImages[curSelected] + '.png') == true)
            {
                trace(path + galleryImages[curSelected] + '.png Not found! oops. check the path again. if it is correct, CHECK THE FILE NAME');
                galleryImage = new FlxSprite().loadGraphic(Paths.image('gallery/missing'));
            }
            galleryImage.x = (FlxG.width * 0.1);
            galleryImage.y = (FlxG.height * 0.25);
            galleryImage.updateHitbox();
            galleryImage.antialiasing = ClientPrefs.data.antialiasing; // uhh it looks like shit without this lol.
            add(galleryImage);

            descriptionText = new FlxText(FlxG.width * 0.615, 4, 0, descTextField[curSelected], 20);
            descriptionText.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(descriptionText);
        changeSelection();
        super.create();

    }
        

    override public function update(elapsed:Float) {

        if (controls.UI_LEFT_P)
            {
            changeSelection(-1);
            }
        if (controls.UI_RIGHT_P)
            {
            changeSelection(1);
            }
        if (controls.UI_UP_P)
            {
            changeSelection(-1);
            }
        if (controls.UI_DOWN_P)
            {
            changeSelection(1);
            }
        if (controls.BACK)
            {
            // FlxG.camera.bgColor = FlxColor.BLACK;
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new MasterGalleryMenu());
            }
            if (controls.ACCEPT)
                {
                    if (galleryImages[curSelected].toLowerCase() == 'char')
                        {
                    FlxG.sound.play(Paths.sound('splat'));
                        }
                }
    }

    function changeSelection(change:Int = 0) {


        if (!ClientPrefs.data.disableScrollSound)
        {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        }
        curSelected += change;
        if (curSelected < 0)
            curSelected = galleryImages.length - 1;
        if (curSelected >= galleryImages.length)
            curSelected = 0;

        galleryImage.destroy();
        if (!FileSystem.exists(path + galleryImages[curSelected] + '.png') != true) 
            {
                trace(path + galleryImages[curSelected] + '.png Found!');
                galleryImage = new FlxSprite().loadGraphic(Paths.image('gallery/story/' + galleryImages[curSelected]));
            }
            else if (!FileSystem.exists(path + galleryImages[curSelected] + '.png') == true)
            {
                trace(path + galleryImages[curSelected] + '.png Not found! oops. check the path again. if it is correct, CHECK THE FILE NAME');
                galleryImage = new FlxSprite().loadGraphic(Paths.image('gallery/missing'));
            }
            var is512:Bool = true;
            if(galleryImage.width != 512 || galleryImage.height != 512) {
                if (galleryImage.width != 256 || galleryImage.height != 256) {
                    if (galleryImage.width / galleryImage.height == 1){
                    galleryImage.setGraphicSize(512, 512);
                    } else if (galleryImage.width != 512) {
                        galleryImage.setGraphicSize(512);
                    } else {
                    galleryImage.setGraphicSize(Std.int(galleryImage.width), 512);
                    }
                } else {
                    is512 = false;
                    if (galleryImage.width / galleryImage.height == 1){
                    galleryImage.setGraphicSize(256, 256);
                    } else if (galleryImage.width != 256) {
                        galleryImage.setGraphicSize(256);
                    } else {
                    galleryImage.setGraphicSize(Std.int(galleryImage.width), 256);
                    }
                }
            }
            galleryImage.updateHitbox();
            galleryImage.x = FlxG.width / 2;
            galleryImage.y = FlxG.height / 2;
            switch (galleryImages[curSelected].toLowerCase())
            {
                default:
                galleryImage.antialiasing = ClientPrefs.data.antialiasing; // uhh it looks like shit without this lol.
                case 'trevor':
                galleryImage.antialiasing = false;
            }
            add(galleryImage);

            descriptionText.destroy();
            descriptionText = new FlxText(FlxG.width * 0.615, 4, 0, descTextField[curSelected], 20);
            descriptionText.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(descriptionText);
    }
}
