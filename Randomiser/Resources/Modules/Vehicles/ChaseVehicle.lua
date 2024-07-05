local math_random = math.random
local table_remove = table.remove
local table_unpack = table.unpack

local RandomChaseVehicle = Module("Random Chase Vehicle", "RandomChaseVehicle", 2)

local CarNames = {table_unpack(CarNames)}
local CarP3DFiles = {table_unpack(CarP3DFiles)}
for i=CarCount,1,-1 do
	if not Settings[CarNames[i] .. "Chase"] then
		table_remove(CarNames, i)
		table_remove(CarP3DFiles, i)
	end
end
local CarCount = #CarNames

if CarCount < 5 and Settings[RandomChaseVehicle.Setting] then
	Alert("You must have at least 5 vehicle selected for the random chase pool.")
	os.exit()
end

RandomChaseVehicle:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	local RandomVehicleIndex = math_random(CarCount)
	local RandomVehicleP3D = CarP3DFiles[RandomVehicleIndex]
	local RandomVehicleName = CarNames[RandomVehicleIndex]
	
	print("Setting chase vehicle to: " .. RandomVehicleName)
	
	for Function in LevelInit:GetFunctions("CreateChaseManager") do
		Function.Arguments[1] = RandomVehicleName
		if Settings.RandomChaseVehicleStats then
			Function.Arguments[2] = RandomVehicleName .. ".con"
		end
	end
	
	return true
end)

return RandomChaseVehicle