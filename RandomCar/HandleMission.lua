-- Load the file
local Path = "/GameData/" .. GetPath();
local File = ReadFile(Path);

-- Determine if the file is for a mission (bonus, main or races)
local Midx = string.match(Path, "b?m%di.mfk") or string.match(Path, "[gs]r%di.mfk")
local Lidx = string.match(Path, "b?m%dl.mfk") or string.match(Path, "[gs]r%dl.mfk")
-- Determine if the file is for a level
local LevelLoad = string.match(Path, "level.mfk")
local LevelInit = string.match(Path, "leveli.mfk")
-- Determine if the file is for "sunday drive" (pre-mission)
local SDLoad = string.match(Path, "m%dsdl.mfk")
local SDInit = string.match(Path, "m%dsdi.mfk")

-- Remove comments because there's A LOT of commented out stuff that can confuse the simple regexes below
local NewFile = string.gsub(File, "//.-\n", "")	

if Midx ~= nil then
	-- The random car should have been predecided by the mission load script
	
	if GetSetting("RandomPlayerVehicles") then
		local ForcedMission = false
		local Spawn, Match
		-- Try to find a forced vehicle spawn
		Match = string.match(NewFile, "InitLevelPlayerVehicle%(%s*\".-\"%s*,%s*\".-\"%s*,%s*\"OTHER\"%s*%)")
		if Match ~= nil then
			ForcedMission = true
			-- Replace it with the random vehicle
			NewFile = string.gsub(NewFile, "InitLevelPlayerVehicle%(%s*\".-\"%s*,%s*\"(.-)\"%s*,%s*\"OTHER\"%s*%)", "InitLevelPlayerVehicle(\"" .. RandomCarName .. "\",\"%1\",\"OTHER\")", 1)
		else
			-- Try to find the spawn point
			Match, Spawn = string.match(NewFile, "SetMissionResetPlayerOutCar%(%s*\"(.-)\"%s*,%s*\"(.-)\"%s*%);")
			if Match == nil then
				Spawn = string.match(NewFile, "SetMissionResetPlayerInCar%(%s*\"(.-)\"%s*%);")
			end
			if Spawn ~= nil then
				NewFile = string.gsub(NewFile,"(SetDynaLoadData%(.-%);%s*\n)", "%1InitLevelPlayerVehicle(\"" .. RandomCarName .. "\", \"" .. Spawn .. "\", \"OTHER\");\nSetForcedCar();\n", 1)
				-- Because we create a "forced vehicle", delete stages before the reset as it automatically respawns you to the reset point anyway
				-- (So objectives like "leave office" or "head to car" don't work)
				-- Also look if we delete a stage which adds a vehicle, then replicate that. (TODO: Is this all?)
				
				-- Take a substring because we don't care about anything after RESET_TO_HERE (which appears once) and if we don't then
				-- Wolves takes AGES to (fail to) match the regex below. 
				ResetIndex = string.find(NewFile,"RESET_TO_HERE%(%)")
				EarlySubstring = string.sub(NewFile, 1, ResetIndex+15)			
				Match = string.match(EarlySubstring, "AddStage%(.-%);.*(AddStageVehicle%(.-%);).*AddStage%(.-%);%s*\n%s*RESET_TO_HERE%(%);")
				FakeStage = ""
				if Match ~= nil then
					FakeStage = "AddStage();\n" .. Match .. "\nAddObjective(\"timer\");\nSetDurationTime(1);\nCloseObjective();\nCloseStage();\n"
					print("Creating a fake add vehicle stage")
				end
				NewFile = string.gsub(NewFile, "\nAddStage%(.-%);.*AddStage%((.-)%);%s*\n%s*RESET_TO_HERE%(%);", "\n" .. FakeStage .. "AddStage(%1);\nRESET_TO_HERE();", 1)
				print("Deleting an early stage")
			end
		end
		-- Debugging
		print("Randomising car for mission " ..  Midx .. " -> " .. RandomCarName .. (ForcedMission and " (forced)" or ""))
	end
	Output(NewFile)
elseif Lidx ~= nil then
	if GetSetting("RandomPlayerVehicles") then
		if GetSetting("SaveChoice") then
			if LastLevel ~= Path then
				RandomCar = math.random(RandomCarPoolN)
			end
			LastLevel = Path
		else
			RandomCar = math.random(RandomCarPoolN)
		end
		RandomCarName = RandomCarPool[RandomCar]

		local ForcedMission = false
		local Match
		
		-- Try to find a forced vehicle spawn
		Match = string.match(NewFile, "LoadDisposableCar%(%s*\".-\"%s*,%s*\".-\"%s*,%s*\"OTHER\"%s*%)")
		if Match ~= nil then
			ForcedMission = true
			-- Replace it with the random vehicle
			-- The (.*) at the start is weird but tries to capture as much outside the LoadDisposableCar function
			-- Otherwise if an AI LoadDisposableCar appears first the .- captures two LoadDisposableCar calls,
			-- So one of the LoadDisposableCar calls gets deleted, and the game crashes because something isn't loaded
			-- There's probably a smarter way than this...?
			NewFile = string.gsub(NewFile, "(.*)LoadDisposableCar%(%s*\".-\"%s*,%s*\".-\"%s*,%s*\"OTHER\"%s*%);", "%1LoadDisposableCar(\"art\\cars\\" .. RandomCarName .. ".p3d\",\"" .. RandomCarName .. "\",\"OTHER\");", 1)
		else
			-- Add a new command to the end to load the random vehicle
			NewFile = NewFile .. "\nLoadDisposableCar(\"art\\cars\\" .. RandomCarName .. ".p3d\", \"" .. RandomCarName .. "\", \"OTHER\");"
		end
		-- Debugging
		print("Randomising car for mission (load) " ..  Lidx .. " -> " .. RandomCarName .. (ForcedMission and " (forced)" or ""))
	end
	if GetSetting("SkipFMVs") then
		NewFile = string.gsub(NewFile, "AddObjective%(\"fmv\"%);.-CloseObjective%(%);", "AddObjective(\"timer\");\nSetDurationTime(1);\nCloseObjective();", 1)
	end
	Output(NewFile)
elseif LevelLoad ~= nil then
	if GetSetting("RandomPlayerVehicles") then
		LastLevel = nil
		RandomCar = math.random(RandomCarPoolN)
		RandomCarName = RandomCarPool[RandomCar]
		NewFile = string.gsub(NewFile, "(.*)LoadDisposableCar%(%s*\".-\"%s*,%s*\".-\"%s*,%s*\"DEFAULT\"%s*%);", "%1LoadDisposableCar(\"art\\cars\\" .. RandomCarName .. ".p3d\",\"" .. RandomCarName .. "\",\"DEFAULT\");", 1)
		print("Randomising car for level (load) -> " .. RandomCarName)
	end
	Output(NewFile)
elseif LevelInit ~= nil then
	if GetSetting("RandomPlayerVehicles") then
		NewFile = string.gsub(NewFile, "InitLevelPlayerVehicle%(%s*\".-\"%s*,%s*\"(.-)\"%s*,%s*\"DEFAULT\"%s*%)", "InitLevelPlayerVehicle(\"" .. RandomCarName .. "\",\"%1\",\"DEFAULT\")", 1)
		print("Randomising car for level -> " .. RandomCarName)
	end
	Output(NewFile)
elseif SDInit ~= nil then
	if GetSetting("SkipLocks") then
		if string.match(NewFile, "locked") then
			NewFile = string.gsub(NewFile, "AddStage%(\"locked\".-%);(.-)CloseStage%(%);%s*AddStage%(.-%);.-CloseStage%(%);", "AddStage();%1CloseStage();", 1);
		end
	end
	if GetSetting("SkipFMVs") then
		NewFile = string.gsub(NewFile, "AddObjective%(\"fmv\"%);.-CloseObjective%(%);", "AddObjective(\"timer\");\nSetDurationTime(1);\nCloseObjective();", 1)
	end
	Output(NewFile)
else
	LastLevel = nil
	-- Don't modify other scripts
	--print("Script " .. Path)
	Output(NewFile);
end
