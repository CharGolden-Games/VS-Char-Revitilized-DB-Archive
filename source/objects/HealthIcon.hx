package objects;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var hasAnimatedIcon:Bool = false;
	private var normalIcon:String = ''; 
	private var losingIcon:String = ''; 
	private var winningIcon:String = '';
	private var char:String = '';
	private var charOldString:String = '';
	private var startingChar:String = '';

	/**
	 * @param char Name of the icon
	 * @param isPlayer Should this icon's X be flipped
	 * @param hasAnimatedIcon Is this icon animated?
	 * @param normalIcon What is the idle anim called
	 * @param losingIcon What is the losing anim called
	 * @param winningIcon What is the winning anim called
	 */
	public function new(char:String = 'bf', 
						isPlayer:Bool = false, 
						hasAnimatedIcon:Bool = false, 
						// animated icon shit.
						normalIcon:String = '', 
						losingIcon:String = '', 
						winningIcon:String = '')
	{
		super();
		var ranInt = FlxG.random.int(0,1);
		var ranString:String = '';
		switch (ranInt) {
			case 0:
				ranString = 'old';
			case 1:
				ranString = 'og';
		}
		if (char != 'char') charOldString = char + '-old'; else charOldString = char + ranString;
		startingChar = char;
		this.isPlayer = isPlayer;
		this.hasAnimatedIcon = hasAnimatedIcon;
		this.normalIcon = normalIcon;
		this.losingIcon = losingIcon;
		this.winningIcon = winningIcon;
		changeIcon(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}

	public function swapOldIcon() {
		
		if(!isOldIcon) {
			changeIcon(charOldString);
			//trace('New Icon: $charOldString');
			}
		else {
			changeIcon(startingChar);
			//trace('New Icon: $char');
		}
			isOldIcon = !isOldIcon;
	}

	public function updateInitialChar() { // for the swap character event.
		startingChar = this.char;
	}

	private var iconOffsets:Array<Float> = [0, 0, 0];
	public function changeIcon(char:String) {
		if(this.char != char) {
			var name:String = 'icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			var file:Dynamic = Paths.image(name);

			loadGraphic(file); //Load stupidly first for getting the file size
			var amountOfFrames:Int = Math.round(width / height);
			//trace('result of amount Of Frames for $name: $amountOfFrames');
			var width2 = width;
			loadGraphic(file, true, Math.floor(width / amountOfFrames), Math.floor(height)); // actually load it now.
			var framesArray:Array<Int> = [];
			for (i in 0...amountOfFrames)
			{
				iconOffsets[i] = (width - 150) / amountOfFrames;
				framesArray.insert(Std.int(1 * i), i); // theoretically it'll do this, 1 * 0 = 0, 1 * 1 = 1, etc.
			}
			//trace('the frames array is: $framesArray');
			
			updateHitbox();
			if (framesArray.length < 9){
			animation.add(char, framesArray, 0, false, isPlayer);
			animation.play(char);
			} else {
				animation.add(char, [0,3,6], 0, false, isPlayer); // freeplay menu and other things
				animation.add('idle', [0,1,2], 12, true, isPlayer);
				animation.add('losing', [3,4,5], 12, true, isPlayer);
				animation.add('winning', [6,7,8], 12, true, isPlayer);
			}
			this.char = char;

			if(char.endsWith('-pixel'))
				antialiasing = false;
			else
				antialiasing = ClientPrefs.data.antialiasing;
		}
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}

	public function getCharacter():String {
		return char;
	}
}
