// why am i 3 stages one stage file? because.
package states.stages;

class CharSus extends BaseStage
{
	var defeatBasicBG:BGSprite;
	var LETTHEBODIESHITTHEFLOOR:BGSprite;
	var yoAssIsGrass:BGSprite;

	override function create()
		{
			

			defeatBasicBG = new BGSprite('basicBG', -650, -400, 0.5, 0.5);
			defeatBasicBG.setGraphicSize(Std.int(defeatBasicBG.width * 1.75));
			defeatBasicBG.updateHitbox();
					
			LETTHEBODIESHITTHEFLOOR = new BGSprite('bgBodies', -650, -1300, 0.8, 0.8);
			LETTHEBODIESHITTHEFLOOR.setGraphicSize(Std.int(LETTHEBODIESHITTHEFLOOR.width * 1.75));
			LETTHEBODIESHITTHEFLOOR.updateHitbox();
					
			yoAssIsGrass = new BGSprite('fgBodies', -650, 120);
			yoAssIsGrass.setGraphicSize(Std.int(yoAssIsGrass.width * 1.75));
			yoAssIsGrass.updateHitbox();

			add(defeatBasicBG);
			add(LETTHEBODIESHITTHEFLOOR);
		}

        override function createPost()
            {
                add(yoAssIsGrass);
            }

		
}