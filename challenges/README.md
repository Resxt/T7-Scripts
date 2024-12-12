# Challenges

Challenges core script that handles the main logic such as attributing a challenge to a specific trigger, the challenges HUD and so on.  
This script does not provide any challenge on its own, you need to install at least one of my challenge script (or implement your own) to make use of this script.  

## Features

- (Customizable) Set an amount of challenges needed to consider all challenges completed. For example you can have 6 challenges available but once players complete 4 of them it will consider they completed all of them, so players aren't forced to do them all
- Have several challenges on a single trigger, each game it will randomly choose one of them and remove the others from the list of available challenges making up for variety
- Configure certain triggers to run specific challenge(s) or don't set any challenge and let the script pick randomly from the list of the challenges you made available
- Built-in way to run your own function when any challenge is completed and/or when all of them are completed
- Built-in per challenge way to run your own function when a challenge ends. Useful for cleanups for example
- Some of my challenges provided in their separate file

## Basic setup

**[Important]** this script needs [my utils](../utils) to work

Drag and drop the files in `Call of Duty Black Ops III\share\raw\scripts\zm\_resxt`  
Create any missing folder

In your [zone file](../README.md#zone-file) add these lines

```c
scriptparsetree,scripts/zm/_resxt/_challenges.gsc
scriptparsetree,scripts/zm/_resxt/_challenges.gsh
```

In your [mapname GSC](../README.md#glossary) file add these lines

```c
#using scripts\zm\_resxt\_challenges;
#insert scripts\zm\_resxt\_challenges.gsh;
```

## Script setup

Open the [GSH file](../README.md#glossary), review and edit the values.  
Make sure to read [Customization](#customization) to not misconfigure anything.  

As explained before, this script does not do anything on its own, you need to add some of my challenges or implement your own.  
To add challenges you would do something like the example shown below.  
The name of the challenge is the array key you pass to `level.challenges`, so in this example it's `paintings_shootable`.  
Note that you can use the same function for different challenges if your code is written properly, as long as the challenges names are unique.  
For example you can have multiple shootables challenges, with different names, that have different targets and they will both work.  

- The first line is to create a struct at this variable, this is mandatory, don't change it.  
- Second line is the function that will run when this challenge is started. See [Function pointers](../README.md#function-pointers)
- Third line is optional, this is the function that will be called when this specific challenge is completed
- The last line is the hintstring that will be displayed when you get close to the trigger and the challenge is available

```c
level.challenges["paintings_shootable"] = SpawnStruct();
level.challenges["paintings_shootable"].logicFuncData = util::new_func(&resxt_challenge_shootables::StartShootablesChallenge, "paintings_shootable_challenge_target");
level.challenges["paintings_shootable"].completedFuncData = util::new_func(&IPrintLnBold, "^2You completed the paintings shootable challenge!");
level.challenges["paintings_shootable"].hintstring = "Press &&1 to start the paintings shootable challenge";
```

If you want to call your own function(s) when certain challenge events happen you can add some code to your mapname GSC like shown below.  
If you add any of these, make sure to have `#using scripts\shared\util_shared;` in your usings to not run into errors.  

The functions shown are just examples.  
You can see how `util::new_func` works and learn about the `&` symbol, function pointers, [here](../README.md#function-pointers)

```c
level.challenges_all_completed_func_data = util::new_func(&OnAllChallengesCompleted, 1000);
level.challenges_any_completed_func_data = util::new_func(&OnChallengeCompleted);

function OnChallengeCompleted()
{
    level.perk_purchase_limit++; // increase the perk limit each time a challenge is completed
}

function OnAllChallengesCompleted(points)
{
    foreach (player in GetPlayers())
    {
        // Adds 1000 points to each player once all the challenges are completed
        // Make sure to have #using scripts\zm\_zm_score; in your usings if you use it
        player zm_score::add_to_player_score(points);
    }
}
```

## Radiant setup

Create a `trigger_use` or `trigger_use_touch` and give it the targetname of `challenges_trigger`.  

Click on `Add KVP`, set `Property / Key` to `script_noteworthy` and `Value` to the name(s) of the challenge(s) you want.  
The name of a challenge is how you called it in when adding it in your mapname GSC. See [Script setup](#script-setup)
Several challenges on a single trigger would make the script pick one randomly each game and remove the other one from the list of available challenges.  
The syntax for adding several challenges is separating each with a comma, without any space, as shown in this example `snowmen_shootable,paintings_shootable`

## Customization

Here are the available variables in the GSH that you can edit

| Name | Description | Accepted values | Condition |
|---|---|---|---|
| CHALLENGES_AMOUNT | The amount of challenges to complete until the script considers that players completed all challenges | 0 to let the script set it to the amount of challenges trigger, any int to set a specific number | None |

## Notes

- This script isn't too customizable for now, it's mostly to fit my needs and some quick additions I did to allow for some more ways of using it.  
I plan on improving it later, potentially with your ideas/needs.
