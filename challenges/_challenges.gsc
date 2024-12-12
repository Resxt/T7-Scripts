/*
=========================================================================
|                              Challenges                               |
=========================================================================
| Game: Black Ops III                                                   |
|                                                                       |
| Description: Challenges system                                        |
| It doesn't provide any challenge on its own                           |
| You need to install or implement at least 1 challenge                 |
|                                                                       |
| Author: Resxt                                                         |
| Version: 1.0.0                                                        |
| Link: https://github.com/Resxt/T7-Scripts/tree/main/challenges        |
=========================================================================
*/

#insert scripts\shared\shared.gsh;
#insert scripts\zm\_resxt\_challenges.gsh;

#using scripts\shared\array_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\flag_shared;

#using scripts\zm\_resxt\_utils;



#namespace resxt_challenges;

REGISTER_SYSTEM_EX( "resxt_challenges", &Init, &Main, undefined )



/* Entry point section */

function Init()
{
	level.challenges = [];
}

function Main()
{
	level waittill("initial_blackscreen_passed");

	challengesTrigger = GetEntArray("challenges_trigger", "targetname");
	
	level.challenges_total = 0; // the amount of challenges that are in-use, this is only set for other scripts to have that info
	level.challenges_removed = []; // challenges are added to this array when they're added to the challenges list so they cannot be picked more than once
	level.challenges_remaining = (CHALLENGES_AMOUNT == 0 ? challengesTrigger.size : CHALLENGES_AMOUNT); // the amount of challenges remaining before they're all completed

	foreach (challengeTrigger in challengesTrigger) // add reserved challenges to the challenges in use
	{
		if (IsDefined(challengeTrigger.script_noteworthy))
		{
			splitted = StrTok(challengeTrigger.script_noteworthy, ",");
			challengeTrigger.script_noteworthy = splitted[RandomInt(splitted.size)];

			level.challenges_total++;

			foreach (challenge in splitted)
			{
				array::add(level.challenges_removed, challenge);
			}
		}
	}

	foreach (challengeTrigger in challengesTrigger) // triggers with no reserved challenges get a random remaining challenge
	{
		if (!IsDefined(challengeTrigger.script_noteworthy))
		{
			challengeName = array::random(array::exclude(GetArrayKeys(level.challenges), level.challenges_removed));
			array::add(level.challenges_removed, challengeName);
			challengeTrigger.script_noteworthy = challengeName;

			level.challenges_total++;
		}

		challengeTrigger SetHintString(level.challenges[challengeTrigger.script_noteworthy].hintstring);
		challengeTrigger thread OnChallengeStarted();
	}

	ToggleChallengesTriggers(true);
}



/* Challenge logic section */

function OnChallengeStarted()
{
	self endon("challenge_completed");

	for (;;)
	{
		self waittill("trigger");

		StartChallenge(self.script_noteworthy);
	}
}

function StartChallenge(challengeName)
{
	ToggleChallengesTriggers(false);

	resxt_utils::CallFunction(level.challenges[challengeName].logicFuncData);

	self thread OnChallengeCompleted(challengeName);
}

function CancelChallenge()
{
	DestroyChallengeHud();
	ToggleChallengesTriggers(true);

	level notify("challenge_failed");
}

function OnChallengeCompleted(challengeName)
{
	level endon("challenge_failed");
	level waittill("challenge_completed");

	self notify("challenge_completed");

	level.challenges_remaining--;

	DestroyChallengeHud();

	ToggleChallengesTriggers(true);

	if (IsDefined(level.challenges_any_completed_func_data))
	{
		resxt_utils::CallFunction(level.challenges_any_completed_func_data);
	}

	if (IsDefined(level.challenges[challengeName].completedFuncData))
	{
		resxt_utils::CallFunction(level.challenges[challengeName].completedFuncData);
	}

	if (level.challenges_remaining == 0)
	{
		if (IsDefined(level.challenges_all_completed_func_data))
		{
			resxt_utils::CallFunction(level.challenges_all_completed_func_data);
		}
	}

	self Delete();
}

function ToggleChallengesTriggers(enabled)
{
	foreach (challengeTrigger in GetEntArray("challenges_trigger", "targetname"))
	{
		challengeTrigger TriggerEnable(enabled);
	}
}



/* HUD section */

function DisplayChallengeHud(text, value)
{
	level.challenge_hud_bar = hud::createServerBar((0.478, 0.667, 0.765), 250, 10, 0, "allies", true);
	level.challenge_hud_bar hud::SetPoint("TOPCENTER", "TOPCENTER");
	level.challenge_hud_bar.hideWhenInMenu = true;

	level.challenge_hud_text = hud::createServerFontString("big", 1, "allies");
	level.challenge_hud_text hud::SetPoint("TOPCENTER", "TOPCENTER", 0, 10);
	level.challenge_hud_text.hideWhenInMenu = true;
	
	if (IsDefined(value))
	{
		level.challenge_hud_text SetText(text, value);
	}
	else
	{
		level.challenge_hud_text SetText(text);
	}
}

function UpdateChallengeHud(newPercentage)
{
	level.challenge_progression_percentage = newPercentage;
	level.challenge_hud_bar thread hud::updateBar((newPercentage / 100));
}

function DestroyChallengeHud()
{
	level.challenge_hud_bar hud::destroyelem();
	level.challenge_hud_text hud::destroyelem();
}