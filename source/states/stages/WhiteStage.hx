package states.stages;

class WhiteStage extends BaseStage {
    override function createPost() {

        super.createPost();

        var BG:FlxSprite = new FlxSprite().makeGraphic(10000, 10000, FlxColor.WHITE); // Pretty simple stage really. havent added the chair but yknow.
        BG.x = -5000;
        BG.y = -5000;
        addBehindDad(BG);
    }
}