ModPath = GetModPath()
dofile(ModPath .. "/GlobalArrays.lua")
dofile(ModPath .. "/GlobalVariables.lua")
dofile(ModPath .. "/GlobalFunctions.lua")

DebugPrint("Loaded " .. #RandomCarPoolPlayer .. " cars for the random Player pool")
DebugPrint("Loaded " .. #RandomCarPoolTraffic .. " cars for the random Traffic pool")
DebugPrint("Loaded " .. #RandomCarPoolMission .. " cars for the random Mission pool")
DebugPrint("Loaded " .. #RandomCarPoolChase .. " cars for the random Chase pool")
DebugPrint("Using " .. RandomPedPoolN .. " pedestrians")

dofile(ModPath .. "/RandomCarTune.lua")
if SettingRandomDialogue then
	dofile(ModPath .. "/RandomDialogue.lua")
end