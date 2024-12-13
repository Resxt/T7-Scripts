# Simon challenge

A customizable [simon game](https://en.wikipedia.org/wiki/Simon_(game)), as a challenge.  
If you want to use it outside of my challenges system you can refer to [Using a script without the challenge system](../README.md#using-a-script-without-the-challenge-system).  

## Features

All these features can easily be customized by editing the GSH file provided

- Stick to the original simon rules of adding a color/target to an existing pattern each round or randomize colors/targets each round
- Configure the time targets are displayed, the time between rounds and so on
- Configure the sounds when targets are displayed/shot, when a wrong target is shot and so on

## Basic setup

**[Important]**
This script needs [my utils](../../utils) to work

**[Important]**
Like all the challenges I release, this works as a module for the challenges script.  
Make sure the [core challenges script](../) is installed.  

Drag and drop the files in `Call of Duty Black Ops III\share\raw\scripts\zm\_resxt\challenges`  
Create any missing folder

In your [zone file](../README.md#zone-file) add these lines

```c
scriptparsetree,scripts/zm/_resxt/challenges/_challenge_simon.gsc
scriptparsetree,scripts/zm/_resxt/challenges/_challenge_simon.gsh
```

In your [mapname GSC](../README.md#glossary) file add these lines

```c
#using scripts\zm\_resxt\challenges\_challenge_simon;
#insert scripts\zm\_resxt\challenges\_challenge_simon.gsh;
```

## Script setup

Open the [GSH file](../README.md#glossary), review and edit the values.  
Make sure to read [Customization](#customization) to not misconfigure anything.  

In your map's [STR file](../README.md#localized-strings) add entries for the hintstring and the challenge's HUD string.  
Make sure to edit the GSH file accordingly.  
Below is an example of what you can add to your STR file.  

```c
REFERENCE           SIMON_CHALLENGE_HINTSTRING
LANG_ENGLISH            "Press &&1 to start the simon mini-game"

REFERENCE           SIMON_CHALLENGE_HUD_STRING
LANG_ENGLISH            "Win &&1 rounds of the simon mini-game"
```

[Precache](../README.md#precaching) the hintstring that will be used in your mapname GSC.  
You can copy paste the example below as is no matter how you named it in your STR file, since it uses the GSH's name.  

```c
#precache("triggerstring", SIMON_CHALLENGE_HINTSTRING);
```

In your mapname GSC copy paste the example below at the bottom of your `main` function.  
You can edit the `logicFuncData` line if you don't want it to start with 2 colors/targets and/or if you don't want it to end with 5 colors/targets, for a total of 4 rounds.  
You can refer to the core challenges [Script setup section](../README.md#script-setup) for more information.  

```c
level.challenges["simon"] = SpawnStruct();
level.challenges["simon"].logicFuncData = util::new_func(&resxt_challenge_simon::StartSimonChallenge, 2, 5);
level.challenges["simon"].hintstring = &SIMON_CHALLENGE_HINTSTRING;
```

## Radiant setup

First create the challenge's trigger by following the instructions in the core challenges [Radiant setup section](../README.md#radiant-setup).  

First we'll setup the off target, how it's displayed when it's not shot/active.  
Create a `script_brushmodel` or a `script_model` and give it the targetname of `simon_challenge_target`.  
Click on `Add KVP`, set `Property / Key` to `script_int` and `Value` to `1`.  
Click on `Add KVP`, set `Property / Key` to `script_noteworthy` and `Value` to `off`.  

Next, to create the on target, duplicate the off target and set `script_noteworthy` to `on`.  
Change the model/texture to something different that makes sense in the game.  

Last you can duplicate the off target, changing `script_int` to `2`, changing the model/texture if you wish to, and repeating this process as many times as you want.  
Just make sure that all targets have a unique `script_int`, that each target has both and on and an off version and that there's no jumps in the `script_int`, for example 1 2 4 (3 is missing).  
After this you can duplicate the on target and follow the same logic explained above for the off target.  
Just make sure to duplicate and place the off target first so that the on target is above it in the game's layers system, to ensure it registers the shots properly.  

## APE setup

If you use a model/script_model as the target that will be shot then make sure the model has `BulletCollisionLOD` set to `LOD0` so it can have bullets collide with it, allowing it to receive damage.  

## Customization

Here are the available variables in the GSH that you can edit

| Name | Description | Accepted values | Condition |
|---|---|---|---|
| SIMON_RANDOMIZE_ROUNDS | Whether the game should follow the regular simon rules or randomize everything each round | false to follow regular simon rules, true to randomize each round | None |
| SIMON_BETWEEN_ROUNDS_TIME | The time to wait before starting the next round | Any number | None |
| SIMON_BETWEEN_TARGETS_TIME | The time to wait between each target during the targets showcase (before players can shoot) | Any number | None |
| SIMON_BEFORE_SHOW_TIME | The time to wait before the targets showcase (useful to wait for your sound to end) | Any number | None |
| SIMON_TARGET_SHOW_TIME | The time each target will be shown during the targets showcase (before players can shoot). This is also the time the wrong target will be shown when the player shoots a wrong target | Any number above 0.10 | None |
| SIMON_TARGET_SHOT_SHOW_TIME | The time a target is shown when the player shoots it and it's a correct target | Any number above 0.10 | None |
| SIMON_CHALLENGE_HINTSTRING | The hintstring that will be displayed on the challenge's trigger when it's enabled | The reference to your localizedstring | Cannot be empty |
| SIMON_CHALLENGE_HUD_STRING | The text that will be displayed on the challenges HUD while this challenge is activated | The reference to your localizedstring | Cannot be empty |
| SIMON_TARGETS_SOUND | The alias of the sound that will be played when a target is shown (both during showcase and when the player shoots a correct target). You can either pass a single alias or several aliases separated by a comma `,`. If you do have several make sure there are as much aliases as the amount of targets since it will associate each alias to the target that corresponds to its position | "" to disable it, a valid alias string or a comma separated string with 3 aliases for 3 targets (for example) to enable it | None |
| SIMON_START_ROUND_SOUND | The alias of the sound that will be played when a round starts | "" to disable it, a valid alias string to enable it | None |
| SIMON_WIN_SOUND | The alias of the sound that will be played when a round is won | "" to disable it, a valid alias string to enable it | None |
| SIMON_LOSE_SOUND | The alias of the sound that will be played when a round is lost, when the player shoots the wrong target | "" to disable it, a valid alias string to enable it | None |

## Notes

- This challenge is not re-usable, you can't have multiple simon challenges on the same map
- This challenge cannot be cancelled once it's started, it has to be completed
- This challenge does not make players invincible or invisible since I didn't find any good way to do that while preventing abusing it for infinite god modes
