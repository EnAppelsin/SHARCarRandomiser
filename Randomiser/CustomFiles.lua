ModPath = GetModPath()
dofile(ModPath .. "/GlobalVariables.lua")
dofile(ModPath .. "/GlobalArrays.lua")
dofile(ModPath .. "/GlobalFunctions.lua")

print("Random Cars: Using " .. RandomCarPoolN .. " cars")
print("Random Cars: Using " .. RandomPedPoolN .. " pedestrians")

dofile(ModPath .. "/RandomCarTune.lua")

