local hasFolder = false

DirectoryGetEntries("/GameData", function(name, directory)
	if directory and name == "CustomCars" then
		hasFolder = true
	end
	return true
end)

local function addCar(tbl, carName, carTune, carSound)
	local add = true
	for i = 1, #tbl do
		if tbl[i]:lower() == carName:lower() then
			add = false
			break
		end
	end
	if add then
		if carTune then
			cartunespt = cartunespt .. "\r\n" .. carTune
		end
		if carSound then
			carsoundspt = carsoundspt .. "\r\n" .. carSound
		end
		table.insert(tbl, carName)
		table.insert(CustomCarPool, carName)
		table.insert(RandomCarPoolPlayer, carName)
		table.insert(RandomCarPoolTraffic, carName)
		table.insert(RandomCarPoolMission, carName)
		table.insert(RandomCarPoolChase, carName)
		return true
	else
		return false
	end
end

if hasFolder then
	local loadedCars = {}
	local loadedSounds = {}
	for carname in cartunespt:gmatch("create carSoundParameters named (.-)\r\n") do
		table.insert(loadedCars, carname)
	end
	for carsound in carsoundspt:gmatch("create daSoundResourceData named (.-)\r\n") do
		table.insert(loadedSounds, carsound)
	end

	local customCarDirs = {}
	GetDirs(customCarDirs, "/GameData/CustomCars/")
	DebugPrint("Found " .. #customCarDirs .. " custom car directories.")
	
	for i = 1, #customCarDirs do
		local customCarName = customCarDirs[i]
		local customCarDir = "/GameData/CustomCars/" .. customCarName .. "/"
		
		if not Exists(customCarDir .. customCarName .. ".p3d", true, true) then
			DebugPrint("Could not load Custom Car " .. customCarName .. " due to missing P3D model.")
		elseif not Exists(customCarDir .. customCarName .. ".con", true, true) then
			DebugPrint("Could not load Custom Car " .. customCarName .. " due to missing CON settings.")
		elseif not Exists(customCarDir .. "car_tune.spt", true, true) then
			DebugPrint("Could not load Custom Car " .. customCarName .. " due to missing car_tune.spt.")
		else --Everything exists, try to add it
			local customCarTuneSpt = ReadFile(customCarDir .. "car_tune.spt")
			if not customCarTuneSpt == customCarTuneSpt:match("create carSoundParameters named " .. customCarName .. "\r\n{.-}") then
				DebugPrint("Could not load Custom Car " .. customCarName .. " due to invalid car_tune.spt.")
			else
				if not Exists(customCarDir .. "carsound.spt", true, true) then
					if addCar(loadedCars, customCarName, customCarTuneSpt) then
						DebugPrint("Added Custom Car " .. customCarName)
					else
						DebugPrint("Could not add Custom Car " .. customCarName .. " due to conflicts with existing cars")
					end
				else
					local add = true
					local customCarSoundSpt = ReadFile(customCarDir .. "carsound.spt")
					local customSounds = {}
					for carsound, carsounddata in customCarSoundSpt:gmatch("create daSoundResourceData named (.-)\r\n{\r\n(.-)}") do
						for j = 1, #loadedSounds do
							if loadedSounds[i]:lower() == carsound:lower() then
								add = false
								DebugPrint("Could not load Custom Car " .. customCarName .. " due to conflicting sound file " .. carsound)
								break
							end
						end
						if not add then
							break
						else
							local fileName = carsounddata:match("AddFilename%s*%(%s*\"(.-)\"")
							if not fileName then
								add = false
								DebugPrint("Could not load Custom Car " .. customCarName .. " due to invalid sound " .. carsound)
								break
							end
							if not add then
								break
							else
								if Exists(customCarDir .. fileName, true, true) then
									table.insert(loadedSounds, carsound)
									customSounds[fileName] = customCarDir .. fileName
								else
									add = false
									DebugPrint("Could not load Custom Car " .. customCarName .. " due to missing sound file " .. fileName)
									break
								end
							end
						end
					end
					if add then
						if addCar(loadedCars, customCarName, customCarTuneSpt, customCarSoundSpt) then
							for k,v in pairs(customSounds) do
								CustomCarSounds[k] = v
							end
							DebugPrint("Added Custom Car " .. customCarName)
						else
							DebugPrint("Could not add Custom Car " .. customCarName .. " due to conflicts with existing cars")
						end
					end
				end
			end
		end
	end
end