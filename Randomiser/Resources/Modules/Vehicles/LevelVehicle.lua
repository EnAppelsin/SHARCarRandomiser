local math_random = math.random
local table_remove = table.remove
local table_unpack = table.unpack

local RandomLevelVehicle = Module("Random Level Vehicle", "RandomLevelVehicle", 1)

local CarNames = {table_unpack(CarNames)}
for i=CarCount,1,-1 do
	if not Settings[CarNames[i] .. "Player"] then
		table_remove(CarNames, i)
	end
end
local CarCount = #CarNames

if CarCount < 5 and Settings[RandomLevelVehicle.Setting] then
	Alert("You must have at least 5 vehicle selected for the random player pool.")
	os.exit()
end

RandomLevelVehicle:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	local RandomVehicleName = CarNames[math_random(CarCount)]
	
	print("Setting level vehicle to: " .. RandomVehicleName)
	
	LevelInit:SetAll("InitLevelPlayerVehicle", 1, RandomVehicleName)
	
	return true
end)

return RandomLevelVehicle