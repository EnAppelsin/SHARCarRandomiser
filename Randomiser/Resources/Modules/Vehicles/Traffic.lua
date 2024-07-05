local math_random = math.random
local table_remove = table.remove
local table_unpack = table.unpack

local GetFileName = GetFileName
local RemoveFileExtension = RemoveFileExtension

local RandomTraffic = Module("Random Traffic", "RandomTraffic", 3)

local CarNames = {table_unpack(CarNames)}
for i=CarCount,1,-1 do
	if not Settings[CarNames[i] .. "Traffic"] then
		table_remove(CarNames, i)
	end
end
local CarCount = #CarNames

if CarCount < 5 and Settings[RandomTraffic.Setting] then
	Alert("You must have at least 5 vehicle selected for the random traffic pool.")
	os.exit()
end

RandomTraffic:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	local carNamePool = {table_unpack(CarNames)}
	
	for Function, Index in LevelInit:GetFunctions("AddTrafficModel", true) do
		LevelInit:RemoveFunction(Index)
	end
	for Function, Index in LevelInit:GetFunctions("CreateTrafficGroup", true) do
		for j=1,5 do
			local randomCarIndex = math_random(#carNamePool)
			local randomCarName = carNamePool[randomCarIndex]
			table_remove(carNamePool, randomCarIndex)
			
			local args = {randomCarName, 1}
			if math_random(3) == 1 then
				args[3] = 1
			end
			
			if #carNamePool == 0 then
				args[2] = 6 - j
				LevelInit:InsertFunction(Index + 1, "AddTrafficModel", args)
				break
			end
			
			LevelInit:InsertFunction(Index + 1, "AddTrafficModel", args)
		end
	end
	
	return true
end)

return RandomTraffic