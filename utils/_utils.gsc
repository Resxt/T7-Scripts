/*
=========================================================================
|                                 Utils                                 |
=========================================================================
| Game: Black Ops III                                                   |
|                                                                       |
| Description: A collection of useful functions                         |
|                                                                       |
| Author: Resxt                                                         |
| Version: 1.0.0                                                        |
| Link: https://github.com/Resxt/T7-Scripts/tree/main/utils             |
=========================================================================
*/

#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_laststand;



#namespace resxt_utils;



/* Utils section */

function ChanceFromPercentage(percent)
{
    return RandomInt(100) <= percent;
}

// Use as a filter in the array::filter function
function ArrayFilterScriptNoteworthy(entity, targetString)
{
	return entity.script_noteworthy == targetString;
}

// Allows for choosing whether you need the function threaded or not, the entity to call the function on, including arrays, and turns a data struct into args
function CallFunction(data)
{
	if (!IsDefined(data.should_thread) || data.should_thread)
	{
		if (IsArray(self))
		{
			array::thread_all(self, data.func, data.arg1, data.arg2, data.arg3, data.arg4, data.arg5, data.arg6);
		}
		else
		{
			util::single_thread(self, data.func, data.arg1, data.arg2, data.arg3, data.arg4, data.arg5, data.arg6);
		}
	}
	else
	{
		if (IsArray(self))
		{
			array::run_all(self, data.func, data.arg1, data.arg2, data.arg3, data.arg4, data.arg5, data.arg6);
		}
		else
		{
			util::single_func(self, data.func, data.arg1, data.arg2, data.arg3, data.arg4, data.arg5, data.arg6);
		}
	}
}

function IsExplosiveMod(mod)
{
	switch (mod)
	{
		case "MOD_GRENADE":
		case "MOD_GRENADE_SPLASH":
		case "MOD_EXPLOSIVE":
		case "MOD_EXPLOSIVE_SPLASH":
		//case "MOD_PROJECTILE":
		case "MOD_PROJECTILE_SPLASH":
			return true;

		default:
			return false;
	}
}

function ParseCsvValue(value, type = "string", defaultNum = undefined)
{
	switch(type)
	{
		case "int":
		return (value == "" ? (defaultNum == undefined ? undefined : int(defaultNum)) : int(value));

		case "int_array":
		if (value == "")
		{
			return undefined;
		}
		else
		{
			values = [];

			foreach (num in StrTok(value, ":"))
			{
				array::add(values, int(num));
			}

			return values;
		}

		case "string_array":
		return (value == "" ? undefined : StrTok(value, ":"));


		default:
		return (value == "" ? undefined : value);
	}
	
	return undefined;
}



/* Snippets section */

function FakeKillZombies(limit = 0)
{
	a_ai = GetAITeamArray("axis");

    foreach(e_ai in a_ai)
    {
		if (zombie_utility::get_current_zombie_count() <= limit)
		{
			break;
		}

        e_ai.marked_for_death = false; // don't kill
        e_ai.marked_for_recycle = true; // do recycle

        wait .05;

        if(IsAlive(e_ai)) e_ai Kill();
    }
}

function PlayFXAndDelete(fx, duration, startOrigin, destinationOrigin, sound)
{
	fxEntity = Spawn("script_model", startOrigin);
	fxEntity SetModel("tag_origin");
	fxEntity NotSolid();

	PlayFXOnTag(fx, fxEntity, "tag_origin");

	if (IsDefined(sound))
	{
		fxEntity PlaySound(sound);
	}

	fxEntity MoveTo(destinationOrigin, duration);

	wait duration;

	fxEntity Delete();
}



/* Player section */

// Can be used with your own info_volume, checks for all players, not just those that are alive
function AllPlayersInVolume(targetname)
{
	inVolume = 0;

	foreach (player in GetPlayers())
	{
		if (player PlayerIsInVolume(targetname))
		{
			inVolume++;
		}
	}

	if (inVolume == level.players.size)
	{
		return true;
	}

	return false;
}

// Can be used with your own info_volume
function PlayerIsInVolume(targetname)
{
	volumes = GetEntArray(targetname, "targetname");

	foreach (volume in volumes)
	{
		if (self IsTouching(volume))
		{
			return true;
		}
	}

	return false;
}

function TeleportPlayer(landingStructs, setAngles = true)
{
	teleported = false;

	while (!teleported)
	{
		foreach (struct in landingStructs)
		{
			if (!PositionWouldTelefrag(struct.origin))
			{
				teleported = true;

				self SetOrigin(struct.origin);

				if (setAngles)
				{
					self SetPlayerAngles(struct.angles);
				}

				break;
			}
		}

		wait 0.05;
	}
}

function EnableAutoSelfRevives()
{
	level.auto_self_revives_used = 0;
	level.no_end_game_check = true;

	foreach (player in GetPlayers())
	{
		player thread AutoSelfRevives();
	}

	callback::on_spawned(&AutoSelfRevives);
}

function DisableAutoSelfRevives()
{
	level.auto_self_revives_used = undefined;
	level.no_end_game_check = false;

	foreach (player in GetPlayers())
	{
		player notify("stop_auto_revives");
	}

	callback::remove_on_spawned(&AutoSelfRevives);
}

function private AutoSelfRevives()
{
	self endon("death");
	self endon("stop_auto_revives");

	for(;;)
	{
		self waittill("entering_last_stand");
		
		wait 0.05;

		level notify("auto_self_revives_used");
		level.auto_self_revives_used++;
		self zm_laststand::auto_revive(self);
	}
}



/* Debug section */

// Used with Sphynx's console commands (https://www.t7wiki.com/add-developer-commands) to print values to the console (making use of the subtitleMessage system)
function DebugPrint(message = "undefined")
{
    foreach(player in GetPlayers())
    {
        util::setClientSysState( "subtitleMessage", message, player);
    }
}