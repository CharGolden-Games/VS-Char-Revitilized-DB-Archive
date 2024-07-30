package objects;

import backend.GitVer;

// yknow the text in main menu? thats what this is for :3
class VersionShit extends FlxText
{
    var GIT_BRANCH:String = GitVer.getGitBranch();
    var GIT_HASH:String = GitVer.getGitComHash();

    var versionString:String = '';
    var textString:String = '';
    var textWidth:Int = 0;
    var textSize:Int = 5;
    var textFont:String= '';
    var textColor:FlxColor = 0x000000;
    var isGitCommit:Bool = false ;

    /**
     * Spawns a text string with Version info
     * @param versionString The actual version to use
     * @param textString the text before the version string
     * @param textWidth how wide the text is
     * @param textSize how big the text is
     * @param textFont what font to use if any
     * @param textColor The color of the Text
     * @param isGitCommit Whether to show GitCommit Info
     * @param xPos The X Position
     * @param yPos The Y Position
     */
    public function new(
        versionString:String,
        textString:String,
        textWidth:Int,
        textSize:Int,
        textFont:String,
        textColor:FlxColor,
        isGitCommit:Bool,
        xPos:Int,
        yPos:Int
        )
    {
        super();
        this.versionString = versionString;
        this.textString = textString;
        this.textWidth = textWidth;
        this.textSize = textSize;
        this.textFont = textFont;
        this.textColor = textColor;
        this.isGitCommit = isGitCommit;
        this.x = xPos;
        this.y = yPos;
        createText();
    }
    /**
     * Creates text with variables from VersionShit
     */
    private function createText()
    {
        var gitHasChanges:String = '';
        var gitText:String = '';
        if (isGitCommit) gitText = #if IS_DEBUG ' {Branch: $GIT_BRANCH | CommitHash: $GIT_HASH}' #else '{Branch: $GIT_BRANCH}' #end;
        text = textString + versionString + gitText;
        fieldWidth = textWidth;
        size = textSize;
        font = textFont;
        color = textColor;
    }
}
