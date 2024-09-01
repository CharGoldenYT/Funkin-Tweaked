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
  static final baseNoteskinOptions:Array<String> = ['Default', 'blue'];

  public static var noteskinOptions(get, null):Map<String, String> = [];

  static function get_noteskinOptions():Map<String, String>
  {
    var skinList:Map<String, String> = [];
    // For now this function will just push the default list
    // TODO: Make this detect note skins!
    for (key in baseNoteskinOptions)
    {
      skinList[key] = key;
    }
    return skinList;
  }
}
