package funkin.ui.options;

import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import funkin.ui.AtlasText.AtlasFont;
import funkin.ui.options.OptionsState.Page;
import funkin.graphics.FunkinCamera;
import funkin.ui.TextMenuList.TextMenuItem;
import funkin.audio.FunkinSound;
import funkin.ui.options.MenuItemEnums;
import funkin.ui.options.items.CheckboxPreferenceItem;
import funkin.ui.options.items.NumberPreferenceItem;
import funkin.ui.options.items.EnumPreferenceItem;

class PreferencesMenu extends Page
{
  var items:TextMenuList;
  var preferenceItems:FlxTypedSpriteGroup<FlxSprite>;

  var menuCamera:FlxCamera;
  var camDesc:FlxCamera;
  var camFollow:FlxObject;
  var descBox:FlxSprite;
  var descText:FlxText;

  public function new()
  {
    super();

    menuCamera = new FunkinCamera('prefMenu');
    FlxG.cameras.add(menuCamera, false);
    menuCamera.bgColor = 0x0;
    camera = menuCamera;
    camDesc = new FlxCamera();
    camDesc.bgColor.alpha = 0;
    FlxG.cameras.add(camDesc, false);

    add(items = new TextMenuList());
    add(preferenceItems = new FlxTypedSpriteGroup<FlxSprite>());

    createPrefItems();

    camFollow = new FlxObject(FlxG.width / 2, 0, 140, 70);
    if (items != null) camFollow.y = items.selectedItem.y;

    menuCamera.follow(camFollow, null, 0.06);
    var margin = 160;
    menuCamera.deadzone.set(0, margin, menuCamera.width, 40);
    menuCamera.minScrollY = 0;

    items.onChange.add(function(selected) {
      camFollow.y = selected.y;
    });

    descBox = new FlxSprite().makeGraphic(Std.int(FlxG.width), Std.int(FlxG.height * 0.3), 0xFF000000);
    descBox.alpha = 0.6;
    descBox.cameras = [camDesc];
    descBox.screenCenter(X);
    descBox.y = FlxG.height - descBox.height;
    add(descBox);

    descText = new FlxText(0, 0, FlxG.width, 'Default Description.', 35);
    descText.setFormat(Paths.font('vcr.ttf'), 35, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    descText.screenCenter(X);
    descText.y = descBox.y;
    descText.cameras = [camDesc];
    add(descText);
  }

  /**
   * Create the menu items for each of the preferences.
   */
  function createPrefItems():Void
  {
    createPrefHeader('Funkin\' Base Options');

    createPrefItemCheckbox('Naughtyness', 'Toggle displaying raunchy content', function(value:Bool):Void {
      Preferences.naughtyness = value;
    }, Preferences.naughtyness);
    createPrefItemCheckbox('Downscroll', 'Enable to make notes move downwards', function(value:Bool):Void {
      Preferences.downscroll = value;
    }, Preferences.downscroll);
    createPrefItemCheckbox('Flashing Lights', 'Disable to dampen flashing effects', function(value:Bool):Void {
      Preferences.flashingLights = value;
    }, Preferences.flashingLights);
    createPrefItemCheckbox('Camera Zooming on Beat', 'Disable to stop the camera bouncing to the song', function(value:Bool):Void {
      Preferences.zoomCamera = value;
    }, Preferences.zoomCamera);
    createPrefItemCheckbox('Debug Display', 'Enable to show FPS and other debug stats', function(value:Bool):Void {
      Preferences.debugDisplay = value;
    }, Preferences.debugDisplay);
    createPrefItemCheckbox('Auto Pause', 'Automatically pause the game when it loses focus', function(value:Bool):Void {
      Preferences.autoPause = value;
    }, Preferences.autoPause);

    #if web
    createPrefItemCheckbox('Unlocked Framerate', 'Enable to unlock the framerate', function(value:Bool):Void {
      Preferences.unlockedFramerate = value;
    }, Preferences.unlockedFramerate);
    #end

    createPrefHeader('Funkin\' Tweaked Options');

    createPrefItemCheckbox('Bads/Shits Break Combo', 'Getting a Bad or Shit rating breaks combo\n(Results screen still counts it though.)',
      function(value:Bool):Void {
        Preferences.badsShitsCauseMiss = value;
      }, Preferences.badsShitsCauseMiss);
    createPrefItemCheckbox('Extra Score Info', ' Makes the score show extra details like combo and misses/combo breaks', function(value:Bool):Void {
      Preferences.extraScoreInfo = value;
    }, Preferences.extraScoreInfo);
    createPrefItemCheckbox('Ghost Tapping', 'Whether to allow you to tap when theres no note without penalty.', function(value:Bool):Void {
      Preferences.ghostTapping = value;
    }, Preferences.ghostTapping);
    createPrefItemCheckbox('Show Timings', 'Shows when you hit a note below the rating', function(value:Bool):Void {
      Preferences.showTimings = value;
    }, Preferences.showTimings);
    createPrefItemCheckbox('Transparent Strum Line', 'Makes the Strum Line transparent', function(value:Bool):Void {
      Preferences.transparentStrumline = value;
    }, Preferences.transparentStrumline);
    /*createPrefItemCheckbox('Complex Accuracy', '(NOT IMPLEMENTED!) Factor in hit timing into accuracy.', function(value:Bool):Void {
      Preferences.complexAccuracy = value;
    }, Preferences.complexAccuracy);*/ // Later.
    createPrefItemCheckbox('Timer Bar', '(NOT IMPLEMENTED!) Show how far you are in a song.', function(value:Bool):Void {
      Preferences.timer = value;
    }, Preferences.timer);
    createPrefItemCheckbox('Note Lanes', 'Adds a slightly transparent lane under the Strumline', function(value:Bool):Void {
      Preferences.lanes = value;
    }, Preferences.lanes);
    /*createPrefItemEnum('Note Skin', '(NOT IMPLEMENTED!) What Note Skin to use when playing a chart', NoteSkinEnum.noteskinOptions, function(value:String) {
      fakeOption = value;
    }, fakeOption);*/
    createPrefItemCheckbox('Center Strums', 'Whether to fix the strum offset.', function(value:Bool):Void {
      Preferences.centerStrums = value;
    }, Preferences.centerStrums);

    createPrefHeader('Tweaked Extra Options');

    createPrefItemCheckbox('Show Opp Note Lanes', 'Whether to show opponent note lanes', function(value:Bool):Void {
      Preferences.oppLanes = value;
    }, Preferences.oppLanes);
    createPrefItemNumber('Strum Transparency', 'How transparent should the Strumline (if transparent strum line enabled) be?', function(value:Float):Void {
      Preferences.strumTransparency = value;
    }, null, Preferences.strumTransparency, 0.1, 1, 0.1, 1);
    createPrefItemNumber('Lane Transparency', 'How transparent should the Note Lanes be?', function(value:Float):Void {
      Preferences.laneTransparency = value;
    }, null, Preferences.laneTransparency, 0.1, 1, 0.1, 1);
    createPrefItemCheckbox('Ghost Tap Anims', 'Whether to show sing animations on ghost tap', function(value:Bool):Void {
      Preferences.animsGhostTap = value;
    }, Preferences.animsGhostTap); // Later.
    createPrefItemCheckbox('Fix Score Offset', 'Whether to properly fix the score text being partially blocked by icons', function(value:Bool):Void {
      Preferences.fixScoreOffset = value;
    }, Preferences.fixScoreOffset);
  }

  override function update(elapsed:Float):Void
  {
    super.update(elapsed);

    // Indent the selected item.
    items.forEach(function(daItem:TextMenuItem) {
      var thyOffset:Int = 0;

      // Initializing thy text width (if thou text present)
      var thyTextWidth:Int = 0;
      if (Std.isOfType(daItem, EnumPreferenceItem)) thyTextWidth = cast(daItem, EnumPreferenceItem).lefthandText.getWidth();
      else if (Std.isOfType(daItem, NumberPreferenceItem)) thyTextWidth = cast(daItem, NumberPreferenceItem).lefthandText.getWidth();

      if (thyTextWidth != 0)
      {
        // Magic number because of the weird offset thats being added by default
        thyOffset += thyTextWidth - 75;
      }

      if (items.selectedItem == daItem)
      {
        thyOffset += 150;
      }
      else
      {
        thyOffset += 120;
      }

      daItem.x = thyOffset;

      if (items.selectedItem == daItem)
      {
        if (daItem.textDesc == 'headerObject') daItem.alpha = 1;
        if (daItem.textDesc != 'headerObject')
        {
          descBox.visible = true;
          descText.visible = true;
          descText.text = daItem.textDesc;
          descText.screenCenter(X);
          descBox.setGraphicSize(FlxG.width, descText.height);
          descBox.updateHitbox();
          descBox.y = FlxG.height - descBox.height;
          descText.y = descBox.y;
        }
        else
        {
          descBox.visible = false;
          descText.visible = false;
          // dumb thing
          if (items.selectedIndex == 0 && daItem.textDesc == 'headerObject' && !controls.UI_UP)
            /**Make sure that if its the FIRST entry and no controls have been pressed to NOT accidentally softlock people.**/
          {
            items.selectItem(items.selectedIndex + 1);
            return; // MAKE SURE TO STOP HERE IF THIS IS THE CASE!
          }
          // Going down is easy just increment upward (Weird sounding i know)
          if (controls.UI_DOWN) items.selectItem(items.selectedIndex + 1);
          // Going up is also easy, but you need to increment downward with checks for what place the item is!
          if (controls.UI_UP && items.selectedIndex != 0 /**Prevents crashing by staying in bounds**/) items.selectItem(items.selectedIndex - 1);

          if (controls.UI_UP && items.selectedIndex == 0 /**Prevents crashing by staying in bounds**/) items.selectItem(items.length - 1);
        }
      }
    });
  }

  // - Preference item creation methods -
  // Should be moved into a separate PreferenceItems class but you can't access PreferencesMenu.items and PreferencesMenu.preferenceItems from outside.

  /**
   * For creating a non interactable header option.
   */
  function createPrefHeader(header:String, overrideDesc:String = ''):Void
  {
    var descString = overrideDesc == '' ? 'headerObject' : overrideDesc;
    var blank:FlxSprite = new FlxSprite(-100000000, (items.length - 1 + 1)).makeGraphic(10, 10, 0x00000000);
    items.createItem(0, (120 * items.length) + 30, header, AtlasFont.BOLD, function() {
    }, descString);
    preferenceItems.add(blank);
  }

  /**
   * Creates a pref item that works with booleans
   * @param onChange Gets called every time the player changes the value; use this to apply the value
   * @param defaultValue The value that is loaded in when the pref item is created (usually your Preferences.settingVariable)
   */
  function createPrefItemCheckbox(prefName:String, prefDesc:String, onChange:Bool->Void, defaultValue:Bool):Void
  {
    var checkbox:CheckboxPreferenceItem = new CheckboxPreferenceItem(0, 120 * (items.length - 1 + 1), defaultValue);

    items.createItem(0, (120 * items.length) + 30, prefName, AtlasFont.BOLD, function() {
      var value = !checkbox.currentValue;
      onChange(value);
      checkbox.currentValue = value;
    }, prefDesc);

    preferenceItems.add(checkbox);
  }

  /**
   * Creates a pref item that works with general numbers
   * @param onChange Gets called every time the player changes the value; use this to apply the value
   * @param valueFormatter Will get called every time the game needs to display the float value; use this to change how the displayed value looks
   * @param defaultValue The value that is loaded in when the pref item is created (usually your Preferences.settingVariable)
   * @param min Minimum value (example: 0)
   * @param max Maximum value (example: 10)
   * @param step The value to increment/decrement by (default = 0.1)
   * @param precision Rounds decimals up to a `precision` amount of digits (ex: 4 -> 0.1234, 2 -> 0.12)
   */
  function createPrefItemNumber(prefName:String, prefDesc:String, onChange:Float->Void, ?valueFormatter:Float->String, defaultValue:Float, min:Float,
      max:Float, step:Float = 0.1, precision:Int):Void
  {
    var item = new NumberPreferenceItem(0, (120 * items.length) + 30, prefName, defaultValue, min, max, step, precision, onChange, valueFormatter, prefDesc);
    items.addItem(prefName, item);
    preferenceItems.add(item.lefthandText);
  }

  /**
   * Creates a pref item that works with number percentages
   * @param onChange Gets called every time the player changes the value; use this to apply the value
   * @param defaultValue The value that is loaded in when the pref item is created (usually your Preferences.settingVariable)
   * @param min Minimum value (default = 0)
   * @param max Maximum value (default = 100)
   */
  function createPrefItemPercentage(prefName:String, prefDesc:String, onChange:Int->Void, defaultValue:Int, min:Int = 0, max:Int = 100):Void
  {
    var newCallback = function(value:Float) {
      onChange(Std.int(value));
    };
    var formatter = function(value:Float) {
      return '${value}%';
    };
    var item = new NumberPreferenceItem(0, (120 * items.length) + 30, prefName, defaultValue, min, max, 10, 0, newCallback, formatter, prefDesc);
    items.addItem(prefName, item);
    preferenceItems.add(item.lefthandText);
  }

  /**
   * Creates a pref item that works with enums
   * @param values Maps enum values to display strings _(ex: `NoteHitSoundType.PingPong => "Ping pong"`)_
   * @param onChange Gets called every time the player changes the value; use this to apply the value
   * @param defaultValue The value that is loaded in when the pref item is created (usually your Preferences.settingVariable)
   */
  function createPrefItemEnum(prefName:String, prefDesc:String, values:Map<String, String>, onChange:String->Void, defaultValue:String):Void
  {
    var item = new EnumPreferenceItem(0, (120 * items.length) + 30, prefName, values, defaultValue, onChange, prefDesc);
    items.addItem(prefName, item);
    preferenceItems.add(item.lefthandText);
  }
}
