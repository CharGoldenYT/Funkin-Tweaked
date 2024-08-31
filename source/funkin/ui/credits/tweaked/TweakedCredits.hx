package funkin.ui.credits.tweaked;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;
import funkin.ui.credits.MainCreditsState;
import funkin.util.WindowUtil;
import funkin.graphics.FunkinSprite;
import funkin.data.JsonFile;
import lime.system.System;
import sys.io.File;

typedef CreditsFile =
{
  var comment:String;
  var creditsListData:Array<Array<String>>;
}

/**
 * God damn im too used to making Psych menus :waargh:
 * This state shows credits for Funkin' Tweaked. May unintentionally resemble Base Psych Credits.
 */
class TweakedCredits extends MusicBeatState
{
  /**
   * Format time: `"[Name, Desc, Link, Icon]"`
   * @param Name The username displayed in the credits.
   * @param Desc The blurb that appears when on a selection.
   * @param Link If selected, direct the player here!
   * @param Icon The name of the image in `assets/images/credits/` to use.
   */
  var creditsList:Array<Array<String>> = [];

  // Draw Objects
  var bg:FlxSprite;

  /**
   * Whether an entry has a link assosciated with it.
   */
  var isSelectable:Array<Bool>;

  var curSelected:Int = 0;
  var grpCredits:FlxTypedGroup<FlxText> /**<Alphabet>**/;
  var grpIcons:FlxTypedGroup</*TweakedCreditsIcons*/ FunkinSprite>;

  /**
   * Whether an entry has a description.
   */
  var hasDesc:Array<Bool>;

  var camCredits:FlxCamera;
  var camDesc:FlxCamera;
  var camFollow:FlxObject;
  var descBox:FlxSprite;
  var descText:FlxText;

  public var nextOffset:Int = 0;

  override function create():Void
  {
    if (CREDITS_DATA != null) doCreditsMerge();
    if (creditsList.length < 1) creditsList = [['No Credits Loaded!', '', '', '']];
    #if TEST_ARRAY
    creditsList.push([]); // funny
    #end
    nextOffset = 0;
    camDesc = new FlxCamera();
    camCredits = new FlxCamera();
    camFollow = new FlxObject(FlxG.width / 2, 0, 140, 70);

    FlxG.cameras.add(camCredits, false);
    FlxG.cameras.add(camDesc, false);

    camera = camCredits;
    camCredits.bgColor = 0x00000000;
    camDesc.bgColor = 0x00000000;

    add(camFollow);

    camCredits.follow(camFollow, null, 0.5);

    bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
    bg.scrollFactor.set(0, 0);
    bg.color = 0xAF5BAF;
    add(bg);

    grpCredits = new FlxTypedGroup<FlxText>();
    grpIcons = new FlxTypedGroup</*TweakedCreditsIcons*/ FunkinSprite>();
    add(grpCredits);
    add(grpIcons);

    hasDesc = [];
    isSelectable = []; // So it gets reset every state load.
    spawnCredits();

    descBox = new FlxSprite().makeGraphic(FlxG.width - 24, 200, 0x99000000);
    descBox.y = FlxG.height - (descBox.height + 5);
    descBox.x = 12;
    descBox.cameras = [camDesc];
    descBox.visible = false;
    add(descBox);

    descText = new FlxText(0, descBox.getGraphicMidpoint().y, descBox.width, "This is default text", 30);
    descText.setFormat("VCR OSD Mono", 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    descText.cameras = [camDesc];
    descText.screenCenter(X);
    descText.visible = false;
    add(descText);

    changeSelection();
  }

  override function update(elapsed:Float):Void
  {
    if (curSelected == 0 && creditsList[curSelected][1] == 'headerObject') changeSelection(1);
    if (controls.UI_RIGHT_P || controls.UI_DOWN_P)
    {
      changeSelection(1);
    }
    if (controls.UI_LEFT_P || controls.UI_UP_P)
    {
      changeSelection(-1);
    }
    if (controls.ACCEPT)
    {
      if (isSelectable[curSelected])
      {
        browserLoad(creditsList[curSelected][2]);
      }
    }
    if (controls.BACK)
    {
      FlxG.sound.play('cancelMenu');
      FlxG.switchState(() -> new MainCreditsState());
    }
  }

  function spawnCredits():Void
  {
    for (i in 0...creditsList.length)
    {
      var array:Array<String> = creditsList[i];
      var tooShort:Bool = false;
      if (array.length < 1) tooShort = true;
      var size:Int = 30;
      var yPos:Int = (150 * i) + nextOffset;
      if (array.length == 1)
      {
        size = 50;
        yPos += 150;
        nextOffset += 150;
      }
      var textString:String = !tooShort ? creditsList[i][0] : 'This array, "creditsList[$i]" was fucking empty\nMight wanna recheck that lmao';
      var text:FlxText = new FlxText(0, yPos, 0, textString, size);
      text.setFormat(Paths.font('vcr.ttf'), size, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
      text.screenCenter(X);
      if (text.text == '' || text.text == null)
      {
        trace('Error with setting text!');
        text.text = 'Got an error trying to get name!';
      }
      grpCredits.add(text);
      hasDesc.push(creditsList[i].length >= 2);
      isSelectable.push(creditsList[i].length >= 3);
      if (creditsList[i].length == 4)
      {
        var icon:FunkinSprite = FunkinSprite.create(0, 0, 'credits/' + creditsList[i][3]);
        grpIcons.add(icon);
        icon.x = text.x + text.width + 30;
        icon.y = text.y - 75;
        try
        {
          var variable:Bool = icon.graphic.assetsKey == null; // so that it still trys to attach itself, but doesn't trace each time
        }
        catch (e:Dynamic)
        {
          try
          {
            icon.visible = false;
          }
          catch (e:Dynamic)
          {
            trace('ERROR! "$e"');
          }
        }
      }
    }
  }

  function changeSelection(change:Int = 0):Void
  {
    curSelected += change;
    if (curSelected < 0) curSelected = creditsList.length - 1;
    if (curSelected >= creditsList.length) curSelected = 0;

    if (curSelected > 0 && creditsList[curSelected][1] == 'headerObject')
    {
      changeSelection(change);
      return;
    }

    FlxG.sound.play(Paths.sound('scrollMenu'));
    camFollow.y = grpCredits.members[curSelected].y;
    for (i in 0...grpCredits.members.length)
    {
      if (i == curSelected)
      {
        grpCredits.members[i].color = 0xFFDE4B;
      }
      else
      {
        grpCredits.members[i].color = 0xFFFFFF;
      }
    }
    var i:Int = curSelected; // dumb thing remove later when not as lazy :3
    if (hasDesc[i])
    {
      descBox.visible = true;
      descText.visible = true;
      descText.text = creditsList[curSelected][1];
    }
    else if (!hasDesc[i])
    {
      descBox.visible = false;
      descText.visible = false;
      descText.text = '';
    }
  }

  // Because dumb idiot WindowUtil broke on me >:(
  function browserLoad(site:String)
  {
    #if linux
    Sys.command('/usr/bin/xdg-open', [site]);
    #else
    FlxG.openURL(site);
    #end
  }

  static final CREDITS_DATA_PATH:String = 'assets/data/credits/credits.json';

  public static var CREDITS_DATA(get, default):Null<CreditsFile> = null;

  static function get_CREDITS_DATA():CreditsFile
  {
    if (CREDITS_DATA == null) CREDITS_DATA = parseCreditsData(fetchCreditsData());

    return CREDITS_DATA;
  }

  static function parseCreditsData(file:JsonFile):Null<CreditsFile>
  {
    #if !macro
    if (file.contents == null) return null;

    var parser = new json2object.JsonParser<CreditsFile>();
    parser.ignoreUnknownVariables = false;
    trace('[CREDITS] Parsing credits data from ${CREDITS_DATA_PATH}');
    parser.fromJson(file.contents, file.fileName);

    if (parser.errors.length > 0)
    {
      printErrors(parser.errors, file.fileName);
      return null;
    }
    return parser.value;
    #else
    return null;
    #end
  }

  static function fetchCreditsData():funkin.data.JsonFile
  {
    #if !macro
    var rawJson:String;
    try
    {
      rawJson = openfl.Assets.getText(CREDITS_DATA_PATH).trim();
    }
    catch (e:Dynamic)
    {
      trace('SHIT, AN ERROR! $e');
      return {
        fileName: CREDITS_DATA_PATH,
        contents: null
      };
    }

    return {
      fileName: CREDITS_DATA_PATH,
      contents: rawJson
    };
    #else
    return {
      fileName: CREDITS_DATA_PATH,
      contents: null
    };
    #end
  }

  function doCreditsMerge():Void
  {
    for (array in CREDITS_DATA.creditsListData)
    {
      if (!creditsList.contains(array)) creditsList.push(array);
    }
  }

  static function printErrors(errors:Array<json2object.Error>, id:String = ''):Void
  {
    trace('[CREDITS] Failed to parse credits data: ${id}');

    for (error in errors)
      funkin.data.DataError.printError(error);
  }
}
