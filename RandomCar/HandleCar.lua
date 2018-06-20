-- Load the file
local Path = "/GameData/" .. GetPath();
local File = ReadFile(Path);

-- Only update the randomly spawned car
if RandomCarName and string.match(Path, RandomCarName) then

	if GetSetting("BoostHP") then
		HP = string.match(File, "SetHitPoints%((.-)%);")
		if HP and tonumber(HP) < 0.8 then
			File = string.gsub(File, "SetHitPoints%(.-%);", "SetHitPoints(0.8);", 1)
			print("Boosting HP up from " .. HP .. " to 0.8 for " .. Path)
		end
	end
	
end

if GetSetting("RandomMissionVehicles") and MissionVehicles then
	for k,v in pairs(MissionVehicles) do
		if string.match(Path, v) then
			HP = string.match(File, "SetHitPoints%((.-)%);")
			if HP and tonumber(HP) < 0.6 then
				File = string.gsub(File, "SetHitPoints%(.-%);", "SetHitPoints(0.6);", 1)
				print("Boosting HP up from " .. HP .. " to 0.6 for " .. Path)
			end
		end
	end
end

if GetSetting("RandomPedestrians") then
	local TmpDriverPool = {}
	for k in pairs(CarDrivers) do
		table.insert(TmpDriverPool, k)
	end
	local driver = math.random(#TmpDriverPool)
	local driverName = TmpDriverPool[driver]
		if string.match(File, "SetCharactersVisible%(%s*1%s*%);") then
		File = string.gsub(File, "SetDriver%(%s*\"(.-)\"%s*%);", function(orig)
			if GetSetting("RandomTraffic") and TrafficCars and #TrafficCars > 0 then
				for i = 1, #TrafficCars do
					if string.match(Path, TrafficCars[i]) then
						print("Setting driver for traffic car " .. TrafficCars[i])
						return "SetDriver(\"" .. driverName .. "\");"
					end
				end
			end
			if orig == "none" then
				return "SetDriver(\"" .. orig .. "\");"
			else
				return "SetDriver(\"" .. driverName .. "\");"
			end
		end)
	end
end


Output(File)
