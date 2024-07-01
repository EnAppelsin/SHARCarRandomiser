local math_random = math.random
local string_match = string.match
local table_remove = table.remove
local table_unpack = table.unpack

local RandomNPCVehicles = Module("Random NPC Vehicles", "RandomNPCVehicles", 4)

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
	
	local carMap = {}
	local spawnMap = {}
	
	functions = MissionInit.Functions
	for i=1,#functions do
		local func = functions[i]
		local name = func.Name:lower()
		
		if name == "addstagevehicle" then
			local origCarName = func.Arguments[1]
			local spawnLocator = func.Arguments[2]
			
			local randomCarP3D, randomCarName
			spawnMap[origCarName] = spawnMap[origCarName] or {}
			if spawnMap[origCarName][spawnLocator] then
				randomCarP3D, randomCarName = table_unpack(spawnMap[origCarName][spawnLocator])
			else
				local randomCarIndex = math_random(#carP3DPool)
				randomCarP3D = carP3DPool[randomCarIndex]
				randomCarName = carNamePool[randomCarIndex]
				table_remove(carP3DPool, randomCarIndex)
				table_remove(carNamePool, randomCarIndex)
				if #carP3DPool == 0 then
					carP3DPool = {table_unpack(CarP3DFiles)}
					carNamePool = {table_unpack(CarNames)}
				end
				spawnMap[origCarName][spawnLocator] = {randomCarP3D, randomCarName}
				print("Replacing NPC car \"" .. origCarName .. "\" with: " .. randomCarName)
			end
			
			carMap[origCarName] = randomCarName
			
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
	
	return true
end

RandomNPCVehicles:AddMissionHandler(HandleMission)
RandomNPCVehicles:AddRaceHandler(HandleMission)

return RandomNPCVehicles