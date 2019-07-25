-- Load the file
local Path = "/GameData/" .. GetPath();
local File = ReadFile(Path):gsub("//.-([\r\n])", "%1");

	local level = tonumber(Path:match("level0(%d)"))
	local bmission = tonumber(Path:match("bm(%d)l"))
    local mission = tonumber(Path:match("m(%d)l"))
    local sr = tonumber(Path:match("sr(%d)l"))
    local gr = tonumber(Path:match("gr(%d)l"))
    if bmission then
        DebugPrint("NEW MISSION LOAD: Level " .. level .. ", Bonus Mission " .. bmission)
    elseif mission then
        DebugPrint("NEW MISSION LOAD: Level " .. level .. ", Mission " .. mission)
    elseif sr then
        DebugPrint("NEW MISSION LOAD: Level " .. level .. ", Street Race " .. sr)
    elseif gr then
        DebugPrint("NEW MISSION LOAD: Level " .. level .. ", Gambling Race " .. gr)
    end
	if SettingRandomMissionVehicles then
		DebugPrint("Checking for sub level cars in " .. Lidx)
		if SettingSaveChoiceMV then
			if LastLevelMV == nil or LastLevelMV ~= Path then			
				MissionVehicles = {}
				local TmpCarPool = {table.unpack(RandomCarPoolMission)}
				if SettingDifferentCellouts and level == 2 and mission == 7 then
					File = ReadFile(ModPath .. "/Resources/l2m7l.mfk")
				end
				for orig in File:gmatch("LoadP3DFile%s*%(%s*\"art\\cars\\([^\n]-)%.p3d\"%s*%);") do
					local carName = GetRandomFromTbl(TmpCarPool, true)
					if #TmpCarPool == 0 then
						TmpCarPool = {table.unpack(RandomCarPoolMission)}
					end
					MissionVehicles[orig] = carName
					DebugPrint("Randomising " .. orig .. " to " .. carName)
				end
				for orig,var2,carType in File:gmatch("LoadDisposableCar%s*%(%s*\"art\\cars\\([^\n]-)%.p3d\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*%);") do
					if carType == "AI" then
						local carName = GetRandomFromTbl(TmpCarPool, true)
						if #TmpCarPool == 0 then
							TmpCarPool = {table.unpack(RandomCarPoolMission)}
						end
						MissionVehicles[orig] = carName
						DebugPrint("Randomising " .. orig .. " to " .. carName)
					end
				end
			elseif SettingDifferentCellouts and level == 2 and mission == 7 then
				File = ReadFile(ModPath .. "/Resources/l2m7l.mfk")
			end
			LastLevelMV = Path
		else
			MissionVehicles = {}
			local TmpCarPool = {table.unpack(RandomCarPoolMission)}
			if SettingDifferentCellouts and level == 2 and mission == 7 then
				File = ReadFile(ModPath .. "/Resources/l2m7l.mfk")
			end
			for orig in File:gmatch("LoadP3DFile%s*%(%s*\"art\\cars\\([^\n]-)%.p3d\"%s*%);") do
				local carName = GetRandomFromTbl(TmpCarPool, true)
				if #TmpCarPool == 0 then
					TmpCarPool = {table.unpack(RandomCarPoolMission)}
				end
				MissionVehicles[orig] = carName
				DebugPrint("Randomising " .. orig .. " to " .. carName)
			end
			for orig,var2,carType in File:gmatch("LoadDisposableCar%s*%(%s*\"art\\cars\\([^\n]-)%.p3d\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*%);") do
				if carType == "AI" then
					local carName = GetRandomFromTbl(TmpCarPool, true)
					if #TmpCarPool == 0 then
						TmpCarPool = {table.unpack(RandomCarPoolMission)}
					end
					MissionVehicles[orig] = carName
					DebugPrint("Randomising " .. orig .. " to " .. carName)
				end
			end
		end
		for k,v in pairs(MissionVehicles) do
			File = File:gsub("LoadP3DFile%s*%(%s*\"art\\cars\\" .. k .. "%.p3d\"%s*%);", "LoadP3DFile(\"art\\cars\\" .. v .. ".p3d\");")
			File = File:gsub("LoadDisposableCar%s*%(%s*\"art\\cars\\" .. k .."%.p3d\"%s*,%s*\"" .. k .. "\"%s*,%s*\"AI\"%s*%);", "LoadDisposableCar(\"art\\cars\\" .. v .. ".p3d\",\"" .. v .. "\",\"AI\");")
			File = File:gsub("LoadDisposableCar%s*%(%s*\"art\\cars\\" .. k .."%.p3d\"%s*,%s*\"cvan\"%s*,%s*\"AI\"%s*%);", "LoadDisposableCar(\"art\\cars\\" .. v .. ".p3d\",\"" .. v .. "\",\"AI\");")
		end
	end
	if SettingRandomItems then
		itemReplace = {}
		File = File:gsub("LoadP3DFile%s*%(%s*\"art\\missions([^\n]-)%.p3d\"", function(orig)
			local origName = nil
			for k,v in pairs(RandomItemPool) do
				if v == orig then
					origName = k
					break
				end
			end
			if origName ~= nil then
				local randName, rand = GetRandomFromKVTbl(RandomItemPool, false)
				DebugPrint("Replacing item " .. orig .. " with " .. rand .. " (" .. randName .. ")")
				itemReplace[origName] = randName
				return "LoadP3DFile(\"art\\missions" .. rand .. ".p3d\""
			else
				return "LoadP3DFile(\"art\\missions" .. orig .. ".p3d\""
			end
		end)
	end
    if SettingRandomDirectives then
		iconReplace = {}
		File = File:gsub("LoadP3DFile%s*%(%s*\"art\\frontend\\dynaload\\images\\msnicons([^\n]-)%.p3d\"%s*", function(orig)
			local rand = GetRandomFromTbl(IconP3DPool, false)
			local origName = orig:sub(findLast(orig, "\\") + 1)
			local randName = rand:sub(findLast(rand, "\\") + 1)
			iconReplace[origName] = randName
			DebugPrint("Replacing directive icon " .. origName .. " with " .. randName)
			return "LoadP3DFile(\"art\\frontend\\dynaload\\images\\msnicons" .. rand .. ".p3d\""
		end)
	end
	if SettingRandomPlayerVehicles then
		if SettingSaveChoice then
			if LastLevel ~= Path then
				RandomCar = math.random(#RandomCarPoolPlayer)
			end
			LastLevel = Path
		else
			RandomCar = math.random(#RandomCarPoolPlayer)
		end
		RandomCarName = RandomCarPoolPlayer[RandomCar]

		local ForcedMission = false
		local Match
		
		-- Try to find a forced vehicle spawn
		Match = File:match("LoadDisposableCar%s*%(%s*\".-\"%s*,%s*\".-\"%s*,%s*\"OTHER\"%s*%)")
		if Match ~= nil then
			ForcedMission = true
			-- Replace it with the random vehicle
			-- The (.*) at the start is weird but tries to capture as much outside the LoadDisposableCar function
			-- Otherwise if an AI LoadDisposableCar appears first the .- captures two LoadDisposableCar calls,
			-- So one of the LoadDisposableCar calls gets deleted, and the game crashes because something isn't loaded
			-- There's probably a smarter way than this...?
			File = File:gsub("(.*)LoadDisposableCar%s*%(%s*\".-\"%s*,%s*\".-\"%s*,%s*\"OTHER\"%s*%);", "%1LoadDisposableCar(\"art\\cars\\" .. RandomCarName .. ".p3d\",\"" .. RandomCarName .. "\",\"OTHER\");", 1)
		else
			-- Add a new command to the end to load the random vehicle
			File = File .. "\r\nLoadDisposableCar(\"art\\cars\\" .. RandomCarName .. ".p3d\", \"" .. RandomCarName .. "\", \"OTHER\");"
		end
		-- Debugging
		DebugPrint("Randomising car for mission (load) " ..  Lidx .. " -> " .. RandomCarName .. (ForcedMission and " (forced)" or ""))
	end

Output(File)