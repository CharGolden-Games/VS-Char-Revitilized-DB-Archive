package backend;

import sys.io.File;
import sys.FileSystem;
import backend.StageData;

using StringTools;

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
	 */
	public static var vsCharSongs:Array<String> = [ // why isnt pico 2 here? i don't own it lmao.
	// SORTING TIME GO!
		// -- Main Songs --
		'tutorial', 			// planned mix
		'saloon-trouble', 		// planned song
		'conflicting-views', 	// planned song
		'ambush',	 			// planned song
		// -- Bonus --
		'high-ground', 			// The NEW version
		'high-grounder', 		// the old new version
		'blubber', 				// planned mix
		'defeat-char-mix',		// Defeat ODD Mix old
		'defeat-odd-mix',		// Defeat ODD Mix v2
		// -- Covers --
		'triple-trouble', 		// The Cover that started it all.
		'junkyard', 			// planned cover
		// -- Secret --
		'origins', 				// Ft. Igni?
		'obligatory-bonus-song' // Ft. Char and Trevor
	];

	/**
	 * This Array contains the names of every old song i plan to add back into the mod at some point, with a desc in comments of where it'll go.
	 */
	public static var vsCharLegacySongs:Array<String> = [
		'free-movies-free', // Iason Mason Cover - Part of the Legacy Expansion
		'3-problems', 		// Triple Trouble OG - Part of the Legacy Expansion
		'slow', 			// Too Slow Char Cover - Part of the Legacy Expansion
		'you-can-walk', 	// You Can't Run Char Cover - Part of the Legacy Expansion
		'vesania', 			// Vesania Char Cover - Part of the Legacy Expansion
		'infinite', 		// Endless Char Cover - Part of the Legacy Expansion
		'high-ground-old', 	// the og - Included in the Mod
		'shenanigans' 		// Old song for an old ass collab that fell through - Part of the Legacy Expansion
	];

	public static var assetPathsToCache:Array<String> = ['null'];

	public static var songsThatForce5Key:Array<String> = [
		'triple-trouble',
		'3-problems'
	];

	/**
	 * Basically this keeps it to 1 function | Load an array to another array by counting from 0 | I.E. high_groundArrowRGB[3] for MCBF Arrow Up RGB
	 * @param [0/4]: ArrowLEFT[MCBF/Char]
	 * @param [1/5]: ArrowDOWN[MCBF/Char]
	 * @param [2/6]: ArrowUP[MCBF/Char]
	 * @param [3/7]: ArrowRIGHT[MCBF/Char]
	 */
	public static var high_groundArrowRGB:Array<Array<FlxColor>> = [
		[0xFF9708E8, 0xFFFFFFFF, 0xFF4B0374], // MCBF Side
		[0xFF1D5DEC, 0xFFFFFFFF, 0xFF0E2F79], // MCBF Side
		[0xFF87A3AD, 0xFFFFFFFF, 0xFF000000], // MCBF Side
		[0xFFD15C50, 0xFFFFFFFF, 0xFF4B201C],  // MCBF Side
		[0xFFFF9D00, 0xFFFFFFFF, 0xFF802B00], // Char Side
		[0xFF6D4FDC, 0xFFFFFFFF, 0xFF27195B], // Char Side
		[0xFF034300, 0xFFFFFFFF, 0xFF0A4447], // Char Side
		[0xFFBE6081, 0xFFFFFFFF, 0xFF651038] // Char Side
	];

	/**
	 * Gets a color from a specific SubArray of a given Array<Array<FlxColor> variable.
	 * @param mainArray Which Color Array to look in
	 * @param ACCEPTED_INPUTS: 4kcolor, 5kcolor, highground
	 * @param isPixel (4 Key Colors only) Whether to grab the PixelRGB value
	 * @param numArray Which array in the array do you want to use as the base for the value to get
	 * @param numEntryOfSubArray the value to get out of the sub array chosen
	 * @return FlxColor
	 */
	public static function getColorFromSubArray(mainArray:String, isPixel:Bool = false, numArray:Int, numEntryOfSubArray:Int):FlxColor
	{
		var tempArray:Array<FlxColor> = null;
		switch (mainArray.toLowerCase()) {
			case '4kcolor':
				if (isPixel) tempArray = ClientPrefs.data.arrowRGBPixel[numArray];
				if (!isPixel) tempArray = ClientPrefs.data.arrowRGB[numArray];
			case '5kcolor':
				if (isPixel) trace('Pixel Not Supported!');
				tempArray = ClientPrefs.data.arrowRGB5Key[numArray];
			case 'highground':
				if (isPixel) trace('Pixel Not Supported!');
				tempArray = high_groundArrowRGB[numArray];
		}
		var hexifiedColor:String = Std.string(StringTools.hex(tempArray[numEntryOfSubArray]));
		trace('Final Color is: ' + hexifiedColor);
		return tempArray[numEntryOfSubArray];
	}

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