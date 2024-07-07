package states.stages;

class White extends BaseStage
{
	var fallenChair:BGSprite;
	override function createPost() {
        //lmao the easiest to make stage, just 2 lines of code as of 5/28/24 but now its more complicated lmao. as of 6/17/24 its simpler
		var whiteLmao:FlxSprite = new FlxSprite(-2500, -1000).makeGraphic(6000, 4000, FlxColor.WHITE);
		addBehindDad(whiteLmao);
		fallenChair = new BGSprite('Fuck You');
		fallenChair.x = 0 - 10;
		fallenChair.y = dad.y;
		fallenChair.visible = false;
		addBehindBF(fallenChair);
	}

	override function beatHit() {
		if (curBeat == 193) {
			fallenChair.visible = true;
		}
	}
}