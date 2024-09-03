IMPORTANT:

	IF YOU WISH TO MESS WITH THESE NEW ADDITIONS TO PLAYSTATE HERES THE VARIABLE NAMES AND WHAT THEY'RE FOR.
MAKE SURE THAT YOUR CODE HAS "if (PlayState.instance != null)" BEFORE MESSING WITH ANY PLAYSTATE VARIABLES IF USING "onUpdate(elapsed)" AND FOR ANY VARIABLE LISTED HERE, YOU HAVE TO SPECIFY "PlayState.instance.<variable>" AS THEY ARE NOT STATIC!

example:
"if (PlayState.instance != null)
	{
		if (PlayState.instance.sicks == 5)
			{
				trace('nice!');
			}
	}


Note Lanes:
	"notLane": FlxSprite for the Player Note Lane
	"notLane2": Ditto but Opponent

Hit Timing Text:
	"hitTime" FlxText for when you hit a note, displaying how early or late it was pressed.

Score Text:
	"scoreText" FlxText tracks your score.

Ratings:
	"sicks", "goods", "bads", "shits" Should be self explanatory. Integer (NOTE: Does not currently mess with Highscore tallies)
	"totalPlayed" How many notes have been checked (regardless of hit or miss). Integer
	"totalNotesHit" How many notes successfully hit. Integer
	"totalLatency" Combined latency of every hit so far. Float
	"ratingFC" The string that changes the first half of the rating (i.e. displaying "Perfect! (SFC, ".
	"ratingPercent" The Float that represents how good you're playing (AKA Accuracy)

Time Bar:
	"timeBar" FlxBar that displays how much time is left.
	"timePercent" How much from 0 to one is left on the timer
	"songLength" How much time until the bar is full in milliseconds basically (Float used in calculations for the Song Time Text).

Notes:
	"forceOpaqueStrumlineVar" Force off Transparent Strums if enabled.
	"blockStrumlineAlphaChanges" If you need to prevent the press, static, AND confirm anims from changing note alphas, or being transparent, set this to true!