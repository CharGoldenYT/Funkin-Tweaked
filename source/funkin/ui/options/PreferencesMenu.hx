package funkin.ui.options;

import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import funkin.ui.AtlasText.AtlasFont;
import funkin.ui.options.OptionsState.Page;
import funkin.graphics.FunkinCamera;
import funkin.ui.TextMenuList.TextMenuItem;

class PreferencesMenu extends Page
{
  var items:TextMenuList;
  var preferenceItems:FlxTypedSpriteGroup<FlxSprite>;

  var menuCamera:FlxCamera;
  var camDesc:FlxCamera;
  var camFollow:FlxObject;
  var descBox:FlxSprite;
  var descText:FlxText;
  var funnyToggle:Bool = false;
  var defaultZoom:Float = 0;

  public function new()
  {
    super();

    menuCamera = new FunkinCamera('prefMenu');
    FlxG.cameras.add(menuCamera, false);
    menuCamera.bgColor = 0x0;
    camera = menuCamera;

    camDesc = new FlxCamera();
    FlxG.cameras.add(camDesc, false);
    camDesc.bgColor = 0x0;

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
    defaultZoom = menuCamera.zoom;

    descBox = new FlxSprite().makeGraphic(FlxG.width - 24, 200, 0x99000000);
    descBox.y = FlxG.height - (descBox.height + 5);
    descBox.x = 12;
    descBox.cameras = [camDesc];
    add(descBox);

    descText = new FlxText(0, descBox.getGraphicMidpoint().y, descBox.width, "This is default text", 60);
    descText.setFormat("VCR OSD Mono", 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    descText.cameras = [camDesc];
    descText.screenCenter(X);
    add(descText);
  }

  /**
   * Create the menu items for each of the preferences.
   */
  function createPrefItems():Void
  {
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
    createPrefItemCheckbox('Bads/Shits Break Combo', 'Getting a Bad or Shit rating breaks combo', function(value:Bool):Void {
      Preferences.badsShitsCauseMiss = value;
    }, Preferences.badsShitsCauseMiss);
    createPrefItemCheckbox('Extra Score Info', 'Makes the score show extra details like combo and misses/combo breaks', function(value:Bool):Void {
      Preferences.extraScoreInfo = value;
    }, Preferences.extraScoreInfo);
    createPrefItemCheckbox('Ghost Tapping', 'THE FEATURE EVERYONE WANTED IN BASE GAME. Now made easily toggleable!', function(value:Bool):Void {
      Preferences.ghostTapping = value;
    }, Preferences.ghostTapping);
    createPrefItemCheckbox('Show Timings', 'Shows when you hit a note below the rating', function(value:Bool):Void {
      Preferences.showTimings = value;
    }, Preferences.showTimings);
    createPrefItemCheckbox('Transparent Strum Line', 'Makes the Strum Line 50% transparent', function(value:Bool):Void {
      Preferences.transparentStrumline = value;
    }, Preferences.transparentStrumline);
    createPrefItemCheckbox('Complex Accuracy', 'Factor in hit timing into accuracy.', function(value:Bool):Void {
      Preferences.complexAccuracy = value;
    }, Preferences.complexAccuracy);
    createPrefItemCheckbox('Timer Bar', 'Show how far you are in a song.', function(value:Bool):Void {
      Preferences.timer = value;
    }, Preferences.timer);
    createPrefItemCheckbox('Note Lanes', 'adds a slightly transparent lane under the Strumline', function(value:Bool):Void {
      Preferences.lanes = value;
    }, Preferences.lanes);
  }

  function createPrefItemCheckbox(prefName:String, prefDesc:String, onChange:Bool->Void, defaultValue:Bool):Void
  {
    var checkbox:CheckboxPreferenceItem = new CheckboxPreferenceItem(0, 120 * (items.length - 1 + 1), defaultValue);

    items.createItem(120, (120 * items.length) + 30, prefName, AtlasFont.BOLD, function() {
      var value = !checkbox.currentValue;
      onChange(value);
      checkbox.currentValue = value;
    }, false, prefDesc);

    preferenceItems.add(checkbox);
  }

  override function update(elapsed:Float):Void
  {
    super.update(elapsed);

    // Indent the selected item.
    // TODO: Only do this on menu change?
    items.forEach(function(daItem:TextMenuItem) {
      if (items.selectedItem == daItem)
      {
        daItem.x = 150;
        descText.text = daItem.textDesc;
        descText.screenCenter(X);
        descText.y = descBox.getGraphicMidpoint().y - 25;
      }
      else
      {
        daItem.x = 120;
      }
    });
    if (FlxG.keys.justPressed.RBRACKET)
    {
      funnyToggle = !funnyToggle;
      menuCamera.zoom = funnyToggle ? 0.01 : defaultZoom;
    }
  }
}

class CheckboxPreferenceItem extends FlxSprite
{
  public var currentValue(default, set):Bool;

  public function new(x:Float, y:Float, defaultValue:Bool = false)
  {
    super(x, y);

    frames = Paths.getSparrowAtlas('checkboxThingie');
    animation.addByPrefix('static', 'Check Box unselected', 24, false);
    animation.addByPrefix('checked', 'Check Box selecting animation', 24, false);

    setGraphicSize(Std.int(width * 0.7));
    updateHitbox();

    this.currentValue = defaultValue;
  }

  override function update(elapsed:Float)
  {
    super.update(elapsed);

    switch (animation.curAnim.name)
    {
      case 'static':
        offset.set();
      case 'checked':
        offset.set(17, 70);
    }
  }

  function set_currentValue(value:Bool):Bool
  {
    if (value)
    {
      animation.play('checked', true);
    }
    else
    {
      animation.play('static');
    }

    return currentValue = value;
  }
}
