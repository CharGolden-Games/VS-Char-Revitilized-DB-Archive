package new_mod_support;

import backend.TracePassThrough as CustomTrace;
#if (HSCRIPT_ALLOWED && SScript >= "3.0.0")
import tea.SScript;
#if LUA_ALLOWED
import psychlua.*; // uh maybe this has stuff i need lmao.
//import backend.Script;
#else
import psychlua.HScript; // uh maybe this has stuff i need lmao.
//import backend.Script;
#end
import flixel.FlxBasic;
import objects.Character;
import backend.Mods;
import new_mod_support.DetectNewMods;

class CustomState extends MusicBeatState
{
    public var hscriptAllowed:Bool = true;
    public var _mod:String = Mods.currentModDirectory;
    public var _scriptName:String = 'Main';
    //public var _script:Script;
    public var args:Array<Any>;

    override function create()
        {
            trace('dummy, dont use yet lmao.');
        }
}
#else
class CustomState extends MusicBeatState //DONT MESS WITH THIS, THIS IS SO CERTAIN VARIABLES DONT ERROR OUT.
{
    override function create() {
        CustomTrace.trace('HSCRIPT NOT ALLOWED! EXITING', 'fatal');
    }
}
#end