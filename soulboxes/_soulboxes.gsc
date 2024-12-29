/*
=========================================================================
|                               Soulboxes                               |
=========================================================================
| Game: Black Ops III                                                   |
|                                                                       |
| Description: Fills a soulbox when a zombie is killed in radius        |
| Link: https://github.com/Resxt/T7-Scripts/tree/main/soulboxes         |
|                                                                       |
| Author: Resxt                                                         |
| Version: 1.0.0                                                        |
=========================================================================
*/

#insert scripts\shared\shared.gsh;
#insert scripts\zm\_resxt\_soulboxes.gsh;

#using scripts\shared\system_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_zm_spawner;

#using scripts\zm\_resxt\_utils;



#precache("fx", SOULBOXES_FX);
#precache("model", SOULBOXES_MODEL_OFF);



#namespace resxt_soulboxes;

REGISTER_SYSTEM_EX( "resxt_soulboxes", undefined, &Main, undefined )



function Main()
{
	level.soulboxes = GetEntArray("soulboxes", "targetname");

	zm_spawner::register_zombie_death_event_callback(&OnZombieKilled);

	foreach(soulbox in level.soulboxes)
	{
		soulbox.souls_collected = 0;
	}
}

function OnZombieKilled()
{
	if (!IS_TRUE(self.completed_emerging_into_playable_area))
	{		
		return;
	}

	soulbox = ArrayGetClosest(self.origin, level.soulboxes);

	if (Distance(self.origin, soulbox.origin) <= SOULBOXES_RADIUS && soulbox.souls_collected < SOULBOXES_SOULS_PER_SOULBOX)
	{
		soulbox.souls_collected++;

		soulbox thread resxt_utils::PlayFXAndDelete(SOULBOXES_FX, 2, self GetTagOrigin("J_SpineUpper"), soulbox.origin + SOULBOXES_SOUL_VECTOR, SOULBOXES_SOUL_SOUND);

		if (soulbox.souls_collected == SOULBOXES_SOULS_PER_SOULBOX)
		{
			soulbox thread OnSoulboxCompleted();
		}
	}
}

function OnSoulboxCompleted()
{
	level.soulboxes = array::exclude(level.soulboxes, self);

	if (SOULBOXES_FILLED_SOUND != "")
	{
		self PlaySound(SOULBOXES_FILLED_SOUND);
	}

	if (SOULBOXES_MODEL_OFF != "")
	{
		self SetModel(SOULBOXES_MODEL_OFF);
	}

	if (IsDefined(level.soulboxes_any_completed_func_data))
	{
		resxt_utils::CallFunction(level.soulboxes_any_completed_func_data);
	}

	if (level.soulboxes.size == 0)
	{
		zm_spawner::deregister_zombie_death_event_callback(&OnZombieKilled);

		if (IsDefined(level.soulboxes_all_completed_func_data))
		{
			resxt_utils::CallFunction(level.soulboxes_all_completed_func_data);
		}
	}
}