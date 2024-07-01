local string_match = string.match
local table_remove = table.remove

local HandleVehicleLoads = Module("Handle Vehicle Loads", nil, 69420)

local LoadedCars

HandleVehicleLoads:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	LoadedCars = {}
	
	local functions = LevelLoad.Functions
	for i=#functions,1,-1 do
		local func = functions[i]
		local name = func.Name:lower()
		
		if name == "loaddisposablecar" or (name == "loadp3dfile" and string_match(func.Arguments[1], "art[\\/]cars[\\/.][^\\/]+%.p3d")) then
			table_remove(functions, i)
		end
	end
	
	functions = LevelInit.Functions
	for i=1,#functions do
		local func = functions[i]
		local name = func.Name:lower()
		if name == "initlevelplayervehicle" then
			local carName = func.Arguments[1]
			LevelLoad:AddFunction("LoadDisposableCar", {"art\\cars\\" .. carName .. ".p3d",carName,"DEFAULT"})
		elseif name == "createchasemanager" or name == "addtrafficmodel" then
			local carName = func.Arguments[1]
			if not LoadedCars[carName] then
				LevelLoad:AddFunction("LoadP3DFile", "art\\cars\\" .. carName .. ".p3d")
				LoadedCars[carName] = true
			end
		end
	end
	
	return true
end)

function HandleMission(LevelNumber, MissionNumber, MissionLoad, MissionInit)
	local functions = MissionLoad.Functions
	for i=#functions,1,-1 do
		local func = functions[i]
		local name = func.Name:lower()
		
		if name == "loaddisposablecar" or (name == "loadp3dfile" and string_match(func.Arguments[1], "art[\\/]cars[\\/.][^\\/]+%.p3d")) then
			table_remove(functions, i)
		end
	end
	
	local MissionLoadedCars = {}

	functions = MissionInit.Functions
	for i=1,#functions do
		local func = functions[i]
		local name = func.Name:lower()
		
		if name == "initlevelplayervehicle" then
			local carName = func.Arguments[1]
			if not LoadedCars[carName] and not MissionLoadedCars[carName] then
				MissionLoad:AddFunction("LoadDisposableCar", {"art\\cars\\" .. carName .. ".p3d",carName,"OTHER"})
			end
		elseif name == "addstagevehicle" then
			local carName = func.Arguments[1]
			if not LoadedCars[carName] and not MissionLoadedCars[carName] then
				MissionLoad:AddFunction("LoadDisposableCar", {"art\\cars\\" .. carName .. ".p3d",carName,"AI"})
				MissionLoadedCars[carName] = true
			end
		end
	end
	
	return true
end

HandleVehicleLoads:AddSundayDriveHandler(HandleMission)
HandleVehicleLoads:AddMissionHandler(HandleMission)
HandleVehicleLoads:AddRaceHandler(HandleMission)

return HandleVehicleLoads