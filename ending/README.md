# Ending

A customizable ending/buyable ending script

## Features

All these features can easily be customized by editing the GSH file provided

- Make the ending's price purchasable in several parts instead of a single big payment, allowing each player to contribute
- Make the ending's price scale depending on the amount of players
- Make the ending's trigger show an hintstring before the buyable ending is enabled, such as "Can't espace yet" to let players know the ending will be there
- Make the ending's purchasable after a certain notify
- Send your own notify instead of the regular `end_game` notify to handle the ending on your side, handy to play a cinematic for example

## Basic setup

Drag and drop the files in `Call of Duty Black Ops III\share\raw\scripts\zm\_resxt`  
Create any missing folder

In your [zone file](./README.md#zone-file) add these lines

```c
scriptparsetree,scripts/zm/_resxt/_ending.gsc
scriptparsetree,scripts/zm/_resxt/_ending.gsh
```

In your [mapname GSC](./README.md#glossary) file add these lines

```c
#using scripts\zm\_resxt\_ending;
#insert scripts\zm\_resxt\_ending.gsh;
```

## Script setup

Open the [GSH file](./README.md#glossary), review and edit the values.  
Make sure to read [Customization](#customization) to not misconfigure anything.  

In your map's [STR file](./README.md#localized-strings) add entries for the hintstring(s) you will use.  
Make sure to edit the GSH file accordingly.  
Below is an example of what you can add to your STR file.  

```c
REFERENCE      ENDING_HINTSTRING
LANG_ENGLISH      "Hold ^8[{+activate}] ^7to ^8contribute to the ending ^7[Cost: 5000]\n[Left to pay: &&1]"

REFERENCE      ENDING_DISABLED_HINTSTRING
LANG_ENGLISH      "You can't espace yet.."
```

[Precache](./README.md#precaching) all the hintstrings that will be used in your mapname GSC.  
Below is an example where the base cost is `10000`, the per player cost is `5000` and players can pay `5000` to contribute.  
`10000 + (5000 * 4 players)` would lead to `30000`, plus I added all values that are a multiply of `5000` below `30000` to make up for any potential scenario, both less than 4 players and players paying `5000` per `5000`.  
I also added the disabled hintstring because I want to show an hintstring before the ending is available for purchase.  

```c
#precache("triggerstring", ENDING_DISABLED_HINTSTRING);
#precache("triggerstring", ENDING_HINTSTRING, "30000");
#precache("triggerstring", ENDING_HINTSTRING, "25000");
#precache("triggerstring", ENDING_HINTSTRING, "20000");
#precache("triggerstring", ENDING_HINTSTRING, "15000");
#precache("triggerstring", ENDING_HINTSTRING, "10000");
#precache("triggerstring", ENDING_HINTSTRING, "5000");
```

## Radiant setup

Create a `trigger_use` or `trigger_use_touch` and give it the targetname of `ending_trigger`

## Customization

Here are the available variables in the GSH that you can edit

| Name | Description | Accepted values | Condition |
|---|---|---|---|
| ENDING_WAITTILL | Waits until this notify to make the ending purchasable | "" to disable it, any string to enable it | None |
| ENDING_NOTIFY | Sends this notify when the ending is over instead of the default `end_game` notify | "" to disable it, any string to enable it | None |
| ENDING_BASE_COST | The base cost of the ending | Any number starting from 0 | None |
| ENDING_PER_PLAYER_COST | The cost to add to `ENDING_BASE_COST` per player (`ENDING_BASE_COST` + (`ENDING_PER_PLAYER_COST` * amount of players)) | Any number starting from 0 | None |
| ENDING_PART_COST | How much players can contribute to the ending in several payments instead of a single big payment | 0 to disable it, any number to enable it | None |
| ENDING_HINTSTRING | The hintstring that will be displayed once the ending is purchasable | The reference to your localizedstring | Cannot be empty |
| ENDING_DISABLED_HINTSTRING | The hintstring that will be displayed until the ending becomes purchasable | "" to disable it, The reference to your localizedstring to enable it | None |
| ENDING_PURCHASE_SOUND | The alias of the sound that will be played when a successful purchase is made | "" to disable it, a valid alias string to enable it | None |
| ENDING_PURCHASE_FAILED_SOUND | The alias of the sound that will be played when purchase cannot be made (not enough points) | "" to disable it, a valid alias string to enable it | None |
