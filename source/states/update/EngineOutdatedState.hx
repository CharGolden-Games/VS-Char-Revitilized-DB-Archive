package states.update;

class EngineOutdatedState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		trace("Showed the Outdated Message woo!");
		// FlxG.sound.music.volume = 0; 
		FlxG.sound.music.stop(); // better solution???
		FlxG.sound.play(Paths.sound('UpdateMenuEnter'));
		super.create();

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBG/Error'));
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"Hey! this Engine is outta DATE!!! \n
			(" + MainMenuState.charEngineVersion.trim() + "),\n
			Its now at version " + TitleState.engineUpdateVersion.trim() + "!
			\nThere might be some features missing from this build!\nPress Enter/Esc to continue.",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			if (controls.ACCEPT) {
				leftState = true;
				trace("Skipped.");
			}
			else if(controls.BACK) {
				leftState = true;
				trace("Skipped.");
			}

			if(leftState)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new MainMenuState());
				FlxG.sound.music.volume = 1;
				trace("Back to the menus!");
					}
				});
			}
		}
		super.update(elapsed);
	}
}
