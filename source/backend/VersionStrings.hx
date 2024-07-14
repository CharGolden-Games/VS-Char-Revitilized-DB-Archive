package backend;

class VersionStrings
{
    public static var psychEngineVersion:String = " Psych Engine v0.7.1h | Funkin' 0.2.8"; // Just cause. its fun to tell people im using an older version of psych, with some things from 0.7.3 i backported
	public static var charEngineVersion:String = '0.10 | 5 Key Implementation!'; // Used for making sure im not an idiot, and properly update the engine version lmao.
	public static var vsCharVersion:String = 'Alpha 1.1.6'; // Used for updating
	public static var splitString:Array<String>;

	public static function versionNumOnly(verToGrab:String):String
	{
		switch (Paths.formatToSongPath(verToGrab.toLowerCase()))
		{
			default:
				splitString = ['null'];
				return 'null';
			case 'psych':
				splitString = psychEngineVersion.split(' | ');
				return splitString[0];
			case 'funkin':
				splitString = psychEngineVersion.split(' | ');
				return splitString[1];
			case 'vs-char':
				splitString = vsCharVersion.split(' | ');
				return splitString[0];
			case 'char-engine':
				splitString = charEngineVersion.split(' | ');
				return splitString[0];
		}
	}
}