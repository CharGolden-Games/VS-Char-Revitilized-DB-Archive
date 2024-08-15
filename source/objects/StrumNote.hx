package objects;

import shaders.RGBPalette;
import shaders.RGBPalette.RGBShaderReference;
import backend.TracePassThrough as CustomTrace;
import states.PlayState;
import backend.ReferenceStrings;

using StringTools;

class StrumNote extends FlxSprite
{
	public var rgbShader:RGBShaderReference;
	public var resetAnim:Float = 0;
	private var noteData:Int = 0;
	public var direction:Float = 90;//plan on doing scroll directions soon -bb
	public var downScroll:Bool = false;//plan on doing scroll directions soon -bb
	public var sustainReduce:Bool = true;
	private var player:Int;
	public static var is5Key:Bool = false;
	
	public var texture(default, set):String = null;
	private function set_texture(value:String):String {
		if(texture != value) {
			texture = value;
			reloadNote();
		}
		return value;
	}

	public var useRGBShader:Bool = true;
	public function new(x:Float, y:Float, leData:Int, player:Int) {
		rgbShader = new RGBShaderReference(this, Note.initializeGlobalRGBShader(leData));
		rgbShader.enabled = false;
		if(PlayState.SONG != null && PlayState.SONG.disableNoteRGB) useRGBShader = false;
		
		var arr:Array<FlxColor> = !is5Key ? ClientPrefs.data.arrowRGB[leData] : ClientPrefs.data.arrowRGB5Key[leData];
		if(PlayState.isPixelStage) arr = ClientPrefs.data.arrowRGBPixel[leData];
		
		if(leData <= arr.length)
		{
			@:bypassAccessor
			{
				rgbShader.r = arr[0];
				rgbShader.g = arr[1];
				rgbShader.b = arr[2];
			}
		}

		noteData = leData;
		this.player = player;
		this.noteData = leData;
		super(x, y);

		var skin:String = null;
		if(PlayState.SONG != null && PlayState.SONG.arrowSkin != null && PlayState.SONG.arrowSkin.length > 1) skin = PlayState.SONG.arrowSkin;
		else skin = Note.defaultNoteSkin;

		var customSkin:String = skin + Note.getNoteSkinPostfix();
			if(Paths.fileExists('images/$customSkin.png', IMAGE)) skin = customSkin;
		texture = skin; //Load texture and anims
		scrollFactor.set();
	}

