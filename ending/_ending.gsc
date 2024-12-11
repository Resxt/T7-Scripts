/*
=========================================================================
|                                Ending                                 |
=========================================================================
| Game: Black Ops III                                                   |
|                                                                       |
| Description: A customizable ending/buyable ending                     |
|                                                                       |
| Author: Resxt                                                         |
| Version: 1.0.0                                                        |
| Link: https://github.com/Resxt/T7-Scripts/tree/main/ending            |
=========================================================================
*/

#insert scripts\shared\shared.gsh;
#insert scripts\zm\_resxt\_ending.gsh;

#using scripts\shared\system_shared;

#using scripts\zm\_zm_score;



#namespace resxt_ending;

REGISTER_SYSTEM_EX( "resxt_ending", undefined, &Main, undefined )



function Main()
{
	endingTrigger = GetEnt("ending_trigger", "targetname");

	if (ENDING_DISABLED_HINTSTRING != "")
	{
		endingTrigger TriggerEnable(true);
		endingTrigger SetHintString(&ENDING_DISABLED_HINTSTRING);
	}
	else
	{
		endingTrigger TriggerEnable(false);
	}

	level waittill( "all_players_connected" );

	if (ENDING_WAITTILL != "")
	{
		level waittill(ENDING_WAITTILL);
	}

	level.ending_remaining_cost = ENDING_BASE_COST + (ENDING_PER_PLAYER_COST * level.players.size);

	endingTrigger SetHintString(&ENDING_HINTSTRING, level.ending_remaining_cost);
	endingTrigger TriggerEnable(true);
	endingTrigger thread OnEndingTryPay();
}



function OnEndingTryPay()
{
	self endon("death");

	for(;;)
	{
		self waittill("trigger", player);

		if (ENDING_PART_COST != 0 && player zm_score::can_player_purchase(ENDING_PART_COST) && level.ending_remaining_cost > 0) // multiple times purchase
		{
			player zm_score::minus_to_player_score(ENDING_PART_COST);

			level.ending_remaining_cost -= ENDING_PART_COST;

			if (ENDING_PURCHASE_SOUND != "")
			{
				self PlayLocalSound(ENDING_PURCHASE_SOUND);
			}

			if (level.ending_remaining_cost <= 0)
			{
				self EndGame();
			}

			self SetHintString(&ENDING_HINTSTRING, level.ending_remaining_cost);
		}
		else if(ENDING_PART_COST == 0 && player zm_score::can_player_purchase(level.ending_remaining_cost) && level.ending_remaining_cost > 0) // one time purchase
		{
			player zm_score::minus_to_player_score(level.ending_remaining_cost);

			level.ending_remaining_cost -= level.ending_remaining_cost;

			if (ENDING_PURCHASE_SOUND != "")
			{
				self PlayLocalSound(ENDING_PURCHASE_SOUND);
			}

			self EndGame();
		}
		else // not enough points
		{
			if (ENDING_PURCHASE_FAILED_SOUND != "")
			{
				self PlayLocalSound(ENDING_PURCHASE_FAILED_SOUND);
			}
		}
	}
}

function EndGame()
{
	if (ENDING_NOTIFY != "")
	{
		level notify(ENDING_NOTIFY);
	}
	else
	{
		level notify("end_game");
	}

	self Delete();
}