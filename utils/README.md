# Utils

A collection of useful functions.  
This script may be required for some of my other scripts to work.  

## Basic setup

Drag and drop the files in `Call of Duty Black Ops III\share\raw\scripts\zm\_resxt`  
Create any missing folder

In your [zone file](../README.md#zone-file) add this line

```c
scriptparsetree,scripts/zm/_resxt/_utils.gsc
```

If you were required to add this util for one of my scripts then you don't have to follow the instructions below.  
On the other hand, if you want to use some functions for your own scripts then in your script add this line

```c
#using scripts\zm\_resxt\_utils;
```

## Script setup

Once you read the code and found a function you want to use, check how it's implemented/how it's used.  
Then in your script call the function by referencing the namespace. More information [here](../README.md#namespaces--external-function-calls)
