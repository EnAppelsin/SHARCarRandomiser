local math_random = math.random

local RandomLevelVehicle = Module("Random Level Vehicle", "RandomLevelVehicle", 1)

RandomLevelVehicle:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	local RandomVehicleIndex = math_random(CarCount)
	local RandomVehicleP3D = CarP3DFiles[RandomVehicleIndex]
	local RandomVehicleName = CarNames[RandomVehicleIndex]
	
	print("Setting level vehicle to: " .. RandomVehicleName)
	
	LevelInit:SetAll("InitLevelPlayerVehicle", 1, RandomVehicleName)
	
	return true
end)

return RandomLevelVehicle