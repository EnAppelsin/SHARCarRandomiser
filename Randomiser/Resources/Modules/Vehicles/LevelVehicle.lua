local math_random = math.random

local RandomLevelVehicle = Module("Random Level Vehicle", "RandomLevelVehicle", 1)

RandomLevelVehicle:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	local RandomVehicleIndex = math_random(CarCount)
	local RandomVehicleP3D = CarP3DFiles[RandomVehicleIndex]
	local RandomVehicleName = CarNames[RandomVehicleIndex]
	
	local functions = LevelLoad.Functions
	for i=1,#functions do
		local func = functions[i]
		if func.Name:lower() == "loaddisposablecar" and func.Arguments[3] == "DEFAULT" then
			func.Arguments[1] = RandomVehicleP3D
			func.Arguments[2] = RandomVehicleName
		end
	end
	
	LevelInit:SetAll("InitLevelPlayerVehicle", 1, RandomVehicleName)
	
	return true
end)

return RandomLevelVehicle