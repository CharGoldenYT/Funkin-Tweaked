package funkin;

import funkin.save.Save;

/**
 * A core class which provides a store of user-configurable, globally relevant values.
 */
class Preferences
{
  /**
   * Whether some particularly fowl language is displayed.
   * @default `true`
   */
  public static var naughtyness(get, set):Bool;

  static function get_naughtyness():Bool
  {
    return Save?.instance?.options?.naughtyness;
  }

  static function set_naughtyness(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.naughtyness = value;
    save.flush();
    return value;
  }

  /**
   * If enabled, the strumline is at the bottom of the screen rather than the top.
   * @default `false`
   */
  public static var downscroll(get, set):Bool;

  static function get_downscroll():Bool
  {
    return Save?.instance?.options?.downscroll;
  }

  static function set_downscroll(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.downscroll = value;
    save.flush();
    return value;
  }

  /**
   * If disabled, flashing lights in the main menu and other areas will be less intense.
   * @default `true`
   */
  public static var flashingLights(get, set):Bool;

  static function get_flashingLights():Bool
  {
    return Save?.instance?.options?.flashingLights ?? true;
  }

  static function set_flashingLights(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.flashingLights = value;
    save.flush();
    return value;
  }

  /**
   * If disabled, the camera bump synchronized to the beat.
   * @default `false`
   */
  public static var zoomCamera(get, set):Bool;

  static function get_zoomCamera():Bool
  {
    return Save?.instance?.options?.zoomCamera;
  }

  static function set_zoomCamera(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.zoomCamera = value;
    save.flush();
    return value;
  }

  /**
   * If enabled, an FPS and memory counter will be displayed even if this is not a debug build.
   * @default `false`
   */
  public static var debugDisplay(get, set):Bool;

  static function get_debugDisplay():Bool
  {
    return Save?.instance?.options?.debugDisplay;
  }

  static function set_debugDisplay(value:Bool):Bool
  {
    if (value != Save.instance.options.debugDisplay)
    {
      toggleDebugDisplay(value);
    }

    var save = Save.instance;
    save.options.debugDisplay = value;
    save.flush();
    return value;
  }

  /**
   * If enabled, the game will automatically pause when tabbing out.
   * @default `true`
   */
  public static var autoPause(get, set):Bool;

  static function get_autoPause():Bool
  {
    return Save?.instance?.options?.autoPause ?? true;
  }

  static function set_autoPause(value:Bool):Bool
  {
    if (value != Save.instance.options.autoPause) FlxG.autoPause = value;

    var save:Save = Save.instance;
    save.options.autoPause = value;
    save.flush();
    return value;
  }

  public static var unlockedFramerate(get, set):Bool;

  static function get_unlockedFramerate():Bool
  {
    return Save?.instance?.options?.unlockedFramerate;
  }

  static function set_unlockedFramerate(value:Bool):Bool
  {
    if (value != Save.instance.options.unlockedFramerate)
    {
      #if web
      toggleFramerateCap(value);
      #end
    }

    var save:Save = Save.instance;
    save.options.unlockedFramerate = value;
    save.flush();
    return value;
  }

  /**
   * If enabled, Bads and Shits cause a miss.
   * @default `true`
   */
  public static var badsShitsCauseMiss(get, set):Bool;

  static function get_badsShitsCauseMiss():Bool
  {
    return Save?.instance?.options?.badsShitsCauseMiss ?? true;
  }

  static function set_badsShitsCauseMiss(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.badsShitsCauseMiss = value;
    save.flush();
    return value;
  }

  /**
   * If enabled, Shows extra info on the score line, like combo and combo breaks/misses
   * @default `true`
   */
  public static var extraScoreInfo(get, set):Bool;

  static function get_extraScoreInfo():Bool
  {
    return Save?.instance?.options?.extraScoreInfo ?? true;
  }

  static function set_extraScoreInfo(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.extraScoreInfo = value;
    save.flush();
    return value;
  }

  /**
   * If enabled, lets you press when there are no arrows without causing a miss.
   * @default `true`
   */
  public static var ghostTapping(get, set):Bool;

  static function get_ghostTapping():Bool
  {
    return Save?.instance?.options?.ghostTapping ?? true;
  }

  static function set_ghostTapping(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.ghostTapping = value;
    save.flush();
    return value;
  }

  /**
   * If enabled, shows when you hit a note
   * @default `true`
   */
  public static var showTimings(get, set):Bool;

  static function get_showTimings():Bool
  {
    return Save?.instance?.options?.showTimings ?? true;
  }

  static function set_showTimings(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.showTimings = value;
    save.flush();
    return value;
  }

  /**
   * Enhancement suggestion from "https://github.com/FunkinCrew/Funkin/issues/3124"
   * @default `false`
   */
  public static var transparentStrumline(get, set):Bool;

  static function get_transparentStrumline():Bool
  {
    return Save?.instance?.options?.transparentStrumline ?? true;
  }

  static function set_transparentStrumline(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.transparentStrumline = value;
    save.flush();
    return value;
  }

  /**
   * Does a better job at actually calculating accuracy, but isn't accurate to the results screen
   * @default `false`
   */
  public static var complexAccuracy(get, set):Bool;

