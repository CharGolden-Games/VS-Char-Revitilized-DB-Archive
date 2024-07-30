package options;

import states.MainMenuState;
import backend.StageData;

class OptionsState extends MusicBeatState
{
	var options:Array<String> = ['Note Colors', 'Controls', 'Adjust Delay and Combo', 'Graphics', 'Visuals and UI', 'Gameplay'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
	public static var onPlayState:Bool = false;
	public static var reOpenSubstate:Bool = false;
	public static var substateToReOpen:String;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Note Colors':
				openSubState(new options.NotesSubState());
			case 'Controls':
				openSubState(new options.ControlsSubState());
			case 'Graphics':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuals and UI':
				openSubState(new options.VisualsUISubState());
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'Adjust Delay and Combo':
				MusicBeatState.switchState(new options.NoteOffsetState());
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	override function create() {
		openfl.Lib.application.window.title = "Friday Night Funkin': VS Char Revitalized | Options | Shop - Nico's Nextbots Remix by ODDBLUE";
		if (PlayState.SONG == null){
		FlxG.sound.playMusic(Paths.music('shop', 'shared'));
		}
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(MainMenuState.randomizeBG());
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.color = 0xfffdc771;
		bg.updateHitbox();

		bg.screenCenter();
		add(bg);

		var RESETSAVE:FlxText = new FlxText(0, 0, 0, 'PRESS R TO RESET YOUR SAVE', 10);
        RESETSAVE.setFormat('vcr.ttf', 10, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        add(RESETSAVE);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true);
			optionText.screenCenter();
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true);
		add(selectorRight);
		trace('IS ON PLAYSTATE? ' + onPlayState);

		changeSelection();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function closeSubState() {
		for (i in 0...ClientPrefs.data.arrowRGB.length) {
			ClientPrefs.data.arrowRGB[i] = ClientPrefs.data.arrowRGB5Key[i];
		}
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	var resetWarningActive:Bool;
    var nEWMessageWindowlmao:FlxSprite;
    var saveResetText:FlxText;
    override function update(elapsed:Float) {
		super.update(elapsed);
		if (reOpenSubstate) {
			switch (substateToReOpen.toLowerCase()) {
			case 'note colors':
				openSubState(new options.NotesSubState());
			case 'controls':
				openSubState(new options.ControlsSubState());
			case 'graphics':
				openSubState(new options.GraphicsSettingsSubState());
			case 'visuals and ui':
				openSubState(new options.VisualsUISubState());
			case 'gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'adjust delay and combo':
				MusicBeatState.switchState(new options.NoteOffsetState());
			}
		}
        if (controls.RESET || FlxG.keys.pressed.R)
            {
                nEWMessageWindowlmao = new FlxSprite().makeGraphic(300,300,0x860000);
                nEWMessageWindowlmao.screenCenter(XY);
                nEWMessageWindowlmao.alpha = 0.75;
                add(nEWMessageWindowlmao);
                saveResetText = new FlxText(nEWMessageWindowlmao.x, nEWMessageWindowlmao.y, nEWMessageWindowlmao.width, 'ARE YOU ABSOLUTELY POSITIVELY SURE YOU WANNA DELETE YOUR SAVE?????
                \nENTER = YES, ESC = NO', 35);
                saveResetText.setFormat('funkin.otf', 35, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
                add(saveResetText);
                resetWarningActive = true;
            }
		if (controls.UI_UP_P && !resetWarningActive) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P && !resetWarningActive) {
			changeSelection(1);
		}

		if (controls.BACK && !resetWarningActive) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			if(onPlayState)
			{
				trace('loading playstate');
				StageData.loadDirectory(PlayState.SONG);
				LoadingState.loadAndSwitchState(new PlayState());
				FlxG.sound.music.volume = 0;
			}
			else {
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				MusicBeatState.switchState(new MainMenuState());
				}
		}
		else if (controls.ACCEPT && !resetWarningActive) openSelectedSubstate(options[curSelected]);
		if (resetWarningActive && controls.ACCEPT) {
            FlxG.save.erase();
            FlxG.resetGame(); // because otherwise it might commit die lmao.
        } else if (resetWarningActive && controls.BACK) {
            saveResetText.destroy();
            nEWMessageWindowlmao.destroy();
            resetWarningActive = false;
        }
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	override function destroy()
	{
		ClientPrefs.loadPrefs();
		super.destroy();
	}
}