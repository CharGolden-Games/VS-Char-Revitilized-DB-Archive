package objects;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset as SpriteAsset;
import backend.TracePassThrough as CustomTrace;

/**
 * A Class so that i can track this sprite to another one
 */
class FreeplayBacker extends FlxSprite
{
    public var sprTracker:FlxSprite;
    public function new(sprite:SpriteAsset, sprWidth:Int = 0, sprHeight:Int = 0) {
        super();
        addBacker(sprite, sprWidth, sprHeight);
    }
    
    public function addBacker(sprite:SpriteAsset, sprWidth:Int, sprHeight:Int)
    {
        if (sprWidth == 0) {
            sprWidth = 50;
        } if (sprHeight == 0) {
            sprHeight = 50;
        }
        loadGraphic(sprite);
        setGraphicSize(sprWidth, sprHeight);
        updateHitbox();
    }

    public function changeSize(inputWidth:Int = 0, inputHeight:Int = 0) {
        if (inputWidth != 0 && inputHeight != 0){
        setGraphicSize(inputWidth, inputHeight);
        updateHitbox();
        } else {
            if (inputWidth == 0 && inputHeight == 0)
                {
                    CustomTrace.trace('MISSING VALUES: inputWidth and inputHeight!', 'err');
                } else if (inputWidth == 0) {
                    CustomTrace.trace('inputWidth = 0!', 'err');
                } else if (inputHeight == 0) {
                    CustomTrace.trace('inputHeight = 0!', 'err');
                }
        }
    }

    override function update(elapsed:Float) {
        if (sprTracker != null) 
            {
                setPosition(sprTracker.x - 15, sprTracker.y + 5);
            } else {
                setPosition(0,0);
            }
    }
}