package backend;

import lime.app.Application;

using StringTools;

/**
 * a class that helps turn multiple statements into one, while also holding static variables referenced in multiple places (similar to Funkin 0.4's Constants class)
 */
class Constants
{
    /**
     * The title of the game. Used for resetting the window title, and crash logs
     */
	public static final TITLE:String = 'VS Char Revitalized'#if IS_DEVBRANCH + ' (Developer Branch)'#end #if BETA_BUILD + ' - Beta' #end;
    /**
     * Just cause.
     */
    public static final psychEngineVersion:String = " Psych Engine v1.0 Pre-Release";

	/**
	 * Used for making sure im not an idiot, and properly update the engine version lmao.
	 */
	public static final charEngineVersion:String = 'Indev 0.10-1: Psych Version Upgrade';

	/**
	 * Used for updating
	 */
	public static final vsCharVersion:String = 'Indev 1: Psych 1.0 Pre-Release';

	/**
	 * You can see its use in the function "versionNumOnly"
	 */
	public static var splitString:Array<String>;

	/**
	 * so that i can reduce it to one function lmao.
	 */
	public static final vsCharSongs:Array<String> = [ // why isnt pico 2 here? i don't own it lmao.
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
	 * Format goes: For each icon you want to assign to a song or multiple songs: Array[icon:Array<String>, songList:Array<String>]
	 */
	public static final songIcons:Array<Array<Array<String>>> = [
		[['char'], ['tutorial', 'obligatory-bonus-song', 'triple-trouble']],
		[['anny'], ['saloon-trouble']],
		[['charold'], ['3-problems', 'slow', 'you-can-walk', 'infinite', 'shenanigans']],
		[['charoldN'], ['free-movies-free']],
		[['igni'], ['conflicting-views', 'ambush']],
		[['zavi'], ['junkyard']],
		[['micheal-blubber'], ['blubber']],
		[['charmongusb'], ['defeat-char-mix', 'defeat-odd-mix']],
		[['mcbf-new'], ['high-ground', 'high-grounder']],
		[['mcbfv3'], ['high-ground-old']]
	];

	/**
	 * What is this for? well each color HAS to corrospond to an entry in songIcons for CustomFreeplayMenuState!
	 */
	public static final songColors:Array<FlxColor> = [
		0xFF9D00,
		0xA000A8,
		0xFF5100,
		0xFF5100,
		0x3D4249,
		0xFFEC5B,
		0xA7452C,
		0xFF9D00,
		0x2d2741,
		0x31b0d1
	];

	/**
	 * This Array contains the names of every old song i plan to add back into the mod at some point, with a desc in comments of where it'll go.
	 */
	public static final vsCharLegacySongs:Array<String> = [
		'free-movies-free', // Iason Mason Cover - Part of the Legacy Expansion
		'3-problems', 		// Triple Trouble OG - Part of the Legacy Expansion
		'slow', 			// Too Slow Char Cover - Part of the Legacy Expansion
		'you-can-walk', 	// You Can't Run Char Cover - Part of the Legacy Expansion
		'vesania', 			// Vesania Char Cover - Part of the Legacy Expansion
		'infinite', 		// Endless Char Cover - Part of the Legacy Expansion
		'high-ground-old', 	// the og - Included in the Mod
		'shenanigans' 		// Old song for an old ass collab that fell through - Part of the Legacy Expansion
        //'v${Application.current.meta.get('version')}'
	];

    public static function numOnly(versionToGet:String):String
    {
        var psychString = psychEngineVersion.split('v')[1];

        var engineString = charEngineVersion.split(':')[0];

        var vsCharString = vsCharVersion.split(':')[0];

        switch (versionToGet.toLowerCase()) {
            case 'psych':
                return psychString;
            case 'funkin':
                return '2.8.0';
            case 'charengine':
                return engineString;
            case 'vschar':
                return vsCharString;
        }
        trace('Non-Valid Version! check ur speling! got $versionToGet');
        return 'null';
    }
}