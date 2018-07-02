ModPath = GetModPath()
dofile(ModPath .. "/GlobalVariables.lua")
dofile(ModPath .. "/GlobalArrays.lua")
dofile(ModPath .. "/GlobalFunctions.lua")

-- Add the husk unless disabled
if not GetSetting("NoHusk") then
	table.insert(RandomCarPool, "huskA")
end

-- Count number of random cars
RandomCarPoolN = #RandomCarPool
RandomPedPoolN = #RandomPedPool

print("Random Cars: Using " .. RandomCarPoolN .. " cars")
print("Random Cars: Using " .. RandomPedPoolN .. " pedestrians")
if GetSetting("RandomCharacter") then
	dofile(ModPath .. "/RandomDialog.lua")
end

dofile(ModPath .. "/RandomCarTune.lua")

