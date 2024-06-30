local math_random = math.random

local RandomChaseVehicle = Module("Random Chase Vehicle", "RandomChaseVehicle", 2)

RandomChaseVehicle:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	local RandomVehicleIndex = math_random(CarCount)
	local RandomVehicleP3D = CarP3DFiles[RandomVehicleIndex]
	local RandomVehicleName = CarNames[RandomVehicleIndex]
	
	print("Setting chase vehicle to: " .. RandomVehicleName)
	
	local functions = LevelInit.Functions
	for i=1,#functions do
		local func = functions[i]
		local name = func.Name:lower()
		if name == "createchasemanager" then
			func.Arguments[1] = RandomVehicleName
			if Settings.RandomChaseVehicleStats then
				func.Arguments[2] = RandomVehicleName .. ".con"
			end
			break
		end
	end
	
	LevelLoad:AddFunction("LoadP3DFile", RandomVehicleP3D)
	if Settings.RandomChaseAmount then
		local amount = math_random(5)
		print("Setting chase amount to: " .. amount)
		LevelInit:SetAll("SetNumChaseCars", 1, amount)
	end
	
	return true
end)

return RandomChaseVehicle