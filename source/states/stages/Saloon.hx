package states.stages;

import states.stages.objects.*;

class Saloon extends BaseStage
{
    var path:String = 'stages/SALOON/';
    var bgCharPath:String = 'bgchars/';
    var saloonBG:BGSprite;
    var tablesLmao:BGSprite;
    var sam:BGSprite;
    var noobley:BGSprite; 
    var desa:BGSprite;
    var mcbf:BGSprite; // dont forget to make these a bopper object when i finish the sprites!
    var odd:BGSprite;
    var anny:BGSprite;
    override function create() {
        saloonBG = new BGSprite(path + 'Saloon_BG', 0, 0);

        tablesLmao = new BGSprite(path + 'TablesLmao', 0, 0);

        sam  = new BGSprite(bgCharPath + 'Sam', 0, 0);

        noobley  = new BGSprite(bgCharPath + 'Noobley', 0, 0);

        desa  = new BGSprite(bgCharPath + 'Desa', 0, 0);

        mcbf  = new BGSprite(bgCharPath + 'MCBF', 0, 0);

        odd  = new BGSprite(bgCharPath + 'Odd', 0, 0);

        anny = new BGSprite(bgCharPath + 'Anny', 0, 0);
        anny.frames = Paths.getSparrowAtlas('mainstory/' + bgCharPath + 'Anny', 'week_assets');
        anny.animation.addByPrefix('Idle', 'Idle');

        add(saloonBG);
        add(tablesLmao);
        add(sam);
        add(noobley);
        add(desa);
        add(mcbf);
        add(odd);
    }

    override function createPost() {
        add(anny);
    }
}