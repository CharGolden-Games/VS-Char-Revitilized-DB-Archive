package states.stages;

class White extends BaseStage
{
	var fallenChair:BGSprite;
	override function create() {
		var whiteLmao:FlxSprite = new FlxSprite(-2500, -1000).makeGraphic(6000, 4000, FlxColor.WHITE);
		add(whiteLmao);
	}
	override function createPost() {
        //lmao the easiest to make stage, just 2 lines of code as of 5/28/24 but now its more complicated lmao. as of 6/17/24 its simpler
		fallenChair = new BGSprite('Fuck_you');
		fallenChair.x = boyfriend.x;
		fallenChair.y = dad.y;
		fallenChair.visible = false;
		addBehindBF(fallenChair);
	}

	override function beatHit() {
		if (PlayState.SONG != null && Paths.formatToSongPath(PlayState.SONG.song.toLowerCase()).trim() == 'high-ground-old') {
			if (curBeat == 193) {
				fallenChair.visible = true;
			}
		}
	}
}