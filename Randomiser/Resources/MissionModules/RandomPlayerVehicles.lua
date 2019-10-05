local args = {...}
local tbl = args[1]
if Settings.RandomPlayerVehicles then
	local sort = 4
	Level = {}
	Mission = {}
	if not tbl.Level[sort] then
		tbl.Level[sort] = Level
	else
		Level = tbl.Level[sort]
	end
	if not tbl.Mission[sort] then
		tbl.Mission[sort] = Mission
	else
		Mission = tbl.Mission[sort]
	end
	
	function Level.RandomPlayerVehicles(LoadFile, InitFile, Level, Path)
		LastLevel = nil
		RandomCar = math.random(#RandomCarPoolPlayer)
		RandomCarName = RandomCarPoolPlayer[RandomCar]
		LoadFile = LoadFile:gsub("LoadDisposableCar%s*%(%s*\"[^\n]-\"%s*,%s*\".-\"%s*,%s*\"DEFAULT\"%s*%);", "LoadDisposableCar(\"art\\cars\\" .. RandomCarName .. ".p3d\",\"" .. RandomCarName .. "\",\"DEFAULT\");", 1)
		DebugPrint("Randomising car for level (load) -> " .. RandomCarName)
		
		InitFile = InitFile:gsub("InitLevelPlayerVehicle%s*%(%s*\"[^\n]-\"%s*,%s*\"([^\n]-)\"%s*,%s*\"DEFAULT\"%s*%)", "InitLevelPlayerVehicle(\"" .. RandomCarName .. "\",\"%1\",\"DEFAULT\")", 1)
		DebugPrint("Randomising car for level -> " .. RandomCarName)
		return LoadFile, InitFile
	end
	
	function Mission.RandomPlayerVehicles(LoadFile, InitFile, Level, Mission, Path)
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
		Match = LoadFile:match("LoadDisposableCar%s*%(%s*\"[^\n]-\"%s*,%s*\"[^\n]- \"%s*,%s*\"OTHER\"%s*%)")
		if Match ~= nil then
			ForcedMission = true
			LoadFile = LoadFile:gsub("LoadDisposableCar%s*%(%s*\"[^\n]-\"%s*,%s*\"[^\n]-\"%s*,%s*\"OTHER\"%s*%);", "LoadDisposableCar(\"art\\cars\\" .. RandomCarName .. ".p3d\",\"" .. RandomCarName .. "\",\"OTHER\");", 1)
		else
			-- Add a new command to the end to load the random vehicle
			LoadFile = LoadFile .. "\r\nLoadDisposableCar(\"art\\cars\\" .. RandomCarName .. ".p3d\", \"" .. RandomCarName .. "\", \"OTHER\");"
		end
		-- Debugging
		DebugPrint("Randomising car for mission (load) " ..  Level .. "|" .. Mission .. " -> " .. RandomCarName .. (ForcedMission and " (forced)" or ""))
		
		ForcedMission = false
		local Spawn
		-- Try to find a forced vehicle spawn
		Match = InitFile:match("InitLevelPlayerVehicle%s*%(%s*\".-\"%s*,%s*\".-\"%s*,%s*\"OTHER\"%s*%)")
		if Match ~= nil then
			ForcedMission = true
			-- Replace it with the random vehicle
			InitFile = InitFile:gsub("InitLevelPlayerVehicle%s*%(%s*\".-\"%s*,%s*\"([^\n]-)\"%s*,%s*\"OTHER\"%s*%)", "InitLevelPlayerVehicle(\"" .. RandomCarName .. "\",\"%1\",\"OTHER\")", 1)
		else
			-- Try to find the spawn point
			Match, Spawn = InitFile:match("SetMissionResetPlayerOutCar%s*%(%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*%);")
			if Match == nil then
				Spawn = InitFile:match("SetMissionResetPlayerInCar%s*%(%s*\"([^\n]-)\"%s*%);")
			end
			if Spawn ~= nil then
				InitFile = InitFile:gsub("(SetDynaLoadData%s*%(.-%s*%);%s*\r\n)", "%1InitLevelPlayerVehicle(\"" .. RandomCarName .. "\", \"" .. Spawn .. "\", \"OTHER\");\r\nSetForcedCar();\r\n", 1)
				-- Because we create a "forced vehicle", delete stages before the reset as it automatically respawns you to the reset point anyway
				-- (So objectives like "leave office" or "head to car" don't work)
				-- Also look if we delete a stage which adds a vehicle, then replicate that. (TODO: Is this all?)
				
				-- Take a substring because we don't care about anything after RESET_TO_HERE (which appears once) and if we don't then
				-- Wolves takes AGES to (fail to) match the regex below. 
				local ResetIndex = InitFile:find("RESET_TO_HERE%s*%(%s*%)")
				if ResetIndex then
					EarlySubstring = InitFile:sub(1, ResetIndex+15)			
					Match = EarlySubstring:match("AddStage%s*%(.-%s*%);.*(AddStageVehicle%s*%(.-%s*%);).*AddStage%s*%(.-%s*%);%s*\r\n%s*RESET_TO_HERE%s*%(%s*%);")
					FakeStage = ""
					if Match ~= nil then
						FakeStage = "AddStage();\r\n" .. Match .. "\r\nAddObjective(\"timer\");\r\nSetDurationTime(0);\r\nCloseObjective();\r\nCloseStage();\r\n"
						DebugPrint("Creating a fake add vehicle stage")
					end
					InitFile = InitFile:gsub("\r\nAddStage%s*%(.-%s*%);.*AddStage%s*%((.-)%s*%);%s*\r\n%s*RESET_TO_HERE%s*%(%s*%);", "\r\n" .. FakeStage .. "AddStage(%1);\r\nRESET_TO_HERE();", 1)
					DebugPrint("Deleting an early stage")
				end
			end
		end
		-- Debugging
		DebugPrint("Randomising car for mission " ..  Level .. "|" .. Mission .. " -> " .. RandomCarName .. (ForcedMission and " (forced)" or ""))
		
		if Settings.RemoveOutOfCar then
			DebugPrint("Removing outofvehicle")
			InitFile = InitFile:gsub("AddCondition%s*%(%s*\"outofvehicle\"%s*%);.-CloseCondition%s*%(%s*%);", "")
			DebugPrint("Removing damage")
			InitFile = InitFile:gsub("AddCondition%s*%(%s*\"damage\"%s*%);.-CloseCondition%s*%(%s*%);", function(condition)
				if condition:match("SetCondTargetVehicle%s*%(%s*\"" .. RandomCarName .. "\"%s*%);") then -- or condition:match("SetCondTargetVehicle%s*%(%s*\"current\"%s*%);") then
					return ""
				end
			end)
		end
		
		return LoadFile, InitFile
	end
end