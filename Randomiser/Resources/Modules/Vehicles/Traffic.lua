local math_random = math.random
local string_match = string.match
local table_remove = table.remove
local table_unpack = table.unpack

local GetFileName = GetFileName
local RemoveFileExtension = RemoveFileExtension

local RandomTraffic = Module("Random Traffic", "RandomTraffic", 2)

RandomTraffic:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	local carP3DPool = {table_unpack(CarP3DFiles)}
	local carNamePool = {table_unpack(CarNames)}
	
	local removedTraffic = {}
	local addedTraffic = {}
	local chaseCar
	
	local functions = LevelInit.Functions
	for i=#functions,1,-1 do
		local func = functions[i]
		local name = func.Name:lower()
		if name == "createchasemanager" then
			chaseCar = func.Arguments[1]
		elseif name == "addtrafficmodel" then
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
	
	local loadedCars = {}
	functions = LevelLoad.Functions
	for i=#functions,1,-1 do
		local func = functions[i]
		local name = func.Name:lower()
		if name == "loadp3dfile" then
			local carName = string_match(func.Arguments[1], "art[\\/]cars[\\/]([^\\/]+)%.p3d")
			if carName ~= nil then
				if chaseCar ~= carName and removedTraffic[carName] then
					table_remove(functions, i)
				else
					loadedCars[carName] = true
				end
			end
		elseif name == "loaddisposablecar" then
			local carName = string_match(func.Arguments[1], "art[\\/]cars[\\/]([^\\/]+)%.p3d")
			if carName then
				loadedCars[carName] = true
			end
		end
	end
	for k,v in pairs(addedTraffic) do
		if not loadedCars[v] then
			LevelLoad:AddFunction("LoadP3DFile", k)
		end
	end
	
	return true
end)

return RandomTraffic