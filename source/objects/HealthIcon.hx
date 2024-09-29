package objects;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	private var isPlayer:Bool = false;
	private var char:String = '';

	public function new(char:String = 'face', isPlayer:Bool = false, ?allowGPU:Bool = true)
	{
		super();
		this.isPlayer = isPlayer;
		changeIcon(char, allowGPU);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 12, sprTracker.y - 30);
	}

	private var iconOffsets:Array<Float> = [0, 0, 0];
	public function changeIcon(char:String, ?allowGPU:Bool = true) {
		if(this.char != char) {
			var name:String = 'icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			
			var graphic = Paths.image(name, allowGPU);
			var numOfFrames:Int = Math.round(graphic.width / graphic.height);
			//trace('Got $numOfFrames for frame count!');
			loadGraphic(graphic, true, Math.floor(graphic.width / numOfFrames), Math.floor(graphic.height));
			var frameArray:Array<Int> = [];
			switch (numOfFrames) {
				case 1: //Why.
					frameArray = [0];
					iconOffsets[0] = width - 150;
				case 2:
					frameArray = [0, 1];
					iconOffsets[0] = (width - 150) / 2;
					iconOffsets[1] = (height - 150) / 2;
				default:
					frameArray = [0, 1, 2]; // TODO: Make cases above 3 look for animation xml's.
					for (i in 0...3) {
						iconOffsets[i] = (width - 150) / numOfFrames;
					}
			}
			updateHitbox();

			animation.add(char, frameArray, 0, false, isPlayer);
			animation.play(char);
			this.char = char;

			if(char.endsWith('-pixel'))
				antialiasing = false;
			else
				antialiasing = ClientPrefs.data.antialiasing;
		}
	}

	public var autoAdjustOffset:Bool = true;
	override function updateHitbox()
	{
		super.updateHitbox();
		if(autoAdjustOffset)
		{
			offset.x = iconOffsets[0];
			offset.y = iconOffsets[1];
		}
	}

	public function getCharacter():String {
		return char;
	}
}
