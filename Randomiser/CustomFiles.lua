ModPath = GetModPath()
dofile(ModPath .. "/GlobalArrays.lua")
dofile(ModPath .. "/GlobalVariables.lua")
dofile(ModPath .. "/GlobalFunctions.lua")

DebugPrint("Loaded " .. #RandomCarPoolPlayer .. " cars for the random Player pool")
DebugPrint("Loaded " .. #RandomCarPoolTraffic .. " cars for the random Traffic pool")
DebugPrint("Loaded " .. #RandomCarPoolMission .. " cars for the random Mission pool")
DebugPrint("Loaded " .. #RandomCarPoolChase .. " cars for the random Chase pool")
DebugPrint("Using " .. RandomPedPoolN .. " pedestrians")

if SettingRandomInteriors then
	if not Confirm("Random Interiors is an experimental addition that can cause the game to be unplayable. If you want to disable this, press Cancel") then
		SettingRandomInteriors = false
	end
end

if SettingCustomCars then
	dofile(ModPath .. "/CustomCars.lua")
end

dofile(ModPath .. "/RandomCarTune.lua")
if SettingRandomDialogue then
	dofile(ModPath .. "/RandomDialogue.lua")
end
