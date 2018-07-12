ModPath = GetModPath()
dofile(ModPath .. "/GlobalVariables.lua")
dofile(ModPath .. "/GlobalArrays.lua")
dofile(ModPath .. "/GlobalFunctions.lua")

print("Randomiser v" .. ModVersion)
print("Randomiser: Using " .. RandomCarPoolN .. " cars")
print("Randomiser: Using " .. RandomPedPoolN .. " pedestrians")

dofile(ModPath .. "/RandomCarTune.lua")

