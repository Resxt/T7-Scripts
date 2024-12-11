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
	if (!IsDefined(data.entity))
	{
		data.entity = self;
	}
	
	if (!IsDefined(data.should_thread) || data.should_thread)
	{
		if (IsArray(data.entity))
		{
			array::thread_all(data.entity, data.func, data.arg1, data.arg2, data.arg3, data.arg4, data.arg5, data.arg6);
		}
		else
		{
			util::single_thread(data.entity, data.func, data.arg1, data.arg2, data.arg3, data.arg4, data.arg5, data.arg6);
		}
	}
	else
	{
		if (IsArray(data.entity))
		{
			array::run_all(data.entity, data.func, data.arg1, data.arg2, data.arg3, data.arg4, data.arg5, data.arg6);
		}
		else
		{
			util::single_func(data.entity, data.func, data.arg1, data.arg2, data.arg3, data.arg4, data.arg5, data.arg6);
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



/* Debug section */

// Used with Sphynx's console commands (https://www.t7wiki.com/add-developer-commands) to print values to the console (making use of the subtitleMessage system)
function DebugPrint(message = "undefined")
{
    foreach(player in GetPlayers())
    {
        util::setClientSysState( "subtitleMessage", message, player);
    }
}