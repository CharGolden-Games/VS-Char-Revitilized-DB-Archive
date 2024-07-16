// taken from FunkinCrew/Funkin to be edited later

package backend;

import haxe.ui.backend.flixel.CursorHelper;
import openfl.utils.Assets;
import lime.app.Future;
import openfl.display.BitmapData;

class CursorChangerShit
{
    /* 
    this shit, when set, changes the cursor.
    */
    public static var cursorStyle(default, set):Null<CursorStyle> = null;
    public static var scaleCalculation:Float;
    public static inline function showCursor(cursorShown:Bool)
        {
            if (cursorShown)
                {
                    FlxG.mouse.visible = true;
                    //trace('Showing Cursor');
                    CursorChangerShit.cursorStyle = Default;
                }
            else if (!cursorShown)
                {
                    FlxG.mouse.visible = false;
                    //trace('Hiding Cursor');
                    CursorChangerShit.cursorStyle = null;
                }
        }

        static var assetCursorDefault:Null<BitmapData> = null;

        public static final CURSOR_DEFAULT_PARAMS:CursorParams =
        {
            graphic: "assets/images/cursor/cursor.png",
            scale: 1,
            offsetX: 0,
            offsetY: 0,
        };

        static var assetCursorDeny:Null<BitmapData> = null;

        public static final CURSOR_DENY_PARAMS:CursorParams =
        {
            graphic: "assets/images/cursor/cursorDeny.png",
            scale: 1,
            offsetX: 0,
            offsetY: 0,
        };

        static var assetCursorHand:Null<BitmapData> = null;

        public static final CURSOR_HAND_PARAMS:CursorParams =
        {
            graphic: "assets/images/cursor/cursorHand.png",
            scale: 1,
            offsetX: 0,
            offsetY: 0,
        };

        static function set_cursorStyle(value:Null<CursorStyle>):Null<CursorStyle>
            {
              if (value != null && cursorStyle != value)
              {
                cursorStyle = value;
                loadCursor(cursorStyle);
              }
              return cursorStyle;
            }

            static function loadCursor(?value:CursorStyle = null):Void {
                if (value == null)
                    {
                      FlxG.mouse.unload();
                      return;
                    }
                
                    switch (value)
                    {
                        case Default:
                            if (assetCursorDefault == null)
                                {
                                  var bitmapData:BitmapData = Assets.getBitmapData(CURSOR_DEFAULT_PARAMS.graphic);
                                  assetCursorDefault = bitmapData;
                                  applyCursorParams(assetCursorDefault, CURSOR_DEFAULT_PARAMS);
                                }
                                else
                                {
                                  applyCursorParams(assetCursorDefault, CURSOR_DEFAULT_PARAMS);
                                }
                        case Deny:
                            if (assetCursorDeny == null)
                                {
                                  var bitmapData:BitmapData = Assets.getBitmapData(CURSOR_DENY_PARAMS.graphic);
                                  assetCursorDeny = bitmapData;
                                  applyCursorParams(assetCursorDeny, CURSOR_DENY_PARAMS);
                                }
                                else
                                {
                                  applyCursorParams(assetCursorDeny, CURSOR_DENY_PARAMS);
                                }
                        case Hand:
                            if (assetCursorHand == null)
                              {
                              var bitmapData:BitmapData = Assets.getBitmapData(CURSOR_HAND_PARAMS.graphic);
                              assetCursorHand = bitmapData;
                              applyCursorParams(assetCursorHand, CURSOR_HAND_PARAMS);
                              }
                              else
                              {
                              applyCursorParams(assetCursorHand, CURSOR_HAND_PARAMS);
                              }
                    }
            }

            static function loadCursorGraphic(?value:CursorStyle = null):Void
                {
                  if (value == null)
                  {
                    FlxG.mouse.unload();
                    return;
                  }
              
                  switch (value)
                  {
                    case Default:
                      if (assetCursorDefault == null)
                      {
                        var future:Future<BitmapData> = Assets.loadBitmapData(CURSOR_DEFAULT_PARAMS.graphic);
                        future.onComplete(function(bitmapData:BitmapData) {
                          assetCursorDefault = bitmapData;
                          applyCursorParams(assetCursorDefault, CURSOR_DEFAULT_PARAMS);
                        });
                        future.onError(onCursorError.bind(Default));
                      }
                      else
                      {
                        applyCursorParams(assetCursorDefault, CURSOR_DEFAULT_PARAMS);
                      }
                    case Deny:
                      if (assetCursorDeny == null)
                      {
                        var future:Future<BitmapData> = Assets.loadBitmapData(CURSOR_DENY_PARAMS.graphic);
                        future.onComplete(function(bitmapData:BitmapData) {
                            assetCursorDeny = bitmapData;
                          applyCursorParams(assetCursorDeny, CURSOR_DENY_PARAMS);
                        });
                        future.onError(onCursorError.bind(Default));
                      }
                      else
                      {
                        applyCursorParams(assetCursorDeny, CURSOR_DENY_PARAMS);
                      }
                      case Hand:
                      if (assetCursorHand == null)
                      {
                        var future:Future<BitmapData> = Assets.loadBitmapData(CURSOR_HAND_PARAMS.graphic);
                        future.onComplete(function(bitmapData:BitmapData) {
                          assetCursorHand = bitmapData;
                          applyCursorParams(assetCursorHand, CURSOR_HAND_PARAMS);
                        });
                        future.onError(onCursorError.bind(Default));
                      }
                      else
                      {
                        applyCursorParams(assetCursorHand, CURSOR_HAND_PARAMS);
                      }
                    }
                }

            static inline function applyCursorParams(graphic:BitmapData, params:CursorParams):Void
                {
                  calculateScale(graphic.width, graphic.height);
                  FlxG.mouse.load(graphic, scaleCalculation, params.offsetX, params.offsetY);
                }

                static function onCursorError(cursorStyle:CursorStyle, error:String):Void
                    {
                      trace("bitch i cant load this shit '" + cursorStyle + "' Error: " + error);
                    }

                    public static function registerHaxeUICursors():Void
                        {
                          CursorHelper.useCustomCursors = true;
                          registerHaxeUICursor('default', CURSOR_DEFAULT_PARAMS);
                          registerHaxeUICursor('deny', CURSOR_DENY_PARAMS);
                        }

                        

                        public static function registerHaxeUICursor(id:String, params:CursorParams):Void
                        {
                          CursorHelper.registerCursor(id, params.graphic, params.scale, params.offsetX, params.offsetY);
                        }

  static function calculateScale(width:Dynamic, height:Dynamic)

    if (Type.typeof(width) != TInt || Type.typeof(height) != TInt) {
      trace('HEY THATS NOT AN INTEGER GO BACK AND FIX THE CODE DUMBASS');
      scaleCalculation = 1;
    }
    else {
    if (width < 32)
      {
        scaleCalculation = width / 32;
      }
    else if (height < 32)
      {
        scaleCalculation = height / 32;
      }
      else if (width > 32)
        {
          scaleCalculation = 32 / width;
        }
      else if (height > 32)
        {
          scaleCalculation = 32 / height;
        }
      }

}

enum CursorStyle
{
  Default;
  Deny;
  Hand;
}

typedef CursorParams =
    {
      graphic:String,
      scale:Float,
      offsetX:Int,
      offsetY:Int,
    }