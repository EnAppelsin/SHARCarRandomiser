local math_random = math.random

local RandomLevelVehicle = Module("Random Level Vehicle", "RandomLevelVehicle", 1)

RandomLevelVehicle:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	local RandomVehicleName = CarNames[math_random(CarCount)]
	
	print("Setting level vehicle to: " .. RandomVehicleName)
	
	LevelInit:SetAll("InitLevelPlayerVehicle", 1, RandomVehicleName)
	
	return true
end)

return RandomLevelVehicle