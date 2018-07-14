ModPath = GetModPath()
dofile(ModPath .. "/GlobalArrays.lua")
dofile(ModPath .. "/GlobalVariables.lua")
dofile(ModPath .. "/GlobalFunctions.lua")

print("Randomiser v" .. ModVersion)
print("Randomiser: Using " .. RandomCarPoolN .. " cars")
print("Randomiser: Using " .. RandomPedPoolN .. " pedestrians")

dofile(ModPath .. "/RandomCarTune.lua")
if SettingRandomDialogue then
	dofile(ModPath .. "/RandomDialogue.lua")
end