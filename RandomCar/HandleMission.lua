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
local NewFile = string.gsub(File, "//.-\r\n", "\r\n")

if Midx ~= nil then
	if GetSetting("RandomCharacter") then
		NewFile = string.gsub(NewFile, "AddObjective%(%s*\"dialogue\"%s*%);(.-)CloseObjective%(%s*%);",  function(orig)
			local art = ""
			if string.match(orig, "SetPresentationBitmap%(") then
				for line in string.gmatch(orig, "SetPresentationBitmap%(%s*(.-)%s*%);") do
					art = "SetPresentationBitmap(" .. line .. ");\r\n"
				end
			end
			return "AddObjective(\"timer\");\r\n" .. art .. "SetDurationTime(0);\r\nCloseObjective();"
		end)
		NewFile = string.gsub(NewFile, "AddStageCharacter%(%s*\"" .. OrigChar .. "\"", "AddStageCharacter(\"" .. RandomChar .. "\"")
	end
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
				NewFile = string.gsub(NewFile,"(SetDynaLoadData%(.-%);%s*\r\n)", "%1InitLevelPlayerVehicle(\"" .. RandomCarName .. "\", \"" .. Spawn .. "\", \"OTHER\");\r\nSetForcedCar();\r\n", 1)
				-- Because we create a "forced vehicle", delete stages before the reset as it automatically respawns you to the reset point anyway
				-- (So objectives like "leave office" or "head to car" don't work)
				-- Also look if we delete a stage which adds a vehicle, then replicate that. (TODO: Is this all?)
				
				-- Take a substring because we don't care about anything after RESET_TO_HERE (which appears once) and if we don't then
				-- Wolves takes AGES to (fail to) match the regex below. 
				ResetIndex = string.find(NewFile,"RESET_TO_HERE%(%)")
				if ResetIndex then
					EarlySubstring = string.sub(NewFile, 1, ResetIndex+15)			
					Match = string.match(EarlySubstring, "AddStage%(.-%);.*(AddStageVehicle%(.-%);).*AddStage%(.-%);%s*\r\n%s*RESET_TO_HERE%(%);")
					FakeStage = ""
					if Match ~= nil then
						FakeStage = "AddStage();\r\n" .. Match .. "\r\nAddObjective(\"timer\");\r\nSetDurationTime(1);\r\nCloseObjective();\r\nCloseStage();\r\n"
						print("Creating a fake add vehicle stage")
					end
					NewFile = string.gsub(NewFile, "\r\nAddStage%(.-%);.*AddStage%((.-)%);%s*\r\n%s*RESET_TO_HERE%(%);", "\r\n" .. FakeStage .. "AddStage(%1);\r\nRESET_TO_HERE();", 1)
					print("Deleting an early stage")
				end
			end
		end
		-- Debugging
		print("Randomising car for mission " ..  Midx .. " -> " .. RandomCarName .. (ForcedMission and " (forced)" or ""))
	end
	if GetSetting("SkipFMVs") then
		NewFile = string.gsub(NewFile, "AddObjective%(\"fmv\"%);.-CloseObjective%(%);", "AddObjective(\"timer\");\r\nSetDurationTime(1);\r\nCloseObjective();", 1)
	end
	if GetSetting("RandomChase") then
		NewFile = string.gsub(NewFile, "\"cPolice\"", "\"" .. RandomChase .. "\"")
		NewFile = string.gsub(NewFile, "\"cHears\"", "\"" .. RandomChase .. "\"")
	end
	if GetSetting("RandomMissionVehicles") then
		if GetSetting("DifferentCellouts") and string.match(Path, "level02\\m7i.mfk") then
			NewFile = string.gsub(NewFile, "AddStageVehicle%(\"cCellA\",\"m7_cellstart(%d)", "AddStageVehicle(\"cCellA%1\",\"m7_cellstart%1")
			NewFile = string.gsub(NewFile, "ActivateVehicle%(\"cCellA\"(.-)\r\n", "ActivateVehicle(\"cCellA1\"%1\r\nSetHitNRun();\r\n")
			local i = 0
			NewFile = string.gsub(NewFile, "SetVehicleAIParams%(%s*\"cCellA\"", function()
				i = i + 1
				return "SetHitNRun();\r\n\tSetVehicleAIParams( \"cCellA" .. i .. "\""
			end)
			i = 0
			NewFile = string.gsub(NewFile, "SetObjTargetVehicle%(\"cCellA\"", function()
				i = i + 1
				return "SetObjTargetVehicle(\"cCellA" .. i .. "\""
			end)
			i = 1
			NewFile = string.gsub(NewFile, "AddStageVehicle%(\"cCellA\"", function()
				i = i + 1
				return "AddStageVehicle(\"cCellA" .. i .. "\""
			end)
		end
		for k,v in pairs(MissionVehicles) do
			print("Replacing " .. k .. " with " .. v)
			if GetSetting("RandomMissionVehiclesStats") or GetSetting("RandomStats") then
				NewFile = string.gsub(NewFile, "AddStageVehicle%(%s*\"" .. k .. "\"%s*,%s*\"(.-)\"%s*,%s*\"(.-)\"%s*,%s*\".-\"", "AddStageVehicle(\"" .. v .. "\",\"%1\",\"%2\",\"" .. v .. ".con\"")
			else
				NewFile = string.gsub(NewFile, "AddStageVehicle%(%s*\"" .. k .. "\"", "AddStageVehicle(\"" .. v .. "\"")
			end
			NewFile = string.gsub(NewFile, "ActivateVehicle%(%s*\"" .. k .. "\"", "ActivateVehicle(\"" .. v .. "\"")
			NewFile = string.gsub(NewFile, "SetVehicleAIParams%(%s*\"" .. k .. "\"", "SetVehicleAIParams(\"" .. v .. "\"")
			NewFile = string.gsub(NewFile, "SetStageAIRaceCatchupParams%(%s*\"" .. k .. "\"", "SetStageAIRaceCatchupParams(\"" .. v .. "\"")
			NewFile = string.gsub(NewFile, "SetStageAITargetCatchupParams%(%s*\"" .. k .. "\"", "SetStageAITargetCatchupParams(\"" .. v .. "\"")
			NewFile = string.gsub(NewFile, "SetCondTargetVehicle%(%s*\"" .. k .. "\"", "SetCondTargetVehicle(\"" .. v .. "\"")
			NewFile = string.gsub(NewFile, "SetObjTargetVehicle%(%s*\"" .. k .. "\"", "SetObjTargetVehicle(\"" .. v .. "\"")
			NewFile = string.gsub(NewFile, "AddDriver%(%s*\"(.-)\"%s*,%s*\"" .. k .. "\"", "AddDriver(\"%1\",\"" .. v .. "\"")
		end
		local TmpDriverPool = {}
		for k in pairs(CarDrivers) do
			table.insert(TmpDriverPool, k)
		end
		NewFile = string.gsub(NewFile, "AddStageVehicle%(%s*\"(.-)\"%s*,%s*\"(.-)\"%s*,%s*\"(.-)\"%s*,%s*\"(.-)\"%s*,%s*\"(.-)\"%s*%);", function(car, position, action, config, orig)
			local driver = math.random(#TmpDriverPool)
			local driverName = TmpDriverPool[driver]
			table.remove(TmpDriverPool, driver)
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
			NewFile = NewFile .. "\r\nLoadDisposableCar(\"art\\cars\\" .. RandomCarName .. ".p3d\", \"" .. RandomCarName .. "\", \"OTHER\");"
		end
		-- Debugging
		print("Randomising car for mission (load) " ..  Lidx .. " -> " .. RandomCarName .. (ForcedMission and " (forced)" or ""))
	end
	if GetSetting("RandomMissionVehicles") then
		print("Checking for sub level cars in " .. Lidx)
		if GetSetting("SaveChoiceMV") then
			if LastLevelMV == nil or LastLevelMV ~= Path then			
				MissionVehicles = {}
				local TmpCarPool = {table.unpack(RandomCarPool)}
				if not GetSetting("NoHusk") then
					table.remove(TmpCarPool, #TmpCarPool)
				end
				if GetSetting("DifferentCellouts") and string.match(Path, "level02\\m7l.mfk") then
					NewFile = string.gsub(NewFile, "cCellA", "cCellA1")
					NewFile = NewFile .. "LoadDisposableCar(\"art\\cars\\cCellA2.p3d\",\"cCellA2\",\"AI\");\r\n"
					NewFile = NewFile .. "LoadDisposableCar(\"art\\cars\\cCellA3.p3d\",\"cCellA3\",\"AI\");\r\n"
					NewFile = NewFile .. "LoadDisposableCar(\"art\\cars\\cCellA4.p3d\",\"cCellA4\",\"AI\");\r\n"
				end
				for orig in string.gmatch(NewFile, "LoadP3DFile%(%s*\"art\\cars\\(.-)%.p3d\"%s*%);") do
					local car = math.random(#TmpCarPool)
					local carName = TmpCarPool[car]
					table.remove(TmpCarPool, car)
					MissionVehicles[orig] = carName
					print("Randomising " .. orig .. " to " .. carName)
				end
				for orig,var2,carType in string.gmatch(NewFile, "LoadDisposableCar%(%s*\"art\\cars\\(.-)%.p3d\"%s*,%s*\"(.-)\"%s*,%s*\"(.-)\"%s*%);") do
					if carType == "AI" then
						local car = math.random(#TmpCarPool)
						local carName = TmpCarPool[car]
						table.remove(TmpCarPool, car)
						MissionVehicles[orig] = carName
						print("Randomising " .. orig .. " to " .. carName)
					end
				end
			end
			LastLevelMV = Path
		else
			MissionVehicles = {}
			local TmpCarPool = {table.unpack(RandomCarPool)}
			if not GetSetting("NoHusk") then
				table.remove(TmpCarPool, #TmpCarPool)
			end
			if string.match(Path, "level02\\m7l.mfk") then
				NewFile = string.gsub(NewFile, "cCellA", "cCellA1")
				NewFile = NewFile .. "LoadDisposableCar(\"art\\cars\\cCellA2.p3d\",\"cCellA2\",\"AI\");\r\n"
				NewFile = NewFile .. "LoadDisposableCar(\"art\\cars\\cCellA3.p3d\",\"cCellA3\",\"AI\");\r\n"
				NewFile = NewFile .. "LoadDisposableCar(\"art\\cars\\cCellA4.p3d\",\"cCellA4\",\"AI\");\r\n"
			end
			for orig in string.gmatch(NewFile, "LoadP3DFile%(%s*\"art\\cars\\(.-)%.p3d\"%s*%);") do
				local car = math.random(#TmpCarPool)
				local carName = TmpCarPool[car]
				table.remove(TmpCarPool, car)
				MissionVehicles[orig] = carName
				print("Randomising " .. orig .. " to " .. carName)
			end
			for orig,var2,carType in string.gmatch(NewFile, "LoadDisposableCar%(%s*\"art\\cars\\(.-)%.p3d\"%s*,%s*\"(.-)\"%s*,%s*\"(.-)\"%s*%);") do
				if carType == "AI" then
					local car = math.random(#TmpCarPool)
					local carName = TmpCarPool[car]
					table.remove(TmpCarPool, car)
					MissionVehicles[orig] = carName
					print("Randomising " .. orig .. " to " .. carName)
				end
			end
		end
		for k,v in pairs(MissionVehicles) do
			NewFile = string.gsub(NewFile, "LoadP3DFile%(%s*\"art\\cars\\" .. k .. "%.p3d\"%s*%);", "LoadP3DFile(\"art\\cars\\" .. v .. ".p3d\");")
			NewFile = string.gsub(NewFile, "LoadDisposableCar%(%s*\"art\\cars\\" .. k .."%.p3d\"%s*,%s*\"" .. k .. "\"%s*,%s*\"AI\"%s*%);", "LoadDisposableCar(\"art\\cars\\" .. v .. ".p3d\",\"" .. v .. "\",\"AI\");")
			NewFile = string.gsub(NewFile, "LoadDisposableCar%(%s*\"art\\cars\\" .. k .."%.p3d\"%s*,%s*\"cvan\"%s*,%s*\"AI\"%s*%);", "LoadDisposableCar(\"art\\cars\\" .. v .. ".p3d\",\"" .. v .. "\",\"AI\");")
		end
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
	if GetSetting("RandomMissionVehicles") then
		LastLevelMV = nil
	end
	if GetSetting("RandomTraffic") then
		TrafficCars = {}
		local TmpCarPool = {table.unpack(RandomCarPool)}
		if not GetSetting("NoHusk") then
			table.remove(TmpCarPool, #TmpCarPool)
		end
		local Cars = ""
		for i = 1, 5 do
			local car = math.random(#TmpCarPool)
			local carName = TmpCarPool[car]
			table.remove(TmpCarPool, car)
			table.insert(TrafficCars, carName)
			Cars = Cars .. carName .. ", "
		end
		for i = 1, #TrafficCars do
			local carName = TrafficCars[i]
			NewFile = NewFile .. "\r\nLoadP3DFile(\"art\\cars\\" .. carName .. ".p3d\");"
		end
		NewFile = string.gsub(NewFile, "SuppressDriver%(\"(.-)\"%);", "//SuppressDriver(\"%1\");")
		print("Random traffic cars for level -> " .. Cars)
	end
	if GetSetting("RandomChase") then
		local chaseCar = math.random(#RandomCarPool)
		RandomChase = RandomCarPool[chaseCar]
		NewFile = NewFile .. "\r\nLoadP3DFile(\"art\\cars\\" .. RandomChase .. ".p3d\");"
		print("Random chase cars for level -> " .. RandomChase)
	end
	if GetSetting("RandomMissionVehicles") then
		LastLevelMV = nil
	end
	Output(NewFile)
elseif LevelInit ~= nil then
	if GetSetting("RandomCharacter") then
		NewFile = string.gsub(NewFile, "AddCharacter%(%s*\"(.-)\"%s*,%s*\".-\"%s*%);", function(orig)
			OrigChar = orig
			local TmpCharPool = {table.unpack(RandomCharPool)}
			if string.match(Path, "level01") then
				for i=#TmpCharPool,1,-1 do
					for j=1,#LevelOneBlock do
						if TmpCharPool[i] == LevelOneBlock[j] then
							table.remove(TmpCharPool, i)
							break
						end
					end
				end
			elseif string.match(Path, "level02") then
				for i=#TmpCharPool,1,-1 do
					for j=1,#LevelTwoBlock do
						if TmpCharPool[i] == LevelTwoBlock[j] then
							table.remove(TmpCharPool, i)
							break
						end
					end
				end
			elseif string.match(Path, "level03") then
				for i=#TmpCharPool,1,-1 do
					for j=1,#LevelThreeBlock do
						if TmpCharPool[i] == LevelThreeBlock[j] then
							table.remove(TmpCharPool, i)
							break
						end
					end
				end
			elseif string.match(Path, "level04") then
				for i=#TmpCharPool,1,-1 do
					for j=1,#LevelFourBlock do
						if TmpCharPool[i] == LevelFourBlock[j] then
							table.remove(TmpCharPool, i)
							break
						end
					end
				end
			elseif string.match(Path, "level05") then
				for i=#TmpCharPool,1,-1 do
					for j=1,#LevelFiveBlock do
						if TmpCharPool[i] == LevelFiveBlock[j] then
							table.remove(TmpCharPool, i)
							break
						end
					end
				end
			elseif string.match(Path, "level06") then
				for i=#TmpCharPool,1,-1 do
					for j=1,#LevelSixBlock do
						if TmpCharPool[i] == LevelSixBlock[j] then
							table.remove(TmpCharPool, i)
							break
						end
					end
				end
			elseif string.match(Path, "level07") then
				for i=#TmpCharPool,1,-1 do
					for j=1,#LevelSevenBlock do
						if TmpCharPool[i] == LevelSevenBlock[j] then
							table.remove(TmpCharPool, i)
							break
						end
					end
				end
			end
			RandomChar = TmpCharPool[math.random(#TmpCharPool)]
			return "AddCharacter(\"" .. RandomChar .. "\",\"" .. orig .. "\");"
		end)
	end
	if GetSetting("RandomPlayerVehicles") then
		NewFile = string.gsub(NewFile, "InitLevelPlayerVehicle%(%s*\".-\"%s*,%s*\"(.-)\"%s*,%s*\"DEFAULT\"%s*%)", "InitLevelPlayerVehicle(\"" .. RandomCarName .. "\",\"%1\",\"DEFAULT\")", 1)
		print("Randomising car for level -> " .. RandomCarName)
	end
	if GetSetting("RandomPedestrians") then
		local Peds = ""
		local TmpPedPool = {table.unpack(RandomPedPool)}
		local groups = {}
		for group in string.gmatch(NewFile, "CreatePedGroup%(%s*(%d)%s*%);") do
			table.insert(groups, group)
		end
		local ret = ""
		for i = 1, #groups do
			local group = groups[i]
			print("Randomising group " .. group)
			ret = ret .. "CreatePedGroup( " .. group .. " );\r\n"
			for i = 1, 7 do
				local ped = math.random(#TmpPedPool)
				local pedName = TmpPedPool[ped]
				table.remove(TmpPedPool, ped)
				if not TmpPedPool or #TmpPedPool == 0 then
					TmpPedPool = {table.unpack(RandomPedPool)}
				end
				Peds = Peds .. pedName .. ", "
				ret = ret .. "AddPed(\"" .. pedName .. "\", 1);\r\n"
			end
			ret = ret .. "ClosePedGroup( );"
		end
		NewFile = string.gsub(NewFile, "CreatePedGroup%(%s*(%d)%s*%);(.*)ClosePedGroup%(%s*%);", function(group, current)
			return ret
		end)
		print("Random pedestrians for level -> " .. Peds)
	end
	if GetSetting("RandomTraffic") then
		NewFile = string.gsub(NewFile, "CreateTrafficGroup", "//CreateTrafficGroup", 1)
		NewFile = string.gsub(NewFile, "AddTrafficModel", "//AddTrafficModel")
		NewFile = string.gsub(NewFile, "CloseTrafficGroup", "//CloseTrafficGroup", 1)
		NewFile = NewFile .. "\r\nCreateTrafficGroup( 0 );"
		for i = 1, #TrafficCars do
			local carName = TrafficCars[i]
			NewFile = NewFile .. "\r\nAddTrafficModel( \"" .. carName .. "\",1 );"
		end
		NewFile = NewFile .. "\r\nCloseTrafficGroup( );"
	end
	if GetSetting("RandomChase") then
		if GetSetting("RandomChaseStats") or GetSetting("RandomStats") then
			NewFile = string.gsub(NewFile, "CreateChaseManager%(%s*\".-\"%s*,%s*\".-\"", "CreateChaseManager(\"" .. RandomChase .."\",\"" .. RandomChase .. ".con\"", 1)
		else
			NewFile = string.gsub(NewFile, "CreateChaseManager%(%s*\".-\"", "CreateChaseManager(\"" .. RandomChase .."\"", 1)
		end
		if GetSetting("RandomChaseAmount") then
			NewFile = string.gsub(NewFile, "SetNumChaseCars%(%s*\".-\"", "SetNumChaseCars(\"" .. math.random(1, 4) .."\"", 1)
		end
	end
	Output(NewFile)
elseif SDInit ~= nil then
	if GetSetting("SkipLocks") then
		if string.match(NewFile, "locked") then
			NewFile = string.gsub(NewFile, "AddStage%(\"locked\".-%);(.-)CloseStage%(%);%s*AddStage%(.-%);.-CloseStage%(%);", "AddStage();%1CloseStage();", 1);
		end
	end
	if GetSetting("SkipFMVs") then
		NewFile = string.gsub(NewFile, "AddObjective%(\"fmv\"%);.-CloseObjective%(%);", "AddObjective(\"timer\");\r\nSetDurationTime(1);\r\nCloseObjective();", 1)
	end
	if GetSetting("RandomCharacter") then
		NewFile = string.gsub(NewFile, "AddObjective%(%s*\"dialogue\"%s*%);(.-)CloseObjective%(%s*%);",  function(orig)
			local art = ""
			if string.match(orig, "SetPresentationBitmap%(") then
				for line in string.gmatch(orig, "SetPresentationBitmap%(%s*(.-)%s*%);") do
					art = "SetPresentationBitmap(" .. line .. ");\r\n"
				end
			end
			return "AddObjective(\"timer\");\r\n" .. art .. "SetDurationTime(0);\r\nCloseObjective();"
		end)
		NewFile = string.gsub(NewFile, "AddStageCharacter%(%s*\"" .. OrigChar .. "\"", "AddStageCharacter(\"" .. RandomChar .. "\"")
	end
	Output(NewFile)
elseif SDLoad ~= nil then
	if GetSetting("RandomMissionVehicles") then
		LastLevelMV = nil
	end
else
	LastLevel = nil
end
