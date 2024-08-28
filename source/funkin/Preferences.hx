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
   * Loads the user's preferences from the save data and apply them.
   */
  public static function init():Void
  {
    // Apply the autoPause setting (enables automatic pausing on focus lost).
    FlxG.autoPause = Preferences.autoPause;
    // Apply the debugDisplay setting (enables the FPS and RAM display).
    toggleDebugDisplay(Preferences.debugDisplay);
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
