package funkin.ui.credits.tweaked;

import flixel.FlxSprite;
import sys.FileSystem;

/**
 * A class that spawns an icon based on what the input icon string is.
 */
class TweakedCreditsIcons extends FlxSprite
{
  /**
   * The FlxText this object should stick to.
   */
  public var sprTracker:FlxSprite;

  public function new(x:Int, y:Int, icon:String, flipIcon:Bool = false):Void
  {
    super();

    makeCreditsIcon(x, y, icon, flipIcon);
  }

  function makeCreditsIcon(x:Int, y:Int, char:String, flipIcon:Bool = false):Void
  {
    var name:String = 'credits/$char';
    if (!FileSystem.exists('./assets/images/$name.png'))
    {
      name = 'credits/icon-$char'; // In case someone uses icon-char for some reason.
    }
    if (!FileSystem.exists('./assets/images/$name.png'))
    {
      trace('"$name" not found!');
      name = 'credits/missing_icon';
    }
    var file:String = Paths.image(name);

    loadGraphic(file);

    if (flipIcon) this.flipX = true;

    updateHitbox();

    this.x = x;
    this.y = y;
  }

  override function update(elapsed:Float):Void
  {
    if (sprTracker != null)
    {
      this.x = sprTracker.x;
      this.y = sprTracker.y;
    }
  }
}
