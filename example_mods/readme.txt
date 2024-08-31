IMPORTANT:

	IF YOU WISH TO MESS WITH THESE NEW ADDITIONS TO PLAYSTATE HERES THE VARIABLE NAMES AND WHAT THEY'RE FOR.
MAKE SURE THAT YOUR CODE HAS "if (PlayState.instance != null)" BEFORE MESSING WITH ANY PLAYSTATE VARIABLES IF USING "onUpdate(elapsed)" AND FOR ANY VARIABLE LISTED HERE, YOU HAVE TO SPECIFY "PlayState.instance.<variable>" AS THEY ARE NOT STATIC!

example:
"if (PlayState.instance != null)
	{
		if (PlayState.instance.red == 0xFFFF00FF)
			{
				trace('bar is pink');
			}
	}


Note Lanes:
	"notLane": FlxSprite for the Player Note Lane
	"notLane2": Ditto but Opponent

HealthBar:
	"red" FlxColor for Opponent part of HealthBar not very useful, but good for checking if the Healthbar is a certain color on one side!
	"green" Ditto but Player

Hit Timing Text:
	"hitTime" FlxText for when you hit a note, displaying how early or late it was pressed.

Score Text:
	can now be called via "scoreText" and is a FlxText object.

Ratings:
	"sicks", "goods", "bads", "shits" Should be self explanatory. Integer (NOTE: Does not currently mess with Highscore tallies)
	"totalPlayed" How many notes have been checked (regardless of hit or miss). Integer
	"totalNotesHit" How many notes successfully hit. Integer
	"totalLatency" Combined latency of every hit so far. Float
	"ratingFC" The string that changes the first half of the rating (i.e. displaying "Perfect! (SFC, ".

Time Bar:
	"timeBar" FlxBar that displays how much time is left.
	"timePercent" How much from 0 to one is left on the timer
	"songLength" How much time until the bar is full in milliseconds basically (Float used in calculations for the Song Time Text).

Song Length:
	made "currentSongLengthMs" public (NOT SETTABLE, THAT WILL CAUSE ERRORS!) so you can have things happen upon a certain timestamp (use make sure if you're using seconds, to use a seconds to milliseconds converter!)

Notes:
	"forceOpaqueStrumlineVar" Force off Transparent Strums if enabled.
	"blockStrumlineAlphaChanges" If you need to prevent the press, static, AND confirm anims from changing note alphas, or being transparent, set this to true!