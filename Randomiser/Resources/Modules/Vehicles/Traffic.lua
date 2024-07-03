local math_random = math.random
local string_match = string.match
local table_remove = table.remove
local table_unpack = table.unpack

local GetFileName = GetFileName
local RemoveFileExtension = RemoveFileExtension

local RandomTraffic = Module("Random Traffic", "RandomTraffic", 3)

local CarNames = {table_unpack(CarNames)}
local CarP3DFiles = {table_unpack(CarP3DFiles)}
for i=CarCount,1,-1 do
	if not Settings[CarNames[i] .. "Traffic"] then
		table_remove(CarNames, i)
		table_remove(CarP3DFiles, i)
	end
end
local CarCount = #CarNames

if CarCount < 5 and Settings[RandomTraffic.Setting] then
	Alert("You must have at least 5 vehicle selected for the random traffic pool.")
	os.exit()
end

RandomTraffic:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	local carP3DPool = {table_unpack(CarP3DFiles)}
	local carNamePool = {table_unpack(CarNames)}
	
	local removedTraffic = {}
	local addedTraffic = {}
	
	local functions = LevelInit.Functions
	for i=#functions,1,-1 do
		local func = functions[i]
		local name = func.Name:lower()
		if name == "addtrafficmodel" then
			removedTraffic[func.Arguments[1]] = true
			table_remove(functions, i)
		elseif name == "createtrafficgroup" then
			for j=1,5 do
				local randomCarIndex = math_random(#carP3DPool)
				local randomCarP3D = carP3DPool[randomCarIndex]
				local randomCarName = carNamePool[randomCarIndex]
				table_remove(carP3DPool, randomCarIndex)
				table_remove(carNamePool, randomCarIndex)
				
				addedTraffic[randomCarP3D] = randomCarName
				
				local args = {randomCarName, 1}
				if math.random(3) == 1 then
					args[3] = 1
				end
				
				if #carP3DPool == 0 then
					args[2] = 6 - j
					LevelInit:InsertFunction(i + 1, "AddTrafficModel", args)
					break
				end
				
				LevelInit:InsertFunction(i + 1, "AddTrafficModel", args)
			end
		end
	end
	
	return true
end)

return RandomTraffic