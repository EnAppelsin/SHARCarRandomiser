# Simpsons Hit & Run Randomiser

This mod allows for randomising vehicles and characters throughout the game.
Each randomisation has it's own option, detailed below.

## Installation
Copy the mod file (.lmlm) to your Mods folder (usually Documents\My Games\Lucas' Simpsons Hit & Run Mod Launcher\Mods)
Run the Mod Launcher and change the settings to match your needs, then play the game.
All possible randomisations are available in separate settings.

## Settings
### Randomisations
#### Random player character
Off by default.
If this is checked, you will get a random player character from (almost) any model in the game.
Due to some limitations, some models aren't available.
#### Random player vehicles
On by default.
If this is checked, you will get a random vehicle per level/mission.
#### Same car if restarting/failing mission
On by default.
If this is checked and you restart the mission (or retry after failing) you will get the same car again.
You can change the car by cancelling the mission first and starting it again.
If this is disabled you'll get a random car each time you restart.
#### Random car scale
Off by default.
If this is checked, the model scale for any character in a car will be randomised.
#### Random pedestrians
On by default.
If this is checked, pedestrians and drivers will be randomised per level load.
You will get the same pedestrians for each mission of a level.
#### Random traffic
On by default.
If this is checked, traffic cars will be randomised per level load.
You will get the same traffic cars for each mission of a level.
#### Random chase car
On by default.
If this is checked, chase cars will be randomised per level load.
You will get the same chase cars for each mission of a level.
#### Random chase car amount
On by default.
If this is checked, the number of chase cars will be randomised per level load.
You will get the same number for each mission of a level.
#### Random chase car - stats
On by default.
If this is checked, random chase cars will have the stats of the chosen car.
Otherwise, random chase cars will have the stats of the level's default chase cars.
#### Random mission vehicles
On by default.
If this is checked, most mission vehicles will be randomised (including races).
You will get the same traffic cars for each mission of a level.
#### Random mission vehicles - stats
On by default.
If this is checked, random mission vehicles will have the stats of the chosen vehicle.
Otherwise, random mission vehicles will have the stats of the level's default vehicles.
#### Different random cellouts
On by default.
If this is checked, cellouts will be 4 random cars instead of the same car 4 times.
#### Same mission vehicle if restarting/failing mission
On by default.
If this is checked and you restart the mission (or retry after failing) you will get the same mission vehicles again.
You can change the vehicles by cancelling the mission first and starting it again.
If this is disabled you'll get random mission vehicles each time you restart.
#### Random stats
On by default.
If this is checked, all randomised vehicles will also have random stats (to an extent).
Disclaimer: This can cause missions to be impossible, I.E. if your random vehicle doesn't have the mass to destroy a mission vehicle
### Gameplay Changes
#### Remove car/costume requirements
Off by default.
If this is checked, you won't need to be wearing a specific costume/be driving a specific car to start a mission.
Removes the need for a coin route.
#### Skip cutscenes (except intro cutscene)
Off by default.
If this is checked, all cutscenes bar the introduction cutscene won't be played.
#### Increase HP for weak cars
Off by default.
If this is checked weak cars like the rocket car will have their HP slightly boosted so they're not quite as fragile.
It raises the minimum HP to 0.8 for all cars.
### Misc
#### No Husk (Destroyed Car)
On by default.
If this is checked the destroyed car (husk) is not in the list of random cars to use.
	
## Potential Limitations/Issues
- Missions will spawn you where you start if you restart the mission once, this is because adding a forced car teleports you.

- The list of cars to chose from is built into the script and so if you use mods which add extra cars they won't be chosen,
and if a mod removes cars the game will crash if the randomiser picks it.

- Your car will vanish at the end of the mission, even if you are in it. Again this is because of how forced cars work.

- There is a spot where random characters will be sat in mid air. This is due to how passengers/drivers work.
