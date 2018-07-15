-- Load the file
local Path = "/GameData/" .. GetPath();
local File = ReadFile(Path);

-- Determine if the file is for a mission (bonus, main or races)
local Midx = Path:match("b?m%di%.mfk") or Path:match("[gs]r%di%.mfk")
local Lidx = Path:match("b?m%dl%.mfk") or Path:match("[gs]r%dl%.mfk")
-- Determine if the file is for a level
local LevelLoad = Path:match("level%.mfk")
local LevelInit = Path:match("leveli%.mfk")
-- Determine if the file is for "sunday drive" (pre-mission)
local SDLoad = Path:match("m%dsdl%.mfk")
local SDInit = Path:match("m%dsdi%.mfk")

-- Remove comments because there's A LOT of commented out stuff that can confuse the simple regexes below
local NewFile = File:gsub("//.-\r\n", "\r\n")

if Midx ~= nil then
	local level = Path:match("level0(%d)")
	local mission = Path:match("m(%d)i")
	DebugPrint("NEW MISSION INIT: Level " .. level .. ", Mission " .. mission)
	if SettingRandomMissionCharacters then
		MissionCharacters = {}
		local found = "Found mission characters: "
		for npc in NewFile:gmatch("AddNPC%s*%(%s*\"(.-)\"") do
			table.insert(MissionCharacters, npc)
			found = found .. npc .. ", "
		end
		DebugPrint(found)
	end
	-- The random car should have been predecided by the mission load script
	if SettingRandomPlayerVehicles then
		local ForcedMission = false
		local Spawn, Match
		-- Try to find a forced vehicle spawn
		Match = NewFile:match("InitLevelPlayerVehicle%s*%(%s*\".-\"%s*,%s*\".-\"%s*,%s*\"OTHER\"%s*%)")
		if Match ~= nil then
			ForcedMission = true
			-- Replace it with the random vehicle
			NewFile = NewFile:gsub("InitLevelPlayerVehicle%s*%(%s*\".-\"%s*,%s*\"(.-)\"%s*,%s*\"OTHER\"%s*%)", "InitLevelPlayerVehicle(\"" .. RandomCarName .. "\",\"%1\",\"OTHER\")", 1)
		else
			-- Try to find the spawn point
			Match, Spawn = NewFile:match("SetMissionResetPlayerOutCar%s*%(%s*\"(.-)\"%s*,%s*\"(.-)\"%s*%);")
			if Match == nil then
				Spawn = NewFile:match("SetMissionResetPlayerInCar%s*%(%s*\"(.-)\"%s*%);")
			end
			if Spawn ~= nil then
				NewFile = NewFile:gsub("(SetDynaLoadData%s*%(.-%s*%);%s*\r\n)", "%1InitLevelPlayerVehicle(\"" .. RandomCarName .. "\", \"" .. Spawn .. "\", \"OTHER\");\r\nSetForcedCar();\r\n", 1)
				-- Because we create a "forced vehicle", delete stages before the reset as it automatically respawns you to the reset point anyway
				-- (So objectives like "leave office" or "head to car" don't work)
				-- Also look if we delete a stage which adds a vehicle, then replicate that. (TODO: Is this all?)
				
				-- Take a substring because we don't care about anything after RESET_TO_HERE (which appears once) and if we don't then
				-- Wolves takes AGES to (fail to) match the regex below. 
				ResetIndex = NewFile:find("RESET_TO_HERE%s*%(%s*%)")
				if ResetIndex then
					EarlySubstring = NewFile:sub(1, ResetIndex+15)			
					Match = EarlySubstring:match("AddStage%s*%(.-%s*%);.*(AddStageVehicle%s*%(.-%s*%);).*AddStage%s*%(.-%s*%);%s*\r\n%s*RESET_TO_HERE%s*%(%s*%);")
					FakeStage = ""
					if Match ~= nil then
						FakeStage = "AddStage();\r\n" .. Match .. "\r\nAddObjective(\"timer\");\r\nSetDurationTime(1);\r\nCloseObjective();\r\nCloseStage();\r\n"
						DebugPrint("Creating a fake add vehicle stage")
					end
					NewFile = NewFile:gsub("\r\nAddStage%s*%(.-%s*%);.*AddStage%s*%((.-)%s*%);%s*\r\n%s*RESET_TO_HERE%s*%(%s*%);", "\r\n" .. FakeStage .. "AddStage(%1);\r\nRESET_TO_HERE();", 1)
					DebugPrint("Deleting an early stage")
				end
			end
		end
		-- Debugging
		DebugPrint("Randomising car for mission " ..  Midx .. " -> " .. RandomCarName .. (ForcedMission and " (forced)" or ""))
	end
	if SettingSkipFMVs then
		NewFile = NewFile:gsub("AddObjective%s*%(\"fmv\"%s*%);.-CloseObjective%s*%(%s*%);", "AddObjective(\"timer\");\r\nSetDurationTime(1);\r\nCloseObjective();", 1)
	end
	if SettingRandomChase then
		NewFile = NewFile:gsub("\"cPolice\"", "\"" .. RandomChase .. "\"")
		NewFile = NewFile:gsub("\"cHears\"", "\"" .. RandomChase .. "\"")
	end
	if SettingRandomMissionVehicles then
		if SettingDifferentCellouts and level == 2 and mission == 7 then
			NewFile = NewFile:gsub("AddStageVehicle%s*%(\"cCellA\",\"m7_cellstart(%d)", "AddStageVehicle(\"cCellA%1\",\"m7_cellstart%1")
			NewFile = NewFile:gsub("ActivateVehicle%s*%(\"cCellA\"(.-)\r\n", "ActivateVehicle(\"cCellA1\"%1\r\nSetHitNRun();\r\n")
			local i = 0
			NewFile = NewFile:gsub("SetVehicleAIParams%s*%(%s*\"cCellA\"", function()
				i = i + 1
				return "SetHitNRun();\r\n\tSetVehicleAIParams( \"cCellA" .. i .. "\""
			end)
			i = 0
			NewFile = NewFile:gsub("SetObjTargetVehicle%s*%(\"cCellA\"", function()
				i = i + 1
				return "SetObjTargetVehicle(\"cCellA" .. i .. "\""
			end)
			i = 1
			NewFile = NewFile:gsub("AddStageVehicle%s*%(\"cCellA\"", function()
				i = i + 1
				return "AddStageVehicle(\"cCellA" .. i .. "\""
			end)
		end
		for k,v in pairs(MissionVehicles) do
			DebugPrint("Replacing " .. k .. " with " .. v)
			if SettingRandomMissionVehiclesStats or SettingRandomStats then
				NewFile = NewFile:gsub("AddStageVehicle%s*%(%s*\"" .. k .. "\"%s*,%s*\"(.-)\"%s*,%s*\"(.-)\"%s*,%s*\".-\"", "AddStageVehicle(\"" .. v .. "\",\"%1\",\"%2\",\"" .. v .. ".con\"")
			else
				NewFile = NewFile:gsub("AddStageVehicle%s*%(%s*\"" .. k .. "\"", "AddStageVehicle(\"" .. v .. "\"")
			end
			NewFile = NewFile:gsub("ActivateVehicle%s*%(%s*\"" .. k .. "\"", "ActivateVehicle(\"" .. v .. "\"")
			NewFile = NewFile:gsub("SetVehicleAIParams%s*%(%s*\"" .. k .. "\"", "SetVehicleAIParams(\"" .. v .. "\"")
			NewFile = NewFile:gsub("SetStageAIRaceCatchupParams%s*%(%s*\"" .. k .. "\"", "SetStageAIRaceCatchupParams(\"" .. v .. "\"")
			NewFile = NewFile:gsub("SetStageAITargetCatchupParams%s*%(%s*\"" .. k .. "\"", "SetStageAITargetCatchupParams(\"" .. v .. "\"")
			NewFile = NewFile:gsub("SetCondTargetVehicle%s*%(%s*\"" .. k .. "\"", "SetCondTargetVehicle(\"" .. v .. "\"")
			NewFile = NewFile:gsub("SetObjTargetVehicle%s*%(%s*\"" .. k .. "\"", "SetObjTargetVehicle(\"" .. v .. "\"")
			NewFile = NewFile:gsub("AddDriver%s*%(%s*\"(.-)\"%s*,%s*\"" .. k .. "\"", "AddDriver(\"%1\",\"" .. v .. "\"")
		end
		for i = 1, #RemovedTrafficCars do
			local k = RemovedTrafficCars[i]
			local v = GetRandomFromTbl(TrafficCars, false)
			DebugPrint("Replacing " .. k .. " with " .. v)
			if SettingRandomMissionVehiclesStats or SettingRandomStats then
				NewFile = NewFile:gsub("AddStageVehicle%s*%(%s*\"" .. k .. "\"%s*,%s*\"(.-)\"%s*,%s*\"(.-)\"%s*,%s*\".-\"", "AddStageVehicle(\"" .. v .. "\",\"%1\",\"%2\",\"" .. v .. ".con\"")
			else
				NewFile = NewFile:gsub("AddStageVehicle%s*%(%s*\"" .. k .. "\"", "AddStageVehicle(\"" .. v .. "\"")
			end
			NewFile = NewFile:gsub("ActivateVehicle%s*%(%s*\"" .. k .. "\"", "ActivateVehicle(\"" .. v .. "\"")
			NewFile = NewFile:gsub("SetVehicleAIParams%s*%(%s*\"" .. k .. "\"", "SetVehicleAIParams(\"" .. v .. "\"")
			NewFile = NewFile:gsub("SetStageAIRaceCatchupParams%s*%(%s*\"" .. k .. "\"", "SetStageAIRaceCatchupParams(\"" .. v .. "\"")
			NewFile = NewFile:gsub("SetStageAITargetCatchupParams%s*%(%s*\"" .. k .. "\"", "SetStageAITargetCatchupParams(\"" .. v .. "\"")
			NewFile = NewFile:gsub("SetCondTargetVehicle%s*%(%s*\"" .. k .. "\"", "SetCondTargetVehicle(\"" .. v .. "\"")
			NewFile = NewFile:gsub("SetObjTargetVehicle%s*%(%s*\"" .. k .. "\"", "SetObjTargetVehicle(\"" .. v .. "\"")
			NewFile = NewFile:gsub("AddDriver%s*%(%s*\"(.-)\"%s*,%s*\"" .. k .. "\"", "AddDriver(\"%1\",\"" .. v .. "\"")
		end
		local TmpDriverPool = {table.unpack(RandomPedPool)}
		NewFile = NewFile:gsub("AddStageVehicle%s*%(%s*\"(.-)\"%s*,%s*\"(.-)\"%s*,%s*\"(.-)\"%s*,%s*\"(.-)\"%s*,%s*\"(.-)\"%s*%);", function(car, position, action, config, orig)
			local driverName = GetRandomFromTbl(TmpDriverPool, true)
			for k in pairs(CarDrivers) do
				if k == orig then
					return "AddStageVehicle(\"" .. car .. "\",\"" .. position .. "\",\"" .. action .. "\",\"" .. config .. "\",\"" .. driverName .. "\");"
				end
			end
			return "AddStageVehicle(\"" .. car .. "\",\"" .. position .. "\",\"" .. action .. "\",\"" .. config .. "\",\"" .. orig .. "\");"
		end)
	end
	
	Output(NewFile)
elseif Lidx ~= nil then
	local level = Path:match("level0(%d)")
	local mission = Path:match("m(%d)l")
	DebugPrint("NEW MISSION LOAD: Level " .. level .. ", Mission " .. mission)
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
		Match = NewFile:match("LoadDisposableCar%s*%(%s*\".-\"%s*,%s*\".-\"%s*,%s*\"OTHER\"%s*%)")
		if Match ~= nil then
			ForcedMission = true
			-- Replace it with the random vehicle
			-- The (.*) at the start is weird but tries to capture as much outside the LoadDisposableCar function
			-- Otherwise if an AI LoadDisposableCar appears first the .- captures two LoadDisposableCar calls,
			-- So one of the LoadDisposableCar calls gets deleted, and the game crashes because something isn't loaded
			-- There's probably a smarter way than this...?
			NewFile = NewFile:gsub("(.*)LoadDisposableCar%s*%(%s*\".-\"%s*,%s*\".-\"%s*,%s*\"OTHER\"%s*%);", "%1LoadDisposableCar(\"art\\cars\\" .. RandomCarName .. ".p3d\",\"" .. RandomCarName .. "\",\"OTHER\");", 1)
		else
			-- Add a new command to the end to load the random vehicle
			NewFile = NewFile .. "\r\nLoadDisposableCar(\"art\\cars\\" .. RandomCarName .. ".p3d\", \"" .. RandomCarName .. "\", \"OTHER\");"
		end
		-- Debugging
		DebugPrint("Randomising car for mission (load) " ..  Lidx .. " -> " .. RandomCarName .. (ForcedMission and " (forced)" or ""))
	end
	if SettingRandomMissionVehicles then
		DebugPrint("Checking for sub level cars in " .. Lidx)
		if SettingSaveChoiceMV then
			if LastLevelMV == nil or LastLevelMV ~= Path then			
				MissionVehicles = {}
				local TmpCarPool = {table.unpack(RandomCarPoolMission)}
				if SettingDifferentCellouts and level == 2 and mission == 7 then
					NewFile = NewFile:gsub("cCellA", "cCellA1")
					NewFile = NewFile .. "LoadDisposableCar(\"art\\cars\\cCellA2.p3d\",\"cCellA2\",\"AI\");\r\n"
					NewFile = NewFile .. "LoadDisposableCar(\"art\\cars\\cCellA3.p3d\",\"cCellA3\",\"AI\");\r\n"
					NewFile = NewFile .. "LoadDisposableCar(\"art\\cars\\cCellA4.p3d\",\"cCellA4\",\"AI\");\r\n"
				end
				for orig in NewFile:gmatch("LoadP3DFile%s*%(%s*\"art\\cars\\(.-)%.p3d\"%s*%);") do
					local carName = GetRandomFromTbl(TmpCarPool, true)
					MissionVehicles[orig] = carName
					DebugPrint("Randomising " .. orig .. " to " .. carName)
				end
				for orig,var2,carType in NewFile:gmatch("LoadDisposableCar%s*%(%s*\"art\\cars\\(.-)%.p3d\"%s*,%s*\"(.-)\"%s*,%s*\"(.-)\"%s*%);") do
					if carType == "AI" then
						local carName = GetRandomFromTbl(TmpCarPool, true)
						MissionVehicles[orig] = carName
						DebugPrint("Randomising " .. orig .. " to " .. carName)
					end
				end
			elseif SettingDifferentCellouts and Path:match("level02\\m7l.mfk") then
				NewFile = NewFile:gsub("cCellA", "cCellA1")
				NewFile = NewFile .. "LoadDisposableCar(\"art\\cars\\cCellA2.p3d\",\"cCellA2\",\"AI\");\r\n"
				NewFile = NewFile .. "LoadDisposableCar(\"art\\cars\\cCellA3.p3d\",\"cCellA3\",\"AI\");\r\n"
				NewFile = NewFile .. "LoadDisposableCar(\"art\\cars\\cCellA4.p3d\",\"cCellA4\",\"AI\");\r\n"
			end
			LastLevelMV = Path
		else
			MissionVehicles = {}
			local TmpCarPool = {table.unpack(RandomCarPoolMission)}
			if Path:match("level02\\m7l.mfk") then
				NewFile = NewFile:gsub("cCellA", "cCellA1")
				NewFile = NewFile .. "LoadDisposableCar(\"art\\cars\\cCellA2.p3d\",\"cCellA2\",\"AI\");\r\n"
				NewFile = NewFile .. "LoadDisposableCar(\"art\\cars\\cCellA3.p3d\",\"cCellA3\",\"AI\");\r\n"
				NewFile = NewFile .. "LoadDisposableCar(\"art\\cars\\cCellA4.p3d\",\"cCellA4\",\"AI\");\r\n"
			end
			for orig in NewFile:gmatch("LoadP3DFile%s*%(%s*\"art\\cars\\(.-)%.p3d\"%s*%);") do
				local carName = GetRandomFromTbl(TmpCarPool, true)
				MissionVehicles[orig] = carName
				DebugPrint("Randomising " .. orig .. " to " .. carName)
			end
			for orig,var2,carType in NewFile:gmatch("LoadDisposableCar%s*%(%s*\"art\\cars\\(.-)%.p3d\"%s*,%s*\"(.-)\"%s*,%s*\"(.-)\"%s*%);") do
				if carType == "AI" then
					local carName = GetRandomFromTbl(TmpCarPool, true)
					MissionVehicles[orig] = carName
					DebugPrint("Randomising " .. orig .. " to " .. carName)
				end
			end
		end
		for k,v in pairs(MissionVehicles) do
			NewFile = NewFile:gsub("LoadP3DFile%s*%(%s*\"art\\cars\\" .. k .. "%.p3d\"%s*%);", "LoadP3DFile(\"art\\cars\\" .. v .. ".p3d\");")
			NewFile = NewFile:gsub("LoadDisposableCar%s*%(%s*\"art\\cars\\" .. k .."%.p3d\"%s*,%s*\"" .. k .. "\"%s*,%s*\"AI\"%s*%);", "LoadDisposableCar(\"art\\cars\\" .. v .. ".p3d\",\"" .. v .. "\",\"AI\");")
			NewFile = NewFile:gsub("LoadDisposableCar%s*%(%s*\"art\\cars\\" .. k .."%.p3d\"%s*,%s*\"cvan\"%s*,%s*\"AI\"%s*%);", "LoadDisposableCar(\"art\\cars\\" .. v .. ".p3d\",\"" .. v .. "\",\"AI\");")
		end
	end
	Output(NewFile)
elseif LevelLoad ~= nil then
	local level = Path:match("level0(%d)")
	DebugPrint("NEW LEVEL LOAD: Level " .. level)
	if SettingRandomPlayerVehicles then
		LastLevel = nil
		RandomCar = math.random(#RandomCarPoolPlayer)
		RandomCarName = RandomCarPoolPlayer[RandomCar]
		NewFile = NewFile:gsub("(.*)LoadDisposableCar%s*%(%s*\".-\"%s*,%s*\".-\"%s*,%s*\"DEFAULT\"%s*%);", "%1LoadDisposableCar(\"art\\cars\\" .. RandomCarName .. ".p3d\",\"" .. RandomCarName .. "\",\"DEFAULT\");", 1)
		DebugPrint("Randomising car for level (load) -> " .. RandomCarName)
	end
	if SettingRandomMissionVehicles then
		LastLevelMV = nil
	end
	if SettingRandomTraffic then
		TrafficCars = {}
		local TmpCarPool = {table.unpack(RandomCarPoolTraffic)}
		local Cars = ""
		for i = 1, 5 do
			local carName = GetRandomFromTbl(TmpCarPool, true)
			table.insert(TrafficCars, carName)
			Cars = Cars .. carName .. ", "
		end
		for i = 1, #TrafficCars do
			local carName = TrafficCars[i]
			NewFile = NewFile .. "\r\nLoadP3DFile(\"art\\cars\\" .. carName .. ".p3d\");"
		end
		NewFile = NewFile:gsub("SuppressDriver%s*%(\"(.-)\"%s*%);", "//SuppressDriver(\"%1\");")
		DebugPrint("Random traffic cars for level -> " .. Cars)
	end
	if SettingRandomChase then
		RandomChase = GetRandomFromTbl(RandomCarPoolChase, false)
		NewFile = NewFile .. "\r\nLoadP3DFile(\"art\\cars\\" .. RandomChase .. ".p3d\");"
		DebugPrint("Random chase cars for level -> " .. RandomChase)
	end
	if SettingRandomMissionVehicles then
		LastLevelMV = nil
	end
	Output(NewFile)
elseif LevelInit ~= nil then
	local level = Path:match("level0(%d)")
	DebugPrint("NEW LEVEL INIT: Level " .. level)
	if SettingRandomCharacter then
		OrigChar = NewFile:match("AddCharacter%s*%(%s*\"(.-)\"")
		--RandomChar = GetRandomFromTbl(RandomCharP3DPool, false)
	end
	if SettingRandomPlayerVehicles then
		NewFile = NewFile:gsub("InitLevelPlayerVehicle%s*%(%s*\".-\"%s*,%s*\"(.-)\"%s*,%s*\"DEFAULT\"%s*%)", "InitLevelPlayerVehicle(\"" .. RandomCarName .. "\",\"%1\",\"DEFAULT\")", 1)
		DebugPrint("Randomising car for level -> " .. RandomCarName)
	end
	if SettingRandomPedestrians then
		local Peds = ""
		local TmpPedPool = {table.unpack(RandomPedPool)}
		local groups = {}
		for group in NewFile:gmatch("CreatePedGroup%s*%(%s*(%d)%s*%);") do
			table.insert(groups, group)
		end
		local ret = ""
		for i = 1, #groups do
			local group = groups[i]
			DebugPrint("Randomising group " .. group)
			ret = ret .. "CreatePedGroup( " .. group .. " );\r\n"
			for i = 1, 7 do
				local pedName = GetRandomFromTbl(TmpPedPool, true)
				if not TmpPedPool or #TmpPedPool == 0 then
					TmpPedPool = {table.unpack(RandomPedPool)}
				end
				Peds = Peds .. pedName .. ", "
				ret = ret .. "AddPed(\"" .. pedName .. "\", 1);\r\n"
			end
			ret = ret .. "ClosePedGroup( );"
		end
		NewFile = NewFile:gsub("CreatePedGroup%s*%(%s*(%d)%s*%);(.*)ClosePedGroup%s*%(%s*%);", function(group, current)
			return ret
		end)
		LevelCharacters = {}
		for npc in NewFile:gmatch("AddAmbientCharacter%s*%(%s*\"(.-)\"") do
			table.insert(LevelCharacters, npc)
		end
		DebugPrint("Random pedestrians for level -> " .. Peds)
	end
	if SettingRandomMissionCharacters then
		BonusCharacters = {}
		for npc in NewFile:gmatch("AddNPCCharacterBonusMission%s*%(%s*\"(.-)\"") do
			table.insert(BonusCharacters, npc)
		end
	end
	if SettingRandomTraffic then
		RemovedTrafficCars = {}
		NewFile = NewFile:gsub("CreateTrafficGroup", "//CreateTrafficGroup", 1)
		NewFile = NewFile:gsub("AddTrafficModel%s*%(%s*\"(.-)\"", function(car)
			table.insert(RemovedTrafficCars, car)
			return "//AddTrafficModel(\"" .. car .. "\"" --( "minivanA"
		end)
		NewFile = NewFile:gsub("CloseTrafficGroup", "//CloseTrafficGroup", 1)
		NewFile = NewFile .. "\r\nCreateTrafficGroup( 0 );"
		for i = 1, #TrafficCars do
			local carName = TrafficCars[i]
			NewFile = NewFile .. "\r\nAddTrafficModel( \"" .. carName .. "\",1 );"
		end
		NewFile = NewFile .. "\r\nCloseTrafficGroup( );"
	end
	if SettingRandomChase then
		if SettingRandomChaseStats or SettingRandomStats then
			NewFile = NewFile:gsub("CreateChaseManager%s*%(%s*\".-\"%s*,%s*\".-\"", "CreateChaseManager(\"" .. RandomChase .."\",\"" .. RandomChase .. ".con\"", 1)
		else
			NewFile = NewFile:gsub("CreateChaseManager%s*%(%s*\".-\"", "CreateChaseManager(\"" .. RandomChase .."\"", 1)
		end
		if SettingRandomChaseAmount then
			NewFile = NewFile:gsub("SetNumChaseCars%s*%(%s*\".-\"", "SetNumChaseCars(\"" .. math.random(1, 4) .."\"", 1)
		end
	end
	Output(NewFile)
elseif SDInit ~= nil then
	local level = Path:match("level0(%d)")
	local mission = Path:match("m(%d)sdi")
	DebugPrint("NEW SUNDAY DRIVE INIT: Level " .. level .. ", Mission " .. mission)
	if SettingRandomMissionCharacters then
		MissionCharacters = {}
		for npc in NewFile:gmatch("AddNPC%s*%(%s*\"(.-)\"") do
			table.insert(MissionCharacters, npc)
		end
	end
	if SettingSkipLocks then
		if NewFile:match("locked") then
			NewFile = NewFile:gsub("AddStage%s*%(\"locked\".-%s*%);(.-)CloseStage%s*%(%s*%);%s*AddStage%s*%(.-%s*%);.-CloseStage%s*%(%s*%);", "AddStage();%1CloseStage();", 1);
		end
	end
	if SettingSkipFMVs then
		NewFile = NewFile:gsub("AddObjective%s*%(\"fmv\"%s*%);.-CloseObjective%s*%(%s*%);", "AddObjective(\"timer\");\r\nSetDurationTime(1);\r\nCloseObjective();", 1)
	end
	Output(NewFile)
elseif SDLoad ~= nil then
	local level = Path:match("level0(%d)")
	local mission = Path:match("m(%d)sdl")
	DebugPrint("NEW SUNDAY DRIVE LOAD: Level " .. level .. ", Mission " .. mission)
	if SettingRandomMissionVehicles then
		LastLevelMV = nil
	end
else
	LastLevel = nil
end
