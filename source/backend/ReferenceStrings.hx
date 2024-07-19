package backend;

import sys.io.File;
import sys.FileSystem;
import backend.StageData;

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

	public static var vsCharLegacySongs:Array<String> = [
		'free-movies',
		'3-problems',
		'slow-ass-mf',
		'walk-bitch',
		'mentally-deranged',
		'infinite',
		'shenanigans'
	];

	public static var assetPathsToCache:Array<String> = ['null'];

	public static var songsThatForce5Key:Array<String> = [
		'triple-trouble',
		'3-problems'
	];

	/**
	 * Returns only the number of a given version as long as it fits this template with an exception, | 
	 * "Version Number | Text" (you must seperate it by " | "), If it is the Funkin' version, | 
	 * the psychNumVerOnly string must go "Psych Ver | Funkin' Ver" if you for some fuckin reason change it lmao
	 * @param verToGrab The version you wish to grab only the number of, For example psych returns "0.7.1h". 
	 * @param ACCEPTED_INPUT "psych", "funkin", "vs-char", "char-engine".
	 * @return String
	 */
	inline public static function versionNumOnly(verToGrab:String):String
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
	inline public static function getCachedVersion(filePath:String = "VersionCache/engineVersionCache"):String
	{
		var cachedVersion:String = sys.io.File.getContent('./assets/$filePath.txt');
		return cachedVersion;
	}

	public static var totalAssetsToCache:Int = 0;
	inline public static function getAssetsToCache():Array<String>
	{
		assetPathsToCache = [];
		var pos:Int = 0;
		var path:String = 'assets/shared/images/characters/';
		for (file in FileSystem.readDirectory(path)){
			pos++;
			if (StringTools.endsWith(file, '.png')) {
				//trace('Pushing $path$file at pos $pos to assetPathsToCache');
				if(FileSystem.exists(file)) assetPathsToCache.push(Std.string(path + file));
			}
		}
		path = 'assets/stages/';
		var stagePath:String = 'assets/images/backups/';
		for (file in FileSystem.readDirectory(path)) {
			if (!sys.FileSystem.isDirectory(file)) {
				file = StringTools.replace(file, '.json', '');
				var lastStagePath:String = 'assets/';
				var stage:StageFile = StageData.getStageFile(file);
				if (stage != null) {
					if (stage.directory.trim() != '') stagePath = 'assets/' + stage.directory + '/images/';
				}
					if (FileSystem.exists(stagePath)) {
					if (stagePath != lastStagePath) {
					for (file in FileSystem.readDirectory(stagePath))
					{
							if (!sys.FileSystem.isDirectory(file)){
								pos++;
								if (StringTools.endsWith(file, '.png')) {
									//trace('Pushing $stagePath$file at pos $pos to assetPathsToCache');
									if(FileSystem.exists(file)) assetPathsToCache.push(Std.string(path + file));
								}
							} else {
								stagePath = stagePath + file + '/';
								for (file in FileSystem.readDirectory(stagePath))
								{
								if (!sys.FileSystem.isDirectory(file)){
										pos++;
										if (StringTools.endsWith(file, '.png')) {
										//trace('Pushing $stagePath$file at pos $pos to assetPathsToCache');
										if(FileSystem.exists(file)) assetPathsToCache.push(Std.string(path + file));
										}
								} else {
									pos++;
									trace('$stagePath$file at pos $pos is 2 Subdirectories deep! not continuing.');
								}
							}
						}
						if (lastStagePath != stagePath)
						lastStagePath = stagePath;
					}
					} else {
						trace('DUPLICATE PATH');
					}
				}
			}
		}
		#if MODS_ALLOWED
		var modFolders:Array<String> = [];
		for (mod in Mods.getModDirectories())
		{
			modFolders.push(Paths.mods(mod + '/'));
		}
		modFolders.push('mods/');
		//trace(modFolders);
		for (folder in modFolders)
		{
			path = folder + 'images/characters/';
			if (FileSystem.exists(path)){
				for (file in FileSystem.readDirectory(path)){
					pos++;
					if (StringTools.endsWith(file, '.png')) {
						//trace('Pushing $path$file at pos $pos to assetPathsToCache');
						if(FileSystem.exists(file)) assetPathsToCache.push(Std.string(path + file));
					}
				}
			}
		}
		#end
		totalAssetsToCache = pos;
		return assetPathsToCache;
	}
}