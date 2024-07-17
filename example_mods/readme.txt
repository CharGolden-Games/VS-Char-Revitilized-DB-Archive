for new mod type mods:

Here is the Import.hx file for what (theoretically) you don't need to re-import:

import backend.Discord;

import llua.*;

import llua.Lua;

import backend.Paths;

import backend.Controls;

import backend.CoolUtil;

import backend.MusicBeatState;

import backend.MusicBeatSubstate;

import backend.CustomFadeTransition;

import backend.ClientPrefs;

import backend.Conductor;

import backend.BaseStage;

import backend.Difficulty;

import backend.Mods;

import backend.CursorChangerShit;

import backend.ReferenceStrings;

import objects.Alphabet;

import objects.BGSprite;

import states.PlayState;

import states.LoadingState;

import flixel.sound.FlxSound;

import flixel.system.FlxSound;

import flixel.FlxG;

import flixel.FlxSprite;

import flixel.FlxCamera;

import flixel.math.FlxMath;

import flixel.util.FlxColor;

import flixel.util.FlxTimer;

import flixel.text.FlxText;

import flixel.tweens.FlxEase;

import flixel.tweens.FlxTween;

import flixel.group.FlxSpriteGroup;

import flixel.group.FlxGroup.FlxTypedGroup;

using StringTools;