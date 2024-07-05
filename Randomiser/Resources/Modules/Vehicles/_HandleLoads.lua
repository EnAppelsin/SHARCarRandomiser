local string_match = string.match
local table_remove = table.remove

local HandleVehicleLoads = Module("Handle Vehicle Loads", nil, 69420)

local LoadedCars

HandleVehicleLoads:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	LoadedCars = {}
	
	for Function, Index in LevelLoad:GetFunctions(nil, true) do
		local name = Function.Name:lower()
		
		if name == "loaddisposablecar" or (name == "loadp3dfile" and string_match(Function.Arguments[1], "art[\\/]cars[\\/.][^\\/]+%.p3d")) then
			LevelLoad:RemoveFunction(Index)
		end
	end
	
	for Function in LevelInit:GetFunctions() do
		local name = Function.Name:lower()
		if name == "initlevelplayervehicle" then
			local carName = Function.Arguments[1]
			LevelLoad:AddFunction("LoadDisposableCar", {"art\\cars\\" .. carName .. ".p3d",carName,"DEFAULT"})
		elseif name == "createchasemanager" or name == "addtrafficmodel" then
			local carName = Function.Arguments[1]
			if not LoadedCars[carName] then
				LevelLoad:AddFunction("LoadP3DFile", "art\\cars\\" .. carName .. ".p3d")
				LoadedCars[carName] = true
			end
		end
	end
	
	return true
end)

function HandleMission(LevelNumber, MissionNumber, MissionLoad, MissionInit)
	for Function, Index in MissionLoad:GetFunctions(nil, true) do
		local name = Function.Name:lower()
		
		if name == "loaddisposablecar" or (name == "loadp3dfile" and string_match(Function.Arguments[1], "art[\\/]cars[\\/.][^\\/]+%.p3d")) then
			MissionLoad:RemoveFunction(Index)
		end
	end
	
	local MissionLoadedCars = {}

	for Function in MissionInit:GetFunctions() do
		local name = Function.Name:lower()
		
		if name == "initlevelplayervehicle" then
			local carName = Function.Arguments[1]
			if not LoadedCars[carName] and not MissionLoadedCars[carName] then
				MissionLoad:AddFunction("LoadDisposableCar", {"art\\cars\\" .. carName .. ".p3d",carName,"OTHER"})
			end
		elseif name == "addstagevehicle" then
			local carName = Function.Arguments[1]
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