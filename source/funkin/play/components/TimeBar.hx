package funkin.play.components;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import funkin.graphics.FunkinSprite;

class TimeBar extends FlxSpriteGroup
{
  public var leftBar:FlxSprite;
  public var rightBar:FlxSprite;
  public var bg:FunkinSprite;
  public var backupBG:FlxSprite;
  public var valueFunction:Void->Float = null;
  public var percent(default, set):Float = 0;
  public var bounds:Dynamic = {min: 0, max: 1};
  public var leftToRight(default, set):Bool = true;
  public var barCenter(default, null):Float = 0;
  public var instance:TimeBar;
  public var isEmpty:Bool = false;

  // you might need to change this if you want to use a custom bar
  public var barWidth(default, set):Int = 1;
  public var barHeight(default, set):Int = 1;
  public var barOffset:FlxPoint = new FlxPoint(3, 3);

  public function new(x:Float, y:Float, image:String = 'healthBar', valueFunction:Void->Float = null, boundX:Float = 0, boundY:Float = 1)
  {
    instance = this;
    super(x, y);
    backupBG = new FlxSprite().makeGraphic(301, 38, 0x00000000);

    this.valueFunction = valueFunction;
    setBounds(boundX, boundY);

    bg = FunkinSprite.create(0, 0, image);
    try
    {
      trace(bg.graphic.assetsKey == null);
      if (bg.graphic.assetsKey != null)
      {
        trace(bg.graphic.assetsKey);
      }
    }
    catch (e:Any)
    {
      trace('COULDN\'T FIND $image!');
      set_isEmpty(true);
    }

    var height:Int = !isEmpty ? Std.int(bg.height) : Std.int(backupBG.height);
    var width:Int = !isEmpty ? Std.int(bg.width) : Std.int(backupBG.width);
    barWidth = width - 6;
    barHeight = height - 6;

    leftBar = new FlxSprite().makeGraphic(width, height, 0xFFFFFFFF);

    rightBar = new FlxSprite().makeGraphic(width, height, 0xFFFFFFFF);
    rightBar.color = 0x00000000;

    if (this.instance.isEmpty) add(backupBG);
    // ordered like this so the Bars dont get hidden by the backup bg :D
    add(leftBar);
    add(rightBar);
    if (!this.instance.isEmpty) add(bg);
    regenerateClips();
  }

  function set_isEmpty(bool:Bool = false):Void
  {
    isEmpty = bool;
  }

  public var enabled:Bool = true;

  override function update(elapsed:Float):Void
  {
    if (!enabled)
    {
      super.update(elapsed);
      return;
    }

    if (valueFunction != null)
    {
      var value:Null<Float> = FlxMath.remapToRange(FlxMath.bound(valueFunction(), bounds.min, bounds.max), bounds.min, bounds.max, 0, 100);
      percent = (value != null ? value : 0);
    }
    else
      percent = 0;
    super.update(elapsed);
  }

  public function setBounds(min:Float, max:Float):Void
  {
    bounds.min = min;
    bounds.max = max;
  }

  public function setColors(left:FlxColor = null, right:FlxColor = null):Void
  {
    if (left != null) leftBar.color = left;
    if (right != null) rightBar.color = right;
  }

  public function updateBar():Void
  {
    if (leftBar == null || rightBar == null) return;

    leftBar.setPosition(bg.x, bg.y);
    rightBar.setPosition(bg.x, bg.y);

    var leftSize:Float = 0;
    if (leftToRight) leftSize = FlxMath.lerp(0, barWidth, percent / 100);
    else
      leftSize = FlxMath.lerp(0, barWidth, 1 - percent / 100);

    leftBar.clipRect.width = leftSize;
    leftBar.clipRect.height = barHeight;
    leftBar.clipRect.x = barOffset.x;
    leftBar.clipRect.y = barOffset.y;

    rightBar.clipRect.width = barWidth - leftSize;
    rightBar.clipRect.height = barHeight;
    rightBar.clipRect.x = barOffset.x + leftSize;
    rightBar.clipRect.y = barOffset.y;

    barCenter = leftBar.x + leftSize + barOffset.x;

    // flixel is retarded
    leftBar.clipRect = leftBar.clipRect;
    rightBar.clipRect = rightBar.clipRect;
  }

  public function regenerateClips():Void
  {
    if (leftBar != null)
    {
      leftBar.setGraphicSize(Std.int(bg.width), Std.int(bg.height));
      leftBar.updateHitbox();
      leftBar.clipRect = new FlxRect(0, 0, Std.int(bg.width), Std.int(bg.height));
    }
    if (rightBar != null)
    {
      rightBar.setGraphicSize(Std.int(bg.width), Std.int(bg.height));
      rightBar.updateHitbox();
      rightBar.clipRect = new FlxRect(0, 0, Std.int(bg.width), Std.int(bg.height));
    }
    updateBar();
  }

  function set_percent(value:Float):Float
  {
    var doUpdate:Bool = false;
    if (value != percent) doUpdate = true;
    percent = value;

    if (doUpdate) updateBar();
    return value;
  }

  function set_leftToRight(value:Bool):Bool
  {
    leftToRight = value;
    updateBar();
    return value;
  }

  function set_barWidth(value:Int):Int
  {
    barWidth = value;
    regenerateClips();
    return value;
  }

  function set_barHeight(value:Int):Int
  {
    barHeight = value;
    regenerateClips();
    return value;
  }
}
