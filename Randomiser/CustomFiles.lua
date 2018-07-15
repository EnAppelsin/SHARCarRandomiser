ModPath = GetModPath()
dofile(ModPath .. "/GlobalArrays.lua")
dofile(ModPath .. "/GlobalVariables.lua")
dofile(ModPath .. "/GlobalFunctions.lua")

DebugPrint("Using " .. RandomCarPoolN .. " cars")
DebugPrint("Using " .. RandomPedPoolN .. " pedestrians")

dofile(ModPath .. "/RandomCarTune.lua")
if SettingRandomDialogue then
	dofile(ModPath .. "/RandomDialogue.lua")
end