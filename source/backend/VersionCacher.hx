// This Class handles the Caching of the last successfully grabbed Version from the github
package backend;

import sys.FileSystem;
import sys.io.File;
using StringTools;
import lime.app.Application;
import backend.TracePassThrough as CustomTrace;

class VersionCacher {
    // thank god it ignores whitespace lmao, this'd be extremely long if i couldn't do that.
    // code that i'd rather just have in its own class cause its a lot lmao PLUS I GET TO PUT SHIT INTO THE THING
    /**
     * This function caches a version (or two) specified in the following variable(s)
     * 
     * @param updateVersion The Version it caches
     * 
     * @param cachePath The place you're caching the version to
     * 
     * @param saveOverReadme Whether to replace the readme file in the cachePath
     * 
     * @param bothVersionsPresent Whether to failsafe save over the previous caching
     * 
     * @param cacheFileName Filename of cached version
     * 
     * @param updateVerTmp Used in conjunctionn with bothVersionsPresent, Uses this to cache a second version
     * 
     * @param updateFileNameTmp Filename of 2nd Cached Version
     */
    public static inline function cacheUpdate(
        updateVersion:String,
        cachePath:String = 'assets/VersionCache',
        saveOverReadme:Bool = true,
        bothVersionsPresent:Bool = false,
        cacheFileName:String = 'gitVersion',
        updateVerTmp:String = '',
        updateFileNameTmp:String = '')
        {
            var folderPath:String = './' + cachePath + '/';
            cacheFileName = cacheFileName + 'Cache';
            if (updateFileNameTmp != null || updateFileNameTmp.trim() != '') {
                updateFileNameTmp = updateFileNameTmp +'Cache';
            } else {
                updateFileNameTmp = null;
            }
            var path:String = folderPath + cacheFileName + '.txt'; // so you only need to add the name lmao.
            var readmePath:String = folderPath + 'readme.txt';
            var compareVer:String; // for comparing updateVerTmp.
    
            // Caching the last version successfully found
                if ((!FileSystem.exists(folderPath)) == true) {
                FileSystem.createDirectory(folderPath);
                    }
                    CustomTrace.trace("Created " + folderPath + " Directory, Saving " + cacheFileName + " cache", 'info');
                try {
                File.saveContent(path, updateVersion);
                if (saveOverReadme){
                    File.saveContent(readmePath, 'this is where i cache the last successful version grabbed,\nmess with it and itll just overwrite it with the latest version of "gitVersion.txt" from the Repo');
                }
                if (bothVersionsPresent) {
                    if (updateFileNameTmp != null) {
                        path = folderPath + updateFileNameTmp + '.txt';
    
                        if (FileSystem.exists(path)) {
                        compareVer = sys.io.File.getContent(path);
                        if (compareVer != updateVerTmp) {
                        File.saveContent(path, updateVerTmp);
                        CustomTrace.trace('updateVerTmp Version Successfully cached: ' + updateVerTmp, 'info');
                        } else {
                            CustomTrace.trace('updateVerTmp ALREADY UP TO DATE.', 'warn');
                        }
                        } else {
                            File.saveContent(path, updateVerTmp);
                        CustomTrace.trace('updateVerTmp Version Successfully cached: ' + updateVerTmp, 'info');
                        }
                        } else {
                            CustomTrace.trace('"bothVersionsPresent" Set true, but no name defined! not caching.', 'fatal');
                        }
                }
                trace("Version Successfully cached: " + updateVersion);
                } catch(e:Dynamic) {
                    var error:String = Std.string(e);
                    CustomTrace.trace('SHIT THERES BEEN AN ERROR: $error BETTER CHECK THAT ONE OUT.', 'err');
                }
             
    
                // if its found, and its a lower version, replace it as long as caching is enabled
                if (ClientPrefs.data.enableCaching) {
                if ((!FileSystem.exists(folderPath)) != true) {
                var CachedVersion = sys.io.File.getContent(path);
                if (updateVersion != CachedVersion){
                    CustomTrace.trace("Offline " + cacheFileName + " out of date, replacing it with v" + updateVersion, 'warn');
                if (!FileSystem.exists(folderPath)){
                    try {
                FileSystem.deleteDirectory(folderPath);
                    } catch(e:Dynamic) {
                        var error:String = Std.string(e);
                        CustomTrace.trace('SHIT THERES BEEN AN ERROR TRYING TO DELETE THAT: "$error" BETTER CHECK THAT ONE OUT.', 'fatal');
                    }
                }
                    
                if (!FileSystem.exists(folderPath)) {
                    if (updateVersion != CachedVersion){
                    try {
                    FileSystem.createDirectory(folderPath);
                    } catch(e:Dynamic) {
                        var error:String = Std.string(e);
                        CustomTrace.trace('SHIT THERES BEEN AN ERROR TRYING TO CREATE THAT: "$error" BETTER CHECK THAT ONE OUT.', 'fatal');
                    }
                }
                 try {
                File.saveContent(path, updateVersion);
                if (saveOverReadme){
                    File.saveContent(readmePath, 'this is where i cache the last successful version grabbed,\nmess with it and itll just overwrite it with the latest version of "gitVersion.txt" from the Repo');
                }
                CustomTrace.trace(cacheFileName + " cache up to date!!!!", 'info');} 
                } else if (updateVersion == CachedVersion) {
                    CustomTrace.trace(cacheFileName + " cache already up to date, no changes!", 'warn');
                    }
                }
            }
        }
    }
}