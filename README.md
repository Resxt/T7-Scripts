# T7-Scripts

[![image](cover.jpg)](https://steamcommunity.com/id/resxt/myworkshopfiles/)

## What is this?

This is a collection of Call of Duty Black Ops III (T7/BO3) scripts I created, written in [GSC](https://plutonium.pw/docs/modding/gsc/).  
I decided to start polishing and sharing some of my scripts to help other modders implement features into their map since some scripts/features are hard to find online or are not really good scripts mainly due to how old they are.  
I also included some tutorials/explanations for some concepts such as the zone file and precaching to help you make use of my scripts more easily (and improve your knowledge overall as well).  

Huge thanks to everyone who helped me learn GSC originally for other CODs: Birchy, DoktorSAS, FutureRave among others.  
Also a massive thanks to everyone that made me learn a ton of things on BO3: serious, Rayjiun, Vertasea, Shidouri, Scworppy among others.  
And last, thanks to the [Black Ops 3 Mod Tools](https://discord.com/invite/black-ops-3-mod-tools-230615005194616834) and the [DEVRAW](https://discord.com/invite/6d9swZmKpa) Discord servers and their community for helping me learn all the time!

## How do I download a script?

You can click on the files and click on then download button which should be `Download raw file`

Alternatively, you can download this entire repository to make drag and dropping several files easier.  
Just keep in mind that this downloads a copy of this repository at the moment you download it.  
If a script is updated after you downloaded this repository and you want the new version then you will need to download this repository again or a copy of the script.  

- [Download this repository](https://github.com/Resxt/T7-Scripts/archive/refs/heads/master.zip)
- Open the downloaded ZIP file
- Drag and drop the file(s) you want in the folder they need to be placed in.  

The instructions to install and use these scripts are on their respective page on this repository

Note that scripts installed in your map's folder will always be loaded in priority, instead of the scripts in `Call of Duty Black Ops III\share\raw\scripts` if you happen to install them in both locations.  
For this reason I recommend installing the scripts in `share\raw\scripts` so that they're always re-usable for your other maps, untouched.  
This way you can also make a copy of the script and place it into your map's scripts folder to edit it for your map specific behavior while leaving the global script untouched for the other maps that use it.  

As always when you use a script, asset or anything that's not yours, don't forget to credit the people that made it

## Tools recommendations

To edit scripts (and to write your own) I recommend using proper tools (software, websites and extensions/addons) to make things easier and to have more knowledge available to you as well!
The very basic of it is installing a programming editor and an extension/addon to get a proper GSC editing setup with colors, syntax and autocompletion instead of using a notepad that's unaware of how to color things and cannot provide any autocompletion as well

- An [IDE](https://en.wikipedia.org/wiki/Integrated_development_environment) (developement tool) such as [Visual Studio Code](https://code.visualstudio.com/)
- An extension to get [syntax highlighting/colored syntax](https://en.wikipedia.org/wiki/Syntax_highlighting) and [autocompletion](https://code.visualstudio.com/docs/editor/intellisense) such as [serious GSC extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=shiversoftdev.vscode-txgsc)
- (optional) a website listing functions API such as [scripts.zeroy.com/](https://scripts.zeroy.com/) or [gscode.net/library](https://gscode.net/library)
- (optional) Visual Studio Code extension: [Indent Rainbow](https://marketplace.visualstudio.com/items?itemName=oderwat.indent-rainbow)
- (optional) Visual Studio Code extension: [LocalizedStrings](https://marketplace.visualstudio.com/items?itemName=ApexModder.localizedstrings)
- (advanced) [the game's source code dump](https://github.com/shiversoftdev/t7-source), to see how certain things are and search for keywords to grasp information or code here and there.  
Note that you can also look at the files in your BO3 folder `share\raw\scripts`, or even better, directly import that folder into your Visual Studio Code's workspace to make searching in the entire folder easier

I highly recommend joining both of the Discord servers listed at the top of this README to get help with scripting if you're learning.  
You can also ping me there if you're in need of help with one of my script.  

## Zone file

The zone file is where you include assets for the game to load for your map.  
It won't run scripts on its own, it's only used to make assets available to use/loaded.  
When using a script that's not included in the base game, such as mine, you need to add them to the zone file to make the game load them.  
You can then start using them in GSC/CSC by adding `#using` lines for GSC and CSC scripts, or `#insert` lines for GSH files in your script

The same principle applies for a lot of other things such as models.  
If a model is in your map already, in Radiant, then it's loaded.  
If it's not and you want to use that model through script then you need to add it to the zone file.  

Here are some examples of how you can add things to your zone file

```c
scriptparsetree,scripts/zm/zm_resxt_minecraft.gsc // GSC script
scriptparsetree,scripts/zm/zm_resxt_minecraft.csc // CSC script
scriptparsetree,scripts/zm/zm_resxt_minecraft.gsh // GSH file

xmodel,_mc_item_iron_ingot // Model that's not placed in Radiant
material,_mc_hud_item_iron_ingot // Material

include,resxt_minecraft_perks // ZPKG file, this is basically another zone file that you can include within a zone file

sound,zm_resxt_minecraft // SZC file
```

To access your map's zone file you can do one of these:

- Right click on your map in ModTools and click on `Edit Zone file`
- Go to `Call of Duty Black Ops III\usermaps\YOUR_MAPNAME\zone_source` (replace `YOUR_MAPNAME` with your map's name) and open the zone file that has your map's name

## Localized strings

Localized strings are more advanced strings that allow for things like translating and [precaching](#precaching).  
Changing your strings to localized strings is a good practice both to not make the game have a short freeze/lag (hitch) when first showing a string/hintstring, thanks to precaching, and also to make translating your map possible (and easy)

To create localized strings in english, go in your map's folder then `english\localizedstrings`. Create any missing folder.  
In there create a file with the `.str` file extension, you can just use your [mapname](#glossary) as the file name.  
Open that file with a text editor such as Visual Studio Code or the Notepad.  
Copy paste the block below in it. You can edit the FILENOTES line.  
Each entry has REFERENCE for the name and LANG_`LANGUAGE` for the language, followed by the string/the value.  

```c
FILENOTES    "CREATED BY RESXT"



REFERENCE           EXAMPLE_HINTSTRING
LANG_ENGLISH        "Hold ^8[{+activate}] ^7to ^8debug"



ENDMARKER
```

If you named your `.str` file `zm_resxt_minecraft` you would refer to `EXAMPLE_HINTSTRING` as `"ZM_RESXT_MINECRAFT_EXAMPLE_HINTSTRING"` in your code.  
To convert `"ZM_RESXT_MINECRAFT_EXAMPLE_HINTSTRING"` to `"Hold ^8[{+activate}] ^7to ^8debug"` you would add a `&` before `"ZM_RESXT_MINECRAFT_EXAMPLE_HINTSTRING"`.  
There are other, more advanced/specific ways to use localizedstrings such as the `istring` and `makelocalizedstring` functions but I won't detail them here.  

Add the `.str` file to your [zone file](#zone-file).  
Replace `STR_FILE_NAME` with your .str file name. In my example this would be `zm_resxt_minecraft`.  

```c
localize,STR_FILE_NAME
```

You need to have your localizedstrings available in all languages (and build your map in all languages) to support them all.  
For development purpose, you can just create everything in your game's language and copy paste it in all languages before releasing your map.  
[Hermes](https://github.com/Rayjiun/Hermes) should automate that process but I haven't used it yet so I can't give more information on it for now.  

You can also use localizedstrings on triggers to have them display your text right away without doing it through script.  
You would edit the `hintstring` KVP and add the full reference to your localizedstring, so in my example this would be `ZM_RESXT_MINECRAFT_EXAMPLE_HINTSTRING`

I tried to explain it the best I could, if anything is unclear or if you're looking for the full list of languages, I recommend reading the [guide on t7wiki](https://www.t7wiki.com/guides/how-to-use-localization.md).  
If you still don't understand something, feel free to ask on one of the Discord servers shared at the [top of this page](#what-is-this).

## Precaching

Precaching allows you to cache certain things like localizedstrings and models to get better stability overall.  
When not precached, an hintstring would make the player's game have a short lag/freeze (hitch) when first seeing it.  
When not precached, a model spawned through script (that's not on the map in Radiant) would flicker/have a temporary visual bug the first time it's spawned.  
Precaching solves these issues by caching the localizedstrings/models etc. before the game starts so the player can play the game without these unexpected things happening.  
Note that (seemingly) the engine has a bug that makes you still have this lag the very first time you see an hintstring that has a newline character `\n` even if it's precached.  
From what I know, cannot be fixed and is only for the first hintstring you see with this newline character so it's not a big issue.

To precache something you would add a `#precache` line in your script.  
You can add them below the `#using` lines for example.  

Precaching a hintstring (triggerstring) and a model would look like the example below.  
See [Localized strings](#localized-strings) for explanations on turning your strings to localizedstrings to be able to precache them.  

```c
#precache("triggerstring", "ZM_RESXT_MINECRAFT_EXAMPLE_HINTSTRING");
#precache("model", "_mc_block_lever_on");
```

## Namespaces & external function calls

A namespace is the name other scripts will use to refer to a function located in that script.  
It is declared as shown below

```c
#namespace resxt_utils;
```

When trying to use a function that's located in another script (an external function call), you would use the `NAMESPACE::FUNCTION` syntax, as shown in the example below

```c
if (resxt_utils::ChanceFromPercentage(80))
{
    // some code that runs when the condition is true, since this function returns a boolean
}

if (!resxt_utils::ChanceFromPercentage(80))
{
    // some code that runs when the condition is false, since this function returns a boolean and I added a ! before it, just like I would with a regular function
}
```

## Function pointers

Function pointers are used to store a reference to a function without calling it right away.  
In this example I first store the `OnChallengeCompleted` function in a variable, just like you would store a string for example. It doesn't run the function

```c
level.challenges_any_completed_func = &OnChallengeCompleted;
```

Then later on in my code I can call the function using this syntax.  
This will then run the function like it would normally.  

```c
[[level.challenges_any_completed_func]]();
```

It can be useful to replace some of the game's default behaviors or add behaviors to some scenarios, like when a player connects.  

```c
callback::on_connect(&OnPlayerConnected);

function OnPlayerConnected()
{
    // code that runs when a player connects
}
```

You might also run into [util::new_func](https://github.com/shiversoftdev/t7-source/blob/main/scripts/shared/util_shared.gsc#L877) sometimes, this is a function that converts your function pointer and, if you have some, your args, into a struct.  
This allows developers to make use of function pointers more easily without passing a lot of args each time but rather just getting a single arg, the struct, and parsing the function pointer and the args automatically.  

Function pointers can also be used for more advanced scripting like when you have a core script that holds some generic logic, such as handling challenges, where you can then implement challenges in other file(s).  
The core challenges script would then be able to call any function you pass it (thanks to pointers that store the function) without having to do specific code for each challenge.  
The core challenges script only does generic challenges things you expect it to do while a shootables challenge script does what's specific to the shootables challenge and gives its starting function to the core challenges script that will run it whenever it's time to run that specific challenge.  

## Glossary

- `Mapname`: refers to your map's code name. This is the name of the folder of your map in the `usermaps` folder
- `Mapname GSC / Mapname CSC`: refers to your map's main GSC/CSC script. If your map is `zm_resxt_minecraft` then it should be `zm_resxt_minecraft.gsc` (or .csc) in `YOUR_MAPNAME/scripts/zm`
- `GSH file`: refers to a file with the `.gsh` file extension. This is used to declare values such as strings to then use them in scripts. GSH files are added in script with `#insert`
