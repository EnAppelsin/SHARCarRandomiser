ModPath = GetModPath()
dofile(ModPath .. "/GlobalArrays.lua")
dofile(ModPath .. "/GlobalVariables.lua")
dofile(ModPath .. "/GlobalFunctions.lua")

ModVersion = ReadFile(ModPath .. "/Meta.ini"):match("Version=(.-)\r\n")
print("Randomiser v" .. ModVersion)
print("Randomiser: Using " .. RandomCarPoolN .. " cars")
print("Randomiser: Using " .. RandomPedPoolN .. " pedestrians")

dofile(ModPath .. "/RandomCarTune.lua")