  static function get_complexAccuracy():Bool
  {
    return Save?.instance?.options?.complexAccuracy ?? true;
  }

  static function set_complexAccuracy(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.complexAccuracy = value;
    save.flush();
    return value;
  }

  /**
   * Whether to show the time left in a song
   * @default `true`
   */
  public static var timer(get, set):Bool;

  static function get_timer():Bool
  {
    return Save?.instance?.options?.timer ?? true;
  }

  static function set_timer(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.timer = value;
    save.flush();
    return value;
  }

  /**
   * Whether to show not lanes
   * @default `false`
   */
  public static var lanes(get, set):Bool;

  static function get_lanes():Bool
  {
    return Save?.instance?.options?.lanes ?? true;
  }

  static function set_lanes(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.lanes = value;
    save.flush();
    return value;
  }

  /**
   * Whether to show not lanes
   * @default `false`
   */
  public static var animsGhostTap(get, set):Bool;

  static function get_animsGhostTap():Bool
  {
    return Save?.instance?.options?.animsGhostTap ?? true;
  }

  static function set_animsGhostTap(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.animsGhostTap = value;
    save.flush();
    return value;
  }

  /**
   * Whether to show opponent lanes
   * @default `true`
   */
  public static var oppLanes(get, set):Bool;

  static function get_oppLanes():Bool
  {
    return Save?.instance?.options?.oppLanes ?? true;
  }

  static function set_oppLanes(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.oppLanes = value;
    save.flush();
    return value;
  }

  /**
   * Whether to properly center the strums
   * @default `false`
   */
  public static var centerStrums(get, set):Bool;

  static function get_centerStrums():Bool
  {
    return Save?.instance?.options?.centerStrums ?? true;
  }

  static function set_centerStrums(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.centerStrums = value;
    save.flush();
    return value;
  }

  /**
   * Whether to properly fix the score text being partially blocked by icons
   * @default `false`
   */
  public static var fixScoreOffset(get, set):Bool;

  static function get_fixScoreOffset():Bool
  {
    return Save?.instance?.options?.fixScoreOffset ?? true;
  }

  static function set_fixScoreOffset(value:Bool):Bool
  {
    var save:Save = Save.instance;
    save.options.fixScoreOffset = value;
    save.flush();
    return value;
  }

  /**
   * transparency of lanes
   * @default `0.6`
   */
  public static var laneTransparency(get, set):Float;

  static function get_laneTransparency():Float
  {
    var save:Save = Save.instance;
    var float:Float = save.options.laneTransparency;
    return float;
  }

  static function set_laneTransparency(value:Float):Float
  {
    var save:Save = Save.instance;
    save.options.laneTransparency = value;
    save.flush();
    return value;
  }

  /**
   * transparency of lanes
   * @default `0.6`
   */
  public static var strumTransparency(get, set):Float;

  static function get_strumTransparency():Float
  {
    var save:Save = Save.instance;
    var float:Float = save.options.strumTransparency;
    return float;
  }

  static function set_strumTransparency(value:Float):Float
  {
    var save:Save = Save.instance;
    save.options.strumTransparency = value;
    save.flush();
    return value;
  }

  #if web
  // We create a haxe version of this just for readability.
  // We use these to override `window.requestAnimationFrame` in Javascript to uncap the framerate / "animation" request rate
  // Javascript is crazy since u can just do stuff like that lol

  public static function unlockedFramerateFunction(callback, element)
  {
    var currTime = Date.now().getTime();
    var timeToCall = 0;
    var id = js.Browser.window.setTimeout(function() {
      callback(currTime + timeToCall);
    }, timeToCall);
    return id;
  }

  // Lime already implements their own little framerate cap, so we can just use that
  // This also gets set in the init function in Main.hx, since we need to definitely override it
  public static var lockedFramerateFunction = untyped js.Syntax.code("window.requestAnimationFrame");
  #end

  /**
   * Loads the user's preferences from the save data and apply them.
   */
  public static function init():Void
  {
    // Apply the autoPause setting (enables automatic pausing on focus lost).
    FlxG.autoPause = Preferences.autoPause;
    // Apply the debugDisplay setting (enables the FPS and RAM display).
    toggleDebugDisplay(Preferences.debugDisplay);
    #if web
    toggleFramerateCap(Preferences.unlockedFramerate);
    #end
  }

  static function toggleFramerateCap(unlocked:Bool):Void
  {
    #if web
    var framerateFunction = unlocked ? unlockedFramerateFunction : lockedFramerateFunction;
    untyped js.Syntax.code("window.requestAnimationFrame = framerateFunction;");
    #end
  }

  static function toggleDebugDisplay(show:Bool):Void
  {
    if (show)
    {
      // Enable the debug display.
      FlxG.stage.addChild(Main.fpsCounter);
      #if !html5
      FlxG.stage.addChild(Main.memoryCounter);
      #end
    }
    else
    {
      // Disable the debug display.
      FlxG.stage.removeChild(Main.fpsCounter);
      #if !html5
      FlxG.stage.removeChild(Main.memoryCounter);
      #end
    }
  }
}
