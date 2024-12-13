/*
=========================================================================
|                            Simon challenge                            |
=========================================================================
| Game: Black Ops III                                                   |
|                                                                       |
| Description: Simon game, as a challenge                               |
| Link: https://github.com/Resxt/T7-Scripts/tree/main/challenges        |
|                                                                       |
| Author: Resxt                                                         |
| Version: 1.0.0                                                        |
=========================================================================
*/

#insert scripts\shared\shared.gsh;
#insert scripts\zm\_resxt\challenges\_challenge_simon.gsh;

#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;

#using scripts\zm\_resxt\_challenges;
#using scripts\zm\_resxt\_utils;



#namespace resxt_challenge_simon;

REGISTER_SYSTEM_EX( "resxt_challenge_simon", undefined, &Main, undefined )



function Main()
{
	targets = GetEntArray("simon_challenge_target", "targetname");
	targetsOff = array::filter(targets, false, &resxt_utils::ArrayFilterScriptNoteworthy, "off");
	targetsOn = array::filter(targets, false, &resxt_utils::ArrayFilterScriptNoteworthy, "on");

	level.simon_challenge_off_targets = array::sort_by_script_int(targetsOff, true);
	level.simon_challenge_on_targets = array::sort_by_script_int(targetsOn, true);
	level.simon_challenge_wrong_target = GetEnt("simon_challenge_target_wrong", "targetname");
	level.simon_challenge_wrong_target Hide();

	level.simon_challenge_targets_sound = undefined;

	if (SIMON_TARGETS_SOUND != "")
	{
		if (IsSubStr(SIMON_TARGETS_SOUND, ","))
		{
			level.simon_challenge_targets_sound = StrTok(SIMON_TARGETS_SOUND, ",");
		}
		else
		{
			level.simon_challenge_targets_sound = SIMON_TARGETS_SOUND;
		}
	}

	array::run_all(level.simon_challenge_on_targets, &Hide);
}



function StartSimonChallenge(startRound, endRound)
{
	result = false;
	reference = &SIMON_CHALLENGE_HUD_STRING;
	
	if (IsSubStr(MakeLocalizedString(reference), "&&1"))
	{
		resxt_challenges::DisplayChallengeHud(reference, ((endRound + 1) - startRound));
	}
	else
	{
		resxt_challenges::DisplayChallengeHud(reference);
	}

	wait 0.5;
	
	for (currentRound = startRound; currentRound <= endRound; currentRound++)
	{
		result = StartSimon(currentRound, result);

		if (result)
		{
			newPercentage = (((currentRound + 1) - startRound) * 100) / ((endRound + 1) - startRound);

			resxt_challenges::UpdateChallengeHud(newPercentage);
		}
		else
		{
			currentRound--;
		}

		if (currentRound != endRound)
		{
			wait SIMON_BETWEEN_ROUNDS_TIME;
		}
	}

	level notify("challenge_completed");
}

function StartSimon(count, shouldAddTarget)
{
	level.simon_challenge_targets_shot = 0;

	if (SIMON_START_ROUND_SOUND != "")
	{
		self PlaySound(SIMON_START_ROUND_SOUND);
	}

	wait SIMON_BEFORE_SHOW_TIME;

	if (SIMON_RANDOMIZE_ROUNDS || !IsDefined(level.simon_challenge_can_be_shot)) // even if SIMON_RANDOMIZE_ROUNDS is false we need to initialize several targets (count) at first
	{
		level.simon_challenge_targets = [];

		for (i = 0; i < count; i++)
		{
			target = array::random(level.simon_challenge_off_targets);
			array::add(level.simon_challenge_targets, target.script_int, true);
			ToggleSimonTarget(target.script_int, SIMON_TARGET_SHOW_TIME); // time each target is shown
			wait SIMON_BETWEEN_TARGETS_TIME; // time between each target shown
		}
	}
	else
	{
		if (shouldAddTarget)
		{
			newTarget = array::random(level.simon_challenge_off_targets);
			array::add(level.simon_challenge_targets, newTarget.script_int, true);
		}

		foreach (num in level.simon_challenge_targets)
		{
			ToggleSimonTarget(num, SIMON_TARGET_SHOW_TIME); // time each target is shown
			wait SIMON_BETWEEN_TARGETS_TIME; // time between each target shown
		}
	}

	level.simon_challenge_can_be_shot = true;

	for (i = 0; i < level.simon_challenge_off_targets.size; i++)
	{
		level.simon_challenge_off_targets[i] SetCanDamage(true);
		level.simon_challenge_off_targets[i] thread OnSimonTargetShot();
	}

	result = level util::waittill_any_return("simon_challenge_round_completed", "simon_challenge_round_failed");

	if (result == "simon_challenge_round_completed")
	{
		return true;
	}
	else
	{
		return false;
	}
}

function OnSimonTargetShot()
{
	level endon("simon_challenge_round_completed");
	level endon("simon_challenge_round_failed");

	for (;;)
	{
		self waittill("damage", n_damage, e_attacker, v_dir, v_loc, str_type);

		if (!resxt_utils::IsExplosiveMod() && level.simon_challenge_can_be_shot)
		{
			level.simon_challenge_can_be_shot = false;

			if (level.simon_challenge_targets[level.simon_challenge_targets_shot] == self.script_int)
			{
				level.simon_challenge_targets_shot++;

				ToggleSimonTarget(self.script_int, SIMON_TARGET_SHOT_SHOW_TIME);

				if (level.simon_challenge_targets_shot == level.simon_challenge_targets.size)
				{
					if (SIMON_WIN_SOUND != "")
					{
						self PlaySound(SIMON_WIN_SOUND);
					}

					level notify("simon_challenge_round_completed");
				}
				else
				{
					level.simon_challenge_can_be_shot = true;
				}
			}
			else
			{
				ShowWrongSimonTarget(self.script_int);

				level notify("simon_challenge_round_failed");
			}
		}
	}
}

function ToggleSimonTarget(num, time)
{
	num = num - 1;
	time = time - 0.10;

	level.simon_challenge_on_targets[num] Show();

	if (IsDefined(level.simon_challenge_targets_sound))
	{
		if (IsArray(level.simon_challenge_targets_sound))
		{
			level.simon_challenge_on_targets[num] PlaySound(level.simon_challenge_targets_sound[num]);
		}
		else
		{
			level.simon_challenge_on_targets[num] PlaySound(level.simon_challenge_targets_sound);
		}
	}
	
	wait 0.05;
	level.simon_challenge_off_targets[num] Hide();

	wait time;

	level.simon_challenge_off_targets[num] Show();
	wait 0.05;
	level.simon_challenge_on_targets[num] Hide();
}

function ShowWrongSimonTarget(num)
{
	num = num - 1;
	time = SIMON_TARGET_SHOW_TIME - 0.10;

	level.simon_challenge_wrong_target.origin = level.simon_challenge_off_targets[num].origin;
	level.simon_challenge_wrong_target Show();

	if (SIMON_LOSE_SOUND != "")
	{
		level.simon_challenge_wrong_target PlaySound(SIMON_LOSE_SOUND);
	}

	wait 0.05;
	level.simon_challenge_off_targets[num] Hide();

	wait time;

	level.simon_challenge_off_targets[num] Show();
	wait 0.05;
	level.simon_challenge_wrong_target Hide();
}

function SimonChallengeCleanup()
{
	array::run_all(level.simon_challenge_off_targets, &Delete);
	array::run_all(level.simon_challenge_on_targets, &Delete);
	
	level.simon_challenge_wrong_target Delete();
}