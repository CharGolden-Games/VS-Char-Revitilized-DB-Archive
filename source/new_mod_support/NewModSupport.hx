package new_mod_support;

// planned feature, NOT DONE YET
#if sys
import sys.FileSystem;
import sys.io.File;
#else
import lime.utils.Assets;
#end
import tjson.TJSON as Json;

typedef NewModsList = {
    isNewModType:Array<String>,
	enabled:Array<String>,
	disabled:Array<String>,
	all:Array<String>
}

typedef IntroText = {
	authors:Array<String>,
	presents:Array<String>,
	association:Array<String>,
	ngImg:Array<String>, //ngImg:String, // use this one on any non VS Char builds
	modName:Array<String>
}

typedef ConfigFile = {
	image:String,
	icon:String,
	name:String,
	description:String,
	titleBar:String,
	discordRPC:String,
	introAnimation:Bool,
	introText:IntroText
}

/**
 * A Class that detects if a mod is part of the new Mod Type, for supporting Custom States |
 * this also is kind of a weird modification of the original Mods Class
 */
class NewModSupport
{	
	static var modsList:Array<String> = [];

	/**
	 * Every mod in the New Mod type is global, given it needs the ability to overwrite states.
	 */
	static var currentMod:String = '';
	static var ignoreFolders:Array<String> = [
		'characters',
		'custom_events',
		'custom_notetypes',
		'data',
		'songs',
		'music',
		'sounds',
		'shaders',
		'videos',
		'images',
		'stages',
		'states',
		'weeks',
		'fonts',
		'scripts',
		'achievements'
	];
    
	inline public static function getCurrentMod()
		return currentMod;

	inline public static function pushModsList() {
		modsList = [];
		for (mod in parseList(true).isNewModType) // replace with 
		{
			var pack:Dynamic = getPack(mod);
			if(pack != null && pack.isNewModType) modsList.push(mod);
		}
		return modsList;
	}

	inline public static function getModDirectories():Array<String>
	{
		var list:Array<String> = [];
		#if MODS_ALLOWED
		var modsFolder:String = Paths.mods();
		if(FileSystem.exists(modsFolder)) {
			for (folder in FileSystem.readDirectory(modsFolder))
			{
				var path = haxe.io.Path.join([modsFolder, folder]);
				if (sys.FileSystem.isDirectory(path) && !ignoreFolders.contains(folder.toLowerCase()) && !list.contains(folder))
					list.push(folder);
			}
		}
		#end
		return list;
	}

	inline public static function mergeAllTextsNamed(path:String, defaultDirectory:String = null, allowDuplicates:Bool = false)
		{
			if(defaultDirectory == null) defaultDirectory = Paths.getPreloadPath();
			defaultDirectory = defaultDirectory.trim();
			if(!defaultDirectory.endsWith('/')) defaultDirectory += '/';
			if(!defaultDirectory.startsWith('assets/')) defaultDirectory = 'assets/$defaultDirectory';
	
			var mergedList:Array<String> = [];
			var paths:Array<String> = directoriesWithFile(defaultDirectory, path);
	
			var defaultPath:String = defaultDirectory + path;
			if(paths.contains(defaultPath))
			{
				paths.remove(defaultPath);
				paths.insert(0, defaultPath);
			}
	
			for (file in paths)
			{
				var list:Array<String> = CoolUtil.coolTextFile(file);
				for (value in list)
					if((allowDuplicates || !mergedList.contains(value)) && value.length > 0)
						mergedList.push(value);
			}
			return mergedList;
		}

		inline public static function directoriesWithFile(path:String, fileToFind:String, mods:Bool = true)
			{
				var foldersToCheck:Array<String> = [];
				#if sys
				if(FileSystem.exists(path + fileToFind))
				#end
					foldersToCheck.push(path + fileToFind);
		
				#if MODS_ALLOWED
				if(mods)
				{
					// Global mods first, this is just in case.
					for(mod in Mods.getGlobalMods())
					{
						var folder:String = Paths.mods(mod + '/' + fileToFind);
						if(FileSystem.exists(folder)) foldersToCheck.push(folder);
					}
		
					// Then "PsychEngine/mods/" main folder
					var folder:String = Paths.mods(fileToFind);
					if(FileSystem.exists(folder)) foldersToCheck.push(Paths.mods(fileToFind));
		
					// And lastly, the loaded mod's folder
					if(Mods.currentModDirectory != null && Mods.currentModDirectory.length > 0)
					{
						var folder:String = Paths.mods(Mods.currentModDirectory + '/' + fileToFind);
						if(FileSystem.exists(folder)) foldersToCheck.push(folder);
					}
				}
				#end
				return foldersToCheck;
			}

			public static function getPack(?folder:String = null, newPack:Bool = false):Dynamic
				{
					#if MODS_ALLOWED
					if(folder == null) folder = Mods.currentModDirectory;
			
					var path = Paths.mods(folder + '/pack.json');
					if(newPack) path = Paths.modFolders(folder + '/config.json');
					if(FileSystem.exists(path)) {
						try {
							#if sys
							var rawJson:String = File.getContent(path);
							#else
							var rawJson:String = Assets.getText(path);
							#end
							if(rawJson != null && rawJson.length > 0) return Json.parse(rawJson);
						} catch(e:Dynamic) {
							trace(e);
						}
					}
					#end
					return null;
				}

				public static var updatedOnState:Bool = false;
				inline public static function parseList(newMod:Bool = false):NewModsList {
					if(!updatedOnState) updateModList();
					var list:NewModsList = {isNewModType: [], enabled: [], disabled: [], all: []};
					var modsList = CoolUtil.coolTextFile('modsList.txt');
					if (newMod) modsList = CoolUtil.coolTextFile('newModsList.txt');
			
					#if MODS_ALLOWED
					try {
						for (mod in modsList)
						{
							//trace('Mod: $mod');
							if(mod.trim().length < 1) continue;
			
							var dat = mod.split("|");
							list.all.push(dat[0]);
							if (dat[1] == "1")
								list.enabled.push(dat[0]);
							else
								list.disabled.push(dat[0]);
						}
					} catch(e) {
						trace(e);
					}
					#end
					return list;
				}
				
				private static function updateModList(newMod:Bool = false)
				{
					#if MODS_ALLOWED
					// Find all that are already ordered
					var list:Array<Array<Dynamic>> = [];
					var added:Array<String> = [];
					var modsList = CoolUtil.coolTextFile('modsList.txt');
					if (newMod) modsList = CoolUtil.coolTextFile('newModsList.txt');
					try {
						for (mod in modsList)
						{
							var dat:Array<String> = mod.split("|");
							var folder:String = dat[0];
							if(folder.trim().length > 0 && FileSystem.exists(Paths.mods(folder)) && FileSystem.isDirectory(Paths.mods(folder)) && !added.contains(folder))
							{
								added.push(folder);
								list.push([folder, (dat[1] == "1")]);
							}
						}
					} catch(e) {
						trace(e);
					}
					
					// Scan for folders that aren't on modsList.txt yet
					for (folder in getModDirectories())
					{
						if(folder.trim().length > 0 && FileSystem.exists(Paths.mods(folder)) && FileSystem.isDirectory(Paths.mods(folder)) &&
						!ignoreFolders.contains(folder.toLowerCase()) && !added.contains(folder))
						{
							added.push(folder);
							list.push([folder, true]); //i like it false by default. -bb //Well, i like it True! -Shadow Mario (2022)
							//Shadow Mario (2023): What the fuck was bb thinking
						}
					}
			
					// Now save file
					var fileStr:String = '';
					for (values in list)
					{
						if(fileStr.length > 0) fileStr += '\n';
						fileStr += values[0] + '|' + (values[1] ? '1' : '0');
					}
					
					if(newMod) File.saveContent('newModsList.txt', fileStr); else File.saveContent('modsList.txt', fileStr);
					updatedOnState = true;
					//trace('Saved modsList.txt');
					#end
				}
			
				public static function loadTopMod()
				{
					Mods.currentModDirectory = '';
					
					#if MODS_ALLOWED
					var list:Array<String> = Mods.parseList().enabled;
					if(list != null && list[0] != null)
						Mods.currentModDirectory = list[0];
					#end
				}
}