	public function reloadNote()
	{
		var lastAnim:String = null;
		if(animation.curAnim != null) lastAnim = animation.curAnim.name;

		if(PlayState.isPixelStage)
		{
			loadGraphic(Paths.image('pixelUI/' + texture));
			width = width / 4;
			height = height / 5;
			loadGraphic(Paths.image('pixelUI/' + texture), true, Math.floor(width), Math.floor(height));

			antialiasing = false;
			setGraphicSize(Std.int(width * PlayState.daPixelZoom));

			animation.add('green', [6]);
			animation.add('red', [7]);
			animation.add('blue', [5]);
			animation.add('purple', [4]);
			switch (Math.abs(noteData) % 4)
			{
				case 0:
					animation.add('static', [0]);
					animation.add('pressed', [4, 8], 12, false);
					animation.add('confirm', [12, 16], 24, false);
				case 1:
					animation.add('static', [1]);
					animation.add('pressed', [5, 9], 12, false);
					animation.add('confirm', [13, 17], 24, false);
				case 2:
					animation.add('static', [2]);
					animation.add('pressed', [6, 10], 12, false);
					animation.add('confirm', [14, 18], 12, false);
				case 3:
					animation.add('static', [3]);
					animation.add('pressed', [7, 11], 12, false);
					animation.add('confirm', [15, 19], 24, false);
			}
		}
		else if (!is5Key) {
			frames = Paths.getSparrowAtlas(texture);
			animation.addByPrefix('green', 'arrowUP');
			animation.addByPrefix('blue', 'arrowDOWN');
			animation.addByPrefix('purple', 'arrowLEFT');
			animation.addByPrefix('red', 'arrowRIGHT');

			antialiasing = ClientPrefs.data.antialiasing;
			setGraphicSize(Std.int(width * 0.7));

			switch (Math.abs(noteData) % 4)
			{
				case 0:
					animation.addByPrefix('static', 'arrowLEFT');
					animation.addByPrefix('pressed', 'left press', 24, false);
					animation.addByPrefix('confirm', 'left confirm', 24, false);
				case 1:
					animation.addByPrefix('static', 'arrowDOWN');
					animation.addByPrefix('pressed', 'down press', 24, false);
					animation.addByPrefix('confirm', 'down confirm', 24, false);
				case 2:
					animation.addByPrefix('static', 'arrowUP');
					animation.addByPrefix('pressed', 'up press', 24, false);
					animation.addByPrefix('confirm', 'up confirm', 24, false);
				case 3:
					animation.addByPrefix('static', 'arrowRIGHT');
					animation.addByPrefix('pressed', 'right press', 24, false);
					animation.addByPrefix('confirm', 'right confirm', 24, false);
			}
		} else if (is5Key)
		{
			frames = Paths.getSparrowAtlas(texture);
			animation.addByPrefix('green', 'arrowUP');
			animation.addByPrefix('blue', 'arrowDOWN');
			animation.addByPrefix('purple', 'arrowLEFT');
			animation.addByPrefix('red', 'arrowRIGHT');
			animation.addByPrefix('ring', 'arrowRING');

			antialiasing = ClientPrefs.data.antialiasing;
			setGraphicSize(Std.int(width * 0.7));

			switch (Math.abs(noteData) % 5)
			{
				case 0:
					animation.addByPrefix('static', 'arrowLEFT');
					animation.addByPrefix('pressed', 'left press', 24, false);
					animation.addByPrefix('confirm', 'left confirm', 24, false);
				case 1:
					animation.addByPrefix('static', 'arrowDOWN');
					animation.addByPrefix('pressed', 'down press', 24, false);
					animation.addByPrefix('confirm', 'down confirm', 24, false);
				case 2:
					animation.addByPrefix('static', 'arrowUP');
					animation.addByPrefix('pressed', 'up press', 24, false);
					animation.addByPrefix('confirm', 'up confirm', 24, false);
				case 3:
					animation.addByPrefix('static', 'arrowRIGHT');
					animation.addByPrefix('pressed', 'right press', 24, false);
					animation.addByPrefix('confirm', 'right confirm', 24, false);
				case 4:
					animation.addByPrefix('static', 'arrowRING');
					animation.addByPrefix('pressed', 'ring press', 24, false);
					animation.addByPrefix('confirm', 'ring confirm', 24, false);
			}
		}
		updateHitbox();
		if (!animation.exists('static')) {
			if (PlayState.instance != null) {
				PlayState.fixRingOffset = true;
				PlayState.noteSkintoFix = StringTools.replace(texture, 'noteSkins/', '');
				var traceThing:String = StringTools.replace(texture, 'noteSkins/', '');
				trace('final texture output to PlayState: $traceThing');
			}
			switch(Math.abs(noteData) % 5) {
				case 0:
					texture = 'noteSkins/NOTE_assets';
					frames = Paths.getSparrowAtlas(texture);
					animation.addByPrefix('purple', 'arrowLEFT');
					animation.addByPrefix('static', 'arrowLEFT');
					animation.addByPrefix('pressed', 'left press', 24, false);
					animation.addByPrefix('confirm', 'left confirm', 24, false);
				case 1:
					texture = 'noteSkins/NOTE_assets';
					frames = Paths.getSparrowAtlas(texture);
					animation.addByPrefix('blue', 'arrowDOWN');
					animation.addByPrefix('static', 'arrowDOWN');
					animation.addByPrefix('pressed', 'down press', 24, false);
					animation.addByPrefix('confirm', 'down confirm', 24, false);
				case 2:
					texture = 'noteSkins/NOTE_assets';
					frames = Paths.getSparrowAtlas(texture);
					animation.addByPrefix('green', 'arrowUP');
					animation.addByPrefix('static', 'arrowUP');
					animation.addByPrefix('pressed', 'up press', 24, false);
					animation.addByPrefix('confirm', 'up confirm', 24, false);
				case 3:
					texture = 'noteSkins/NOTE_assets';
					frames = Paths.getSparrowAtlas(texture);
					animation.addByPrefix('red', 'arrowRIGHT');
					animation.addByPrefix('static', 'arrowRIGHT');
					animation.addByPrefix('pressed', 'right press', 24, false);
					animation.addByPrefix('confirm', 'right confirm', 24, false);
				case 4:
					texture = 'noteSkins/ring/ring';
					frames = Paths.getSparrowAtlas(texture);
					animation.addByPrefix('ring', 'arrowRING');
					animation.addByPrefix('static', 'arrowRING');
					animation.addByPrefix('pressed', 'ring press', 24, false);
					animation.addByPrefix('confirm', 'ring confirm', 24, false);
			}
			FlxG.log.warn('SHIT THAT "Static($direction)" DOESNT EXIST. the texture is: $texture, using default!!!');
		}
		if(useRGBShader && is5Key) {
		switch(Math.abs(noteData) % 5) {
			case 4: // for some reason i have to manually initialize the RGB shader for notes after the originals
				var ringColorArray:Array<FlxColor> = ClientPrefs.data.arrowRGB5Key[4];
				rgbShader.r = (ringColorArray[0]);
				rgbShader.g = (ringColorArray[1]);
				rgbShader.b = (ringColorArray[2]);
			}
		}
		if (PlayState.instance != null) {
			var formattedSong:String = Paths.formatToSongPath(PlayState.SONG.song.toLowerCase()).trim();
			if (formattedSong == 'high-ground' || formattedSong == 'high-grounder' || formattedSong == 'high-ground-old') {
						rgbShader.b = 0xFFFFFF;
						if (player == 1) {
							switch(Math.abs(noteData) % 4) {
								case 0:
									rgbShader.r = ReferenceStrings.high_groundArrowRGB[0][0];
									rgbShader.g = ReferenceStrings.high_groundArrowRGB[0][2];
								case 1:
									rgbShader.r = ReferenceStrings.high_groundArrowRGB[1][0];
									rgbShader.g = ReferenceStrings.high_groundArrowRGB[1][2];
								case 2:
									rgbShader.r = ReferenceStrings.high_groundArrowRGB[2][0];
									rgbShader.g = ReferenceStrings.high_groundArrowRGB[2][2];
								case 3:
								rgbShader.r = ReferenceStrings.high_groundArrowRGB[3][0];
								rgbShader.g = ReferenceStrings.high_groundArrowRGB[3][2];
						}
					} else {
						switch(Math.abs(noteData) % 4) {
							case 0:
								rgbShader.r = ReferenceStrings.high_groundArrowRGB[4][0];
								rgbShader.g = ReferenceStrings.high_groundArrowRGB[4][2];
							case 1:
								rgbShader.r = ReferenceStrings.high_groundArrowRGB[5][0];
								rgbShader.g = ReferenceStrings.high_groundArrowRGB[5][2];
							case 2:
								rgbShader.r = ReferenceStrings.high_groundArrowRGB[6][0];
								rgbShader.g = ReferenceStrings.high_groundArrowRGB[6][2];
							case 3:
								rgbShader.r = ReferenceStrings.high_groundArrowRGB[7][0];
								rgbShader.g = ReferenceStrings.high_groundArrowRGB[7][2];
					}
			}

	}
}
		if(lastAnim != null)
		{
			playAnim(lastAnim, true);
		}
}

	public function postAddedToGroup() {
		playAnim('static');
		x += Note.swagWidth * noteData;
		x += 50;
		x += ((FlxG.width / 2) * player);
		ID = noteData;
	}

	override function update(elapsed:Float) {
		// old reset anim shit
		if(resetAnim > 0) {
			resetAnim -= elapsed;
			if(resetAnim <= 0) {
				playAnim('static');
				resetAnim = 0;
			}
		}
		super.update(elapsed);
	}

	public function playAnim(anim:String, ?force:Bool = false) {
		animation.play(anim, force);
		if(animation.curAnim != null)
		{
			centerOffsets();
			centerOrigin();
		}
		if(useRGBShader) rgbShader.enabled = (animation.curAnim != null && animation.curAnim.name != 'static');
	}
}
