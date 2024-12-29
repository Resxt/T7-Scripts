# Soulboxes

A customizable soulboxes script

https://github.com/user-attachments/assets/17bbe737-8034-4684-ba90-f10e8c1e1464

## Features

All these features can easily be customized by editing the GSH file provided

- Built-in way to run your own function when any soulbox is filled and/or when all of them are filled
- Easily configure things such as model, sounds and fx through a GSH file

## Basic setup

Drag and drop the files in `Call of Duty Black Ops III\share\raw\scripts\zm\_resxt`  
Create any missing folder

In your [zone file](../README.md#zone-file) add these lines

```c
scriptparsetree,scripts/zm/_resxt/_soulboxes.gsc
scriptparsetree,scripts/zm/_resxt/_soulboxes.gsh
fx,zombie/fx_ritual_pap_energy_trail
```

If you ever change `SOULBOXES_FX` then make sure to update your FX entry in your zone file accordingly.  

In your [mapname GSC](../README.md#glossary) file add this line.  

```c
#using scripts\zm\_resxt\_soulboxes;
```

## Script setup

**[Important]**
This script needs [my utils](../utils) to work

Open the [GSH file](../README.md#glossary), review and edit the values.  
Make sure to read [Customization](#customization) to not misconfigure anything.  

Additionally, if you want to call your own function(s) when certain soulbox events happen you can add some code to your mapname GSC like shown below.  
In your mapname GSC copy paste the example below at the bottom of your `main` function.  
If you add any of these, make sure to have `#using scripts\shared\util_shared;` in your usings to not run into errors.

The functions shown are just examples.  
You can see how `util::new_func` works and learn about the `&` symbol, function pointers, [here](../README.md#function-pointers)

```c
level.soulboxes_any_completed_func_data = util::new_func(&OnAnySoulboxCompleted);
level.soulboxes_all_completed_func_data = util::new_func(&OnAllSoulboxesCompleted);

function OnAnySoulboxCompleted()
{
    level.perk_purchase_limit++; // increase the perk limit each time a soulbox is filled
}

function OnAllSoulboxesCompleted()
{
    foreach (player in GetPlayers())
    {
        // Adds 1000 points to each player once all the soulboxes are filled
        // Make sure to have #using scripts\zm\_zm_score; in your usings if you use it
        player zm_score::add_to_player_score(1000);
    }
}
```

## Radiant setup

Place any amount of `script_model` and give them the targetname of `soulboxes`

## Customization

Here are the available variables in the GSH that you can edit

| Name | Description | Accepted values | Condition |
|---|---|---|---|
| SOULBOXES_RADIUS | The radius around the model that will attract souls when zombies are killed inside | Any number starting from 10 | None |
| SOULBOXES_SOULS_PER_SOULBOX | The amount of souls each soulbox has to collect before it's filled | Any number above 0 | None |
| SOULBOXES_SOUL_VECTOR | The vector to add to the model's origin for the FX's destination | Any valid vector, (0, 0, 0) to disable it | None |
| SOULBOXES_FX | The fx to play and move to the soulbox when a zombie dies within an active soulbox's radius | Any string that's a valid fx | None |
| SOULBOXES_MODEL_OFF | The name of the model that will be set once a soulbox is filled | Any string that's a valid model name, "" to not change it | None |
| SOULBOXES_SOUL_SOUND | The sound that will be played when a soul gets to a soulbox | Any string that's a valid sound alias | None |
| SOULBOXES_FILLED_SOUND | The sound that will be played when a soulbox gets filled | Any string that's a valid sound alias | None |
