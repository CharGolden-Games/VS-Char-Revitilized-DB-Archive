// lmao example state go brrrrr
var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.height + 500, FlxG.width + 500, 0xC77685);
var char:FlxSprite = new FlxSprite().makeGraphic(500, 250, 0xFFA600);

function create()
{
    add(bg);
    char.screenCenter();
    add(char);
    var timer:FlxTimer = new FlxTimer().start(5, function(tmr:FlxTimer){
        MusicBeatState.switchState(new MainMenuState());
    });
}