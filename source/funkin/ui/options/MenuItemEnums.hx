package funkin.ui.options;

// Add enums for use with `EnumPreferenceItem` here!
/* Example:
  class MyOptionEnum
  {
    public static inline var YuhUh = "true";  // "true" is the value's ID
    public static inline var NuhUh = "false";
  }
 */
class NoteSkinEnum
{
  static final baseNoteskinOptions:Array<String> = ['Default'];

  public static var noteskinOptions(get, null):Map<String, String> = [];

  static function get_noteskinOptions():Map<String, String>
  {
    var skinList:Map<String, String> = [];
    var noteSkinText:String = null;
    // For now this function will just push the default list
    for (key in baseNoteskinOptions)
    {
      skinList[key] = key;
    }
    try
    {
      noteSkinText = (openfl.Assets.getText('assets/images/noteSkins/list.txt').trim()).toLowerCase();
    }
    catch (e:Any)
    {
      trace('ERROR GETTING NOTE SKINS! $e');
    }
    if (noteSkinText != null)
    {
      var textSkinList:Array<String> = noteSkinText.split('\n');
      for (skin in textSkinList)
      {
        skinList[skin] = skin;
      }
    }
    return skinList;
  }
}
