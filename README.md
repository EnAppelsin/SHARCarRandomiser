# Simpsons Hit & Run Car Randomiser

This mod means each mission, including races, starts with a random vehicle.
The vehicle for each level when not in a mission is also randomised

## Installation
Copy the mod file (.lmlm) to your Mods folder (usually Documents\My Games\Lucas' Simpsons Hit & Run Mod Launcher\Mods)
Run the Mod Launcher and enable "Random Mission Cars" then play the game.
You can change a couple of settings in the mod settings

## Settings
### Same car if restarting/failing mission
On by default.
If this is checked and you restart the mission (or retry after failing) you will get the same car again
You can change the car by cancelling the mission first and starting it again
If this is disabled you'll get a random car each time you restart
### Increase HP for weak cars
Off by default.
If this is checked weak cars like the rocket car will have their HP slightly boosted so they're not
quite as fragile. It raises the minimum HP to 0.8 for all cars
### No Husk (Destroyed Car)
Off by default.
If this is checked the destroyed car (husk) is not in the list of random cars to use.
	
## Potential Limitations/Issues
- Missions will spawn you where you start if you restart the mission once, this is because adding a forced car teleports you.

- The list of cars to chose from is built into the script and so if you use mods which add extra cars they won't be chosen,
and if a mod removes cars the game will crash if the randomiser picks it.

- Your car will vanish at the end of the mission, even if you are in it. Again this is because of how forced cars work.
