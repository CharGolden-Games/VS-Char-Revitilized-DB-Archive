package backend;

#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#else
import openfl.utils.Assets;
#end
import tjson.TJSON as Json;
import states.PlayState;
import flixel.addons.ui.U;
import backend.TracePassThrough as CustomTrace;

typedef CreditsFile = 
{
	var songName:String;
	var songArtist:String;
	var artist:String;
	var charter:String;
	var timeShown:Int;
	var boxWidth:Int;
}

class CreditsData
{
	public static var isFreeplay:Bool = false;

	/**
	 * Returns a dummy list of credits info
	 * @param song Used to set the songName field 
	 * @return CreditsFile
	 */
	public static function dummy(song:String):CreditsFile
	{
		/*if (!isFreeplay) {
        CustomTrace.trace('"credits.json" DOES NOT EXIST', 'err'); // don't need this, theres a very clear indicator lmao.
		}*/
                return {
				songName: U.FUL(song),
				songArtist: 'NOT PROVIDED',
				artist: 'NOT PROVIDED',
				charter: 'NOT PROVIDED',
				boxWidth: 350,
				timeShown: 5,
                };
	}
    
    // stolen from StageData lmao
    /**
     * Stolen from StageData lmao, using a credits.json file in a song's data root grabs credits info.
     * @param song Used to set the Song's directory
     * @return CreditsFile
     */
    public static function getCreditsFile(song:String):CreditsFile {
		var rawJson:String = null;
		var path:String = Paths.getPreloadPath('data/' + Paths.formatToSongPath(song) + '/credits.json');
		/*if (!isFreeplay) {
		CustomTrace.trace('The path is: ' + path, 'info'); // lmao this was supposed to be removed a while ago.
		}*/

		#if MODS_ALLOWED
		var modPath:String = Paths.modFolders('data/' + Paths.formatToSongPath(song) + '/credits.json');
		if(FileSystem.exists(modPath)) {
			/*if (!isFreeplay) {
			CustomTrace.trace('USING MODPATH', 'info'); // don't need this.
			}*/
			rawJson = File.getContent(modPath);
		} else if(FileSystem.exists(path)) {
			/*if (!isFreeplay) {
			CustomTrace.trace('USING PRELOAD PATH', 'info'); // don't need this.
			}*/
			rawJson = File.getContent(path);
		}
		#else
		if(Assets.exists(path)) {
			rawJson = Assets.getText(path);
		}
		#end
		else
		{
			return null;
		}
		return cast Json.parse(rawJson);
	}
}