package funkin.ui.credits;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;
import funkin.audio.FunkinSound;
import funkin.ui.credits.tweaked.TweakedCredits;
import funkin.ui.mainmenu.MainMenuState;

// WATCH OUT IMMA MAKE A STATE REMINISCENT OF PSYCH ENGINE MODDING OH GOD.

/**
 * A state for handling which credits state you wanna go to.
 */
class MainCreditsState extends MusicBeatState
{
  var optionShit:Array<String> = ['Base Game Credits', 'Funkin\': Tweaked Credits'];
  var formattedOptions:Array<String> = ['funkin', 'tweaked']; // fuck you lmao
  var bg:FlxSprite;
  var grpOptions:FlxTypedGroup<FlxText> /*<Alphabet>*/;
  var curSelected:Int = 0;
  var unfinished:FlxText;
  var unfinishedBG:FlxSprite;

  override function create():Void
  {
    bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
    add(bg);

    grpOptions = new FlxTypedGroup<FlxText>();
    add(grpOptions);

    var pos:Int = 0;
    for (option in optionShit)
    {
      pos++;
      var pos2:Int = 0;
      if (pos == 2) pos2 = 1;
      var text:FlxText = new FlxText(50, 150 * pos2, FlxG.width - 50, option, 30);
      text.setFormat(Paths.font('vcr.ttf'), 50, 0xFFFFFFFF, CENTER, OUTLINE, 0xFF000000);
      grpOptions.add(text);
    }
    changeSelection();
    unfinished = new FlxText(0, 0, 0, "THIS STATE ISNT READY YET!", 30);
    unfinished.setFormat(Paths.font('vcr.ttf'), 50, 0xFFFFFFFF, CENTER, OUTLINE, 0xFF000000);
    unfinished.alpha = 0;

    unfinishedBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    unfinishedBG.alpha = 0;
    add(unfinishedBG);
    add(unfinished);
    // Music
    FunkinSound.playMusic('freeplayRandom',
      {
        startingVolume: 0.0,
        overrideExisting: true,
        restartTrack: true,
        loop: true
      });
    FlxG.sound.music.fadeIn(6, 0, 0.8);
  }

  var textTween:FlxTween;
  var bgTween:FlxTween;

  override function update(elapsed:Float):Void
  {
    if (controls.UI_LEFT_P || controls.UI_UP_P)
    {
      changeSelection(-1);
    }
    if (controls.UI_RIGHT_P || controls.UI_DOWN_P)
    {
      changeSelection(1);
    }
    if (controls.ACCEPT)
    {
      switch (formattedOptions[curSelected])
      {
        case 'funkin':
          FlxG.switchState(() -> new CreditsState());
        case 'tweaked':
          /*unfinishedBG.alpha = 0.6;
            unfinished.alpha = 1;
            if (textTween != null) textTween.cancel();
            if (bgTween != null) bgTween.cancel();
            textTween = FlxTween.tween(unfinished, {alpha: 0}, 5);
            bgTween = FlxTween.tween(unfinishedBG, {alpha: 0}, 5); */
          FlxG.switchState(() -> new TweakedCredits());
      }
    }
    if (controls.BACK)
    {
      FlxG.sound.play('cancelMenu');
      FlxG.switchState(() -> new MainMenuState());
    }
  }

  function changeSelection(change:Int = 0):Void
  {
    curSelected += change;
    if (curSelected >= optionShit.length) curSelected = 0;
    if (curSelected < 0) curSelected = optionShit.length - 1;

    FlxG.sound.play(Paths.sound('scrollMenu'));

    for (i in 0...optionShit.length)
    {
      if (i == curSelected)
      {
        grpOptions.members[i].color = 0xFFDE4B;
      }
      else
      {
        grpOptions.members[i].color = 0xFFFFFF;
      }
    }
  }
}
