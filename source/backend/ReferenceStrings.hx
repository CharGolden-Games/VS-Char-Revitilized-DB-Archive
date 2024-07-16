package backend;
/**
 * a class that helps turn multiple statements into one, while also holding static variables referenced in multiple places (similar to Funkin 0.4's Constants class)
 */
class ReferenceStrings
{
    /**
     * Just cause. its fun to tell people im using an older version of psych, with some things from 0.7.3 i backported
     */
    public static var psychEngineVersion:String = " Psych Engine v0.7.1h | Funkin' 0.2.8";

	/**
	 * Used for numVerOnly
	 */
	 public static var psychNumVerOnly:String = "0.7.1h | 0.2.8";

	/**
	 * Used for making sure im not an idiot, and properly update the engine version lmao.
	 */
	public static var charEngineVersion:String = '0.10 | 5 Key Implementation!';

	/**
	 * Used for updating
	 */
	public static var vsCharVersion:String = 'Alpha 1.1.6';

	/**
	 * You can see its use in the function "versionNumOnly"
	 */
	public static var splitString:Array<String>;

	/**
	 * so that i can reduce it to one function lmao.
	 * @param _ So we're fine as long as nobody teleports any bread  
	 * @param _ Question? 
	 * @param _ Whats your question soldier?
	 * @param _ I teleported bread 
	 * @param _ What?
	 * @param _ You told me to 
	 * @param _ How. Much.
	 * @param _ I have done nothing but teleport bread for 3 days
	 */
	public static var vsCharSongs:Array<String> = [ // why isnt pico 2 here? i don't own it lmao.
		'triple-trouble',
		'high-ground', // the og
		'high-grounder', // the new version
		'higher-ground', // planned mix
		'junkyard', // planned cover
		'defeat-odd-mix',
		'defeat-char-mix',
		'tutorial' // planned mix
	];

	public static var songsThatForce5Key:Array<String> = [
		'triple-trouble'
	];

	/**
	 * Returns only the number of a given version as long as it fits this template with an exception, 
	 * "Version Number | Text" (you must seperate it by " | "), If it is the Funkin' version, 
	 * the psychNumVerOnly string must go "Psych Ver | Funkin' Ver" if you for some fuckin reason change it lmao
	 * @param verToGrab The version you wish to grab only the number of, For example psych returns "0.7.1h". 
	 * @param ACCEPTED_INPUT "psych", "funkin", "vs-char", "char-engine".
	 * @return String
	 */
	public static function versionNumOnly(verToGrab:String):String
	{
		switch (Paths.formatToSongPath(verToGrab.toLowerCase()))
		{
			default:
				splitString = ['null'];
				return 'null';
			case 'psych':
				splitString = psychNumVerOnly.split(' | ');
				return splitString[0];
			case 'funkin':
				splitString = psychNumVerOnly.split(' | ');
				return splitString[1];
			case 'vs-char':
				splitString = vsCharVersion.split(' | ');
				return splitString[0];
			case 'char-engine':
				splitString = charEngineVersion.split(' | ');
				return splitString[0];
		}
	}

	/**
	 * Gets the cached version text file from a path
	 * @param filePath the path to the cached version file from assets "`folder`/`filename`"
	 * @return String
	 */
	public static function getCachedVersion(filePath:String = "VersionCache/engineVersionCache"):String
	{
		var cachedVersion:String = sys.io.File.getContent('./assets/$filePath.txt');
		return cachedVersion;
	}
}