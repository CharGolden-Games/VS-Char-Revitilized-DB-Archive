package objects;

import backend.GitVer;

// yknow the text in main menu? thats what this is for :3
class VersionShit extends FlxText
{
    var GIT_BRANCH:String = GitVer.getGitBranch();
    var GIT_HASH:String = GitVer.getGitComHash();
    var GIT_HASCHANGED:Bool = GitVer.getGitHasLocalChanges();

    var versionString:String; // The actual version to use
    var textString:String; // the text before the version string
    var textWidth:Int; // how wide the text is
    var textSize:Int; // how big the text is
    var textFont:String; // what font to use if any
    var textColor:FlxColor;
    var isGitCommit:Bool;
    var xPos:Int;
    var yPos:Int;

    public function new(
        versionString:String, // The actual version to use
        textString:String, // the text before the version string
        textWidth:Int, // how wide the text is
        textSize:Int, // how big the text is
        textFont:String, // what font to use if any
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
        this.xPos = xPos;
        this.yPos = yPos;
        createText();
    }

    function createText()
    {
        var gitHasChanges:String = '';
        var gitText:String = '';
        if (GIT_HASCHANGED) gitHasChanges = ': MODIFIED';
        if (isGitCommit) gitText = #if IS_DEBUG ' {Branch: $GIT_BRANCH | CommitHash: $GIT_HASH $gitHasChanges }' #else '{Branch: $GIT_BRANCH}' #end;
        text = textString + versionString + gitText;
        fieldWidth = textWidth;
        size = textSize;
        font = textFont;
        color = textColor;
        x = xPos;
        y = yPos;
    }
}
