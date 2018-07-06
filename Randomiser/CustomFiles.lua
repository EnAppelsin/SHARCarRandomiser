ModPath = GetModPath()
dofile(ModPath .. "/GlobalArrays.lua")
dofile(ModPath .. "/GlobalVariables.lua")
dofile(ModPath .. "/GlobalFunctions.lua")

print("Random Cars: Using " .. RandomCarPoolN .. " cars")
print("Random Cars: Using " .. RandomPedPoolN .. " pedestrians")

dofile(ModPath .. "/RandomCarTune.lua")

