package new_options;

import options.*;

class CharOptions extends MusicBeatState
{
    static var options:Array<String> = [
        'Coloring',
        'Control',
        "Delay n' Combo",
        'Looks',
        'UI',
        'Play'
    ];
    static var tempOptions:FlxTypedGroup<FlxSprite>;
    var tempOptionTexts:FlxTypedGroup<FlxText>;
    static var curSelected:Int = 0;
    var bg:FlxSprite;

    override function create() {
        bg = new FlxSprite().loadGraphic(Paths.image('menuBG/Desat'));
        bg.color = 0x8C3ACF;
        add(bg);

        tempOptions = new FlxTypedGroup<FlxSprite>(); // after verifying it works, MAKE SURE TO REMAKE "TempOption.hx"!
        tempOptionTexts = new FlxTypedGroup<FlxText>();

        add(tempOptions);
        add(tempOptionTexts);

        var pos:Int = 0;
        for (option in options) {
            pos++;
            var tempBox:FlxSprite = new FlxSprite().makeGraphic(500, 250, 0xEC9819);
            //tempBox.x = FlxG.width - (tempBox.width + 5);
            pos--; // Cause of offset due to plus-ing at pos 0
            tempBox.y = 100 * pos;
            /*tempOptions.*/add(tempBox);
            var tempText:FlxText = new FlxText(0, 0, tempBox.width, option, 12);
            tempText.setFormat(Paths.font('vcr.ttf'), 12, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            tempText.y = tempBox.getGraphicMidpoint().y;
            tempText.x = tempBox.getGraphicMidpoint().x;
            /*tempOptionTexts.*/add(tempText);
        }

        switchSelection();
    }

    override function update(elapsed:Float) {
        if (controls.UI_LEFT_P) {
            switchSelection(-1);
        }
        if (controls.UI_RIGHT_P) {
            switchSelection(1);
        }
        if (controls.BACK) {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new OptionsState());
        }
        if (controls.ACCEPT) {
            FlxG.sound.play(Paths.sound('confirmMenu'));
            trace('No options ready yet!');
        }
    }

    public static function switchSelection(change:Int = 0) {
        curSelected++;
        if (curSelected > options.length) 
            curSelected = 0;
        if (curSelected < 0)
            curSelected = options.length - 1;

        FlxG.sound.play(Paths.sound('scrollMenu'));

        /*for (i in 0...tempOptions.members.length) {
            if (i != curSelected) tempOptions.members[i].isSelected = false;
            if (i == curSelected) tempOptions.members[i].isSelected = true;
        }*/
    }
}