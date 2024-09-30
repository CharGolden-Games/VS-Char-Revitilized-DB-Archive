package states.stages;

//White stage copy so i dont get an error
class Chartt extends BaseStage
{
    override function createPost() {

        super.createPost();

        var BG:FlxSprite = new FlxSprite().makeGraphic(10000, 10000, FlxColor.WHITE);
        BG.x = -5000;
        BG.y = -5000;
        addBehindDad(BG);
    }
}