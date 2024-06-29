local math_random = math.random
local string_match = string.match
local table_remove = table.remove
local table_unpack = table.unpack

local RandomNPCVehicles = Module("Random NPC Vehicles", "RandomNPCVehicles", 4)

local LoadP3DFunctions = {
	["loadp3dfile"] = true,
	["loaddisposablecar"] = true,
}

local LoadedCars

RandomNPCVehicles:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	LoadedCars = {}
	
	local functions = LevelLoad.Functions
	for i=#functions,1,-1 do
		local func = functions[i]
		local name = func.Name:lower()
		if LoadP3DFunctions[name] then
			local carName = string_match(func.Arguments[1], "art[\\/]cars[\\/]([^\\/]+)%.p3d")
			if carName ~= nil then
				LoadedCars[carName] = true
			end
		end
	end
	
	return false
end)


RandomNPCVehicles:AddMissionHandler(function(LevelNumber, MissionNumber, MissionLoad, MissionInit)
	-- TODO: Save on reload if some setting enabled or something
	local carP3DPool = {table_unpack(CarP3DFiles)}
	local carNamePool = {table_unpack(CarNames)}
	
	local functions = MissionLoad.Functions
	for i=#functions,1,-1 do
		local func = functions[i]
		local name = func.Name:lower()
		if name == "loaddisposablecar" and func.Arguments[3] == "AI" then
			table_remove(functions, i)
		elseif LoadP3DFunctions[name] then
			local carName = string_match(func.Arguments[1], "art[\\/]cars[\\/]([^\\/]+)%.p3d")
			if carName ~= nil then
				LoadedCars[carName] = true
			end
		end
	end
	
	local addedCars = {}
	
	functions = MissionInit.Functions
	for i=1,#functions do
		local func = functions[i]
		local name = func.Name:lower()
		
		if name == "addstagevehicle" then
			local randomCarIndex = math_random(#carP3DPool)
			local randomCarP3D = carP3DPool[randomCarIndex]
			local randomCarName = carNamePool[randomCarIndex]
			table_remove(carP3DPool, randomCarIndex)
			table_remove(carNamePool, randomCarIndex)
			if #carP3DPool == 0 then
				carP3DPool = {table_unpack(CarP3DFiles)}
				carNamePool = {table_unpack(CarNames)}
			end
			
			addedCars[randomCarP3D] = randomCarName
			
			local origCarName = func.Arguments[1]
			func.Arguments[1] = randomCarName
			func.Arguments[4] = randomCarName .. ".con"
			MissionInit:SetAll("ActivateVehicle", 1, randomCarName, origCarName)
			MissionInit:SetAll("SetVehicleAIParams", 1, randomCarName, origCarName)
			MissionInit:SetAll("SetStageAIRaceCatchupParams", 1, randomCarName, origCarName)
			MissionInit:SetAll("SetStageAITargetCatchupParams", 1, randomCarName, origCarName)
			MissionInit:SetAll("SetCondTargetVehicle", 1, randomCarName, origCarName)
			MissionInit:SetAll("SetObjTargetVehicle", 1, randomCarName, origCarName)
			MissionInit:SetAll("AddDriver", 2, randomCarName, origCarName)
		end
	end
	
	for k,v in pairs(addedCars) do
		if not LoadedCars[v] then
			MissionLoad:AddFunction("LoadDisposableCar", {k,v,"AI"})
		end
	end
	
	return true
end)

return RandomNPCVehicles