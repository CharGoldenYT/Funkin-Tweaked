package funkin.ui.credits.tweaked;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;
import funkin.ui.credits.tweaked.TweakedCreditsIcons as TweakedCreditsIcon;
import funkin.ui.credits.MainCreditsState;
import funkin.util.WindowUtil;

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
  var creditsList:Array<Array<String>> = [
    ["Funkin' Tweaked"],
    [
      'CharGolden',
      "Coded Funkin' Tweaked",
      "https://www.youtube.com/channel/UC930b1Q9I8Ufdv-8uKX1mtw/",
      'char'
    ],
    ["Suggestors, Collaborators, and Other"],
    [
      'ShadowMario',
      "Coded Psych Engine, of which i based some code off of.",
      "https://twitter.com/Shadow_Mario_",
      'shadowmario'
    ],
    ['djebuscool', "Suggested Note Lanes", "https://gamebanana.com/members/1981704"],
    [
      'JamJarIsDumb',
      "Originally thought of the option for a transparent Strumline",
      "https://github.com/JamJarIsDumb"
    ]
  ];

  // Draw Objects
  var bg:FlxSprite;

  /**
   * Whether an entry has a link assosciated with it.
   */
  var isSelectable:Array<Bool>;

  var curSelected:Int = 0;
  var grpCredits:FlxTypedGroup<FlxText> /**<Alphabet>**/;
  var grpIcons:FlxTypedGroup<TweakedCreditsIcons>;

  /**
   * Whether an entry has a description.
   */
  var hasDesc:Array<Bool>;

  var camCredits:FlxCamera;
  var camDesc:FlxCamera;
  var camFollow:FlxObject;
  var descBox:FlxSprite;
  var descText:FlxText;

  override function create():Void
  {
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
    grpIcons = new FlxTypedGroup<TweakedCreditsIcons>();
    add(grpCredits);
    add(grpIcons);

    hasDesc = [];
    isSelectable = []; // So it gets reset every state load.

    var nextOffset:Int = 0;
    for (i in 0...creditsList.length)
    {
      var array:Array<String> = creditsList[i];
      var tooShort:Bool = false;
      if (array.length < 1) tooShort = true;
      if (tooShort)
      {
        trace('creditsList[$i] is too short! double check that it is a proper array!');
        return;
      }
      var size:Int = 30;
      var yPos:Int = (150 * i) + nextOffset;
      if (array.length == 1)
      {
        size = 50;
        yPos += 150;
        nextOffset += 150;
      }
      var text:FlxText = new FlxText(0, yPos, 0, creditsList[i][0], size);
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
        var icon:TweakedCreditsIcon = new TweakedCreditsIcon(0, 0, creditsList[i][3], false);
        grpIcons.add(icon);
        icon.x = text.x + text.width + 30;
        icon.y = text.y - 75;
      }
    }

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
        WindowUtil.openURL(creditsList[curSelected][3]);
      }
    }
    if (controls.BACK)
    {
      FlxG.sound.play('cancelMenu');
      FlxG.switchState(() -> new MainCreditsState());
    }
  }

  function changeSelection(change:Int = 0):Void
  {
    curSelected += change;
    if (curSelected < 0) curSelected = creditsList.length - 1;
    if (curSelected >= creditsList.length) curSelected = 0;

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
}
