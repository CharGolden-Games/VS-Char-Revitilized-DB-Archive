package objects;

import backend.GitVer;

// yknow the text in main menu? thats what this is for :3
class VersionShit extends FlxText
{
    var GIT_BRANCH:String = #if IS_DEBUG GitVer.getGitBranch() #else '' #end;
    var GIT_HASH:String = #if IS_DEBUG GitVer.getGitComHash() #else '' #end;
    var GIT_HAS_CHANGES:Bool = #if IS_DEBUG GitVer.getGitHasLocalChanges() #else false #end;

    /**
     * Spawns a text string with Version info
     * @param versionString What version to display
     * @param textString What text goes before the version
     * @param textFont 
     * @param textSize 
     * @param textColor 
     * @param textAlignment 
     * @param textBorderStyle FlxTextBorderStyle
     * @param textBorderColor 
     * @param isGitCommit Whether to show Commit info (debug builds only)
     * @param x 
     * @param y 
     * @param textWidth 
     */
    public function new(versionString:String, textString:String, ?textFont:String, textSize:Int = 8, textWidth:Int, textColor:FlxColor = FlxColor.WHITE, ?textAlignment:FlxTextAlign, ?textBorderStyle:FlxTextBorderStyle, textBorderColor:FlxColor = FlxColor.TRANSPARENT, isGitCommit:Bool = false, x:Float, y:Float)
    {
        super();
        this.x = x;
        this.y = y;
        createText(versionString, textString, textFont, textSize, textColor, textAlignment, textBorderStyle, textBorderColor, isGitCommit, textWidth);
    }

    //setFormat(?Font:String, Size:Int = 8, Color:FlxColor = FlxColor.WHITE, ?Alignment:FlxTextAlign, ?BorderStyle:FlxTextBorderStyle, BorderColor:FlxColor = FlxColor.TRANSPARENT, EmbeddedFont:Bool = true):FlxText

    /**
     * Creates text with variables from VersionShit
     */
    private function createText(versionString:String, textString:String, ?textFont:String, textSize:Int = 8, textColor:FlxColor = FlxColor.WHITE, ?textAlignment:FlxTextAlign, ?textBorderStyle:FlxTextBorderStyle, textBorderColor:FlxColor = FlxColor.TRANSPARENT, isGitCommit:Bool = false, textWidth:Int)
    {
        var gitHasChanges:String = 'Modified: False';
        if (GIT_HAS_CHANGES) gitHasChanges = 'Modified: TRUE';
        var gitText:String = '';
        #if IS_DEBUG if (isGitCommit) gitText ='Branch: $GIT_BRANCH\nCommitHash: $GIT_HASH\n$gitHasChanges'; #end
        text = textString + versionString + gitText;
        fieldWidth = textWidth;
        setFormat(font, textSize, textColor, textAlignment, textBorderStyle, textBorderColor);
        borderQuality = 2;
        borderSize = 2;
    }
}
