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

local VehicleFunctions = {
	["activatevehicle"] = 1,
	["setvehicleaiparams"] = 1,
	["setstageairacecatchupparams"] = 1,
	["setstageaitargetcatchupparams"] = 1,
	["setcondtargetvehicle"] = 1,
	["setobjtargetvehicle"] = 1,
	["adddriver"] = 2,
}

function HandleMission(LevelNumber, MissionNumber, MissionLoad, MissionInit)
	-- TODO: Save on reload if some setting enabled or something
	local carP3DPool = {table_unpack(CarP3DFiles)}
	local carNamePool = {table_unpack(CarNames)}
	
	local LoadedMissionsCars = {}
	
	local functions = MissionLoad.Functions
	for i=#functions,1,-1 do
		local func = functions[i]
		local name = func.Name:lower()
		if name == "loaddisposablecar" and func.Arguments[3] == "AI" then
			table_remove(functions, i)
		elseif LoadP3DFunctions[name] then
			local carName = string_match(func.Arguments[1], "art[\\/]cars[\\/]([^\\/]+)%.p3d")
			if carName ~= nil then
				LoadedMissionsCars[carName] = true
			end
		end
	end
	
	local addedCars = {}
	local carMap = {}
	
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
			
			local origCarName = func.Arguments[1]
			addedCars[randomCarP3D] = randomCarName
			carMap[origCarName] = randomCarName
			
			print("Replacing NPC car \"" .. origCarName .. "\" with: " .. randomCarName)
			func.Arguments[1] = randomCarName
			if Settings.RandomNPCVehiclesStats then
				func.Arguments[4] = randomCarName .. ".con"
			end
		elseif VehicleFunctions[name] then
			local index = VehicleFunctions[name]
			local car = carMap[func.Arguments[index]]
			if car then
				func.Arguments[index] = car
			end
		end
	end
	
	for k,v in pairs(addedCars) do
		if not LoadedCars[v] and not LoadedMissionsCars[v] then
			MissionLoad:AddFunction("LoadDisposableCar", {k,v,"AI"})
		end
	end
	
	return true
end

RandomNPCVehicles:AddMissionHandler(HandleMission)
RandomNPCVehicles:AddRaceHandler(HandleMission)

return RandomNPCVehicles