local math_random = math.random
local string_match = string.match
local table_remove = table.remove
local table_unpack = table.unpack

local RandomNPCVehicles = Module("Random NPC Vehicles", "RandomNPCVehicles", 4)

local CarNames = {table_unpack(CarNames)}
for i=CarCount,1,-1 do
	if not Settings[CarNames[i] .. "Mission"] then
		table_remove(CarNames, i)
	end
end
local CarCount = #CarNames

if CarCount < 5 and Settings[RandomNPCVehicles.Setting] then
	Alert("You must have at least 5 vehicle selected for the random mission pool.")
	os.exit()
end

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
	local carNamePool = {table_unpack(CarNames)}
	
	local carMap = {}
	local spawnMap = {}
	
	for Function in MissionInit:GetFunctions() do
		local name = Function.Name:lower()
		
		if name == "addstagevehicle" then
			local origCarName = Function.Arguments[1]
			local spawnLocator = Function.Arguments[2]
			
			local randomCarName
			spawnMap[origCarName] = spawnMap[origCarName] or {}
			if spawnMap[origCarName][spawnLocator] then
				randomCarName = spawnMap[origCarName][spawnLocator]
			else
				local randomCarIndex = math_random(#carNamePool)
				randomCarName = carNamePool[randomCarIndex]
				table_remove(carNamePool, randomCarIndex)
				if #carNamePool == 0 then
					carNamePool = {table_unpack(CarNames)}
				end
				spawnMap[origCarName][spawnLocator] = randomCarName
				print("Replacing NPC car \"" .. origCarName .. "\" with: " .. randomCarName)
			end
			
			carMap[origCarName] = randomCarName
			
			Function.Arguments[1] = randomCarName
			if Settings.RandomNPCVehiclesStats then
				Function.Arguments[4] = randomCarName .. ".con"
			end
		elseif VehicleFunctions[name] then
			local index = VehicleFunctions[name]
			local car = carMap[Function.Arguments[index]]
			if car then
				Function.Arguments[index] = car
			end
		end
	end
	
	return true
end

RandomNPCVehicles:AddMissionHandler(HandleMission)
RandomNPCVehicles:AddRaceHandler(HandleMission)

return RandomNPCVehicles