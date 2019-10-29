local args = {...}
local tbl = args[1]
if Settings.RandomLevelMissions then
	local sort = 1
	local Level = {}
	local Mission = {}
	local SundayDrive = {}
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
	if not tbl.SundayDrive[sort] then
		tbl.SundayDrive[sort] = SundayDrive
	else
		SundayDrive = tbl.SundayDrive[sort]
	end
	
	local Swapped1 = {}
	local Swapped2 = {}
	local Swapped3 = {}
	
	for i = 1,7 do
		if math.random() < 0.4 then
			DebugPrint("Swapping L1/4M" .. i)
			table.insert(Swapped1, i)
		end
		if math.random() < 0.4 then
			DebugPrint("Swapping L2/5M" .. i)
			table.insert(Swapped2, i)
		end
		if math.random() < 0.4 then
			DebugPrint("Swapping L3/6M" .. i)
			table.insert(Swapped3, i)
		end
	end
	
	function GetLevel(Level)
		if Level > 3 then
			Level = Level - 3
		else
			Level = Level + 3
		end
		return Level
	end
	
	function Level.RandomLevelMissions(LoadFile, InitFile, Level, Path)
		if Level == 7 then
			return LoadFile, InitFile
		end
		if Level == 1 then
			LoadFile = LoadFile .. "\r\nLoadP3DFile(\"art\\L4CustomT.p3d\");"
		end
		local newFile = ReadFile(Path:gsub("level0" .. Level, "level0" .. GetLevel(Level)))
		for k in newFile:gmatch("LoadP3DFile%s*%(%s*\"art\\missions\\generic\\([^\n]-)%.p3d\"") do
			if not LoadFile:match("art\\missions\\generic\\" .. k .. "%.p3d") then
				LoadFile = LoadFile .. "\r\nLoadP3DFile(\"art\\missions\\generic\\" .. k .. ".p3d\");"
			end
		end
		return LoadFile, InitFile
	end
	
	local fixInit = function(InitFile, BaseChar, NewChar, Level, NewLevel)
		for k,v in pairs(renamedLocators) do
			InitFile = InitFile:gsub("AddNPC%s*%(%s*\"([^\n]-)\"%s*,%s*\"" .. k .. "\"", "AddNPC(\"%1\",\"" .. v .. "\"")
			InitFile = InitFile:gsub("AddObjectiveNPCWaypoint%s*%(%s*\"([^\n]-)\"%s*,%s*\"" .. k .. "\"", "AddObjectiveNPCWaypoint(\"%1\",\"" .. v .. "\"")
			InitFile = InitFile:gsub("AddStageCharacter%s*%(%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"" .. k .. "\"", "AddStageCharacter(\"%1\",\"%2\",\"%3\",\"%4\",\"" .. v .. "\"")
			InitFile = InitFile:gsub("AddStageVehicle%s*%(%s*\"([^\n]-)\"%s*,%s*\"" .. k .. "\"", "AddStageVehicle(\"%1\",\"" .. v .. "\"")
			InitFile = InitFile:gsub("ActivateVehicle%s*%(%s*\"([^\n]-)\"%s*,%s*\"" .. k .. "\"", "ActivateVehicle(\"%1\",\"" .. v .. "\"")
			InitFile = InitFile:gsub("SetDialoguePositions%s*%(%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"", function(one, two, three)
				if one == k then one = v end
				if two == k then two = v end
				if three == k then three = v end
				return "SetDialoguePositions(\"" .. one .. "\",\"" .. two .. "\",\"" .. three .. "\""
			end)
			InitFile = InitFile:gsub("SetDestination%s*%(%s*\"" .. k .. "\"", "SetDestination(\"" .. v .. "\"")
			InitFile = InitFile:gsub("SetMissionStartCameraName%s*%(%s*\"" .. k .. "\"", "SetMissionStartCameraName(\"" .. v .. "\"")
			InitFile = InitFile:gsub("SetMissionStartMulticontName%s*%(%s*\"" .. k .. "\"", "SetMissionStartMulticontName(\"" .. v .. "\"")
			InitFile = InitFile:gsub("SetAnimatedCameraName%s*%(%s*\"" .. k .. "\"", "SetAnimatedCameraName(\"" .. v .. "\"")
			InitFile = InitFile:gsub("SetAnimCamMulticontName%s*%(%s*\"" .. k .. "\"", "SetAnimCamMulticontName(\"" .. v .. "\"")
			InitFile = InitFile:gsub("SetMissionResetPlayerInCar%s*%(%s*\"" .. k .. "\"", "SetMissionResetPlayerInCar(\"" .. v .. "\"")
			InitFile = InitFile:gsub("InitLevelPlayerVehicle%s*%(%s*\"([^\n]-)\"%s*,%s*\"" .. k .. "\"", "InitLevelPlayerVehicle(\"%1\",\"" .. v .. "\"")
			InitFile = InitFile:gsub("SetMissionResetPlayerOutCar%s*%(%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"", function(one, two)
				if one == k then one = v end
				if two == k then two = v end
				return "SetMissionResetPlayerOutCar(\"" .. one .. "\",\"" .. two .. "\""
			end)
			InitFile = InitFile:gsub("AddStageCharacter%s*%(%s*\"([^\n]-)\"%s*,%s*\"" .. k .. "\"", "AddStageCharacter(\"%1\",\"" .. v .. "\"")
		end
		InitFile = InitFile:gsub("SetDynaLoadData%s*%(%s*\"([^\n]-)\"", function(orig)
			return "SetDynaLoadData(\"" .. orig:gsub("l" .. NewLevel, "l" .. Level) .. "\""
		end)
		InitFile = InitFile:gsub("AddStageCharacter%s*%(%s*\"" .. NewChar .. "\"", "AddStageCharacter(\"" .. BaseChar .. "\"")
		InitFile = InitFile:gsub("AddNPC%s*%(%s*\"" .. BaseChar .. "\"", "AddNPC(\"" .. NewChar .. "\"")
		InitFile = InitFile:gsub("AddObjectiveNPCWaypoint%s*%(%s*\"" .. BaseChar .. "\"", "AddObjectiveNPCWaypoint(\"" .. NewChar .. "\"")
		InitFile = InitFile:gsub("SetTalkToTarget%s*%(%s*\"" .. BaseChar .. "\"", "SetTalkToTarget(\"" .. NewChar .. "\"")
		InitFile = InitFile:gsub("AddObjective%s*%(%s*\"dialogue\".-CloseObjective%s*%(%s*%)", function(orig)
			local bitmap = orig:match("SetPresentationBitmap%s*%(%s*\"([^\n]-)\"%s*%);")
			if bitmap then
				return "AddObjective(\"timer\");\r\nSetPresentationBitmap(\"" .. bitmap .. "\");\r\nSetDurationTime(1);\r\nCloseObjective()"
			else
				return "AddObjective(\"timer\");\r\nSetDurationTime(1);\r\nCloseObjective()"
			end
		end)
		return InitFile
	end
	
	local isSwapped = false
	
	function Mission.RandomLevelMissions(LoadFile, InitFile, Level, Mission, Path)
		if Level == 7 or Mission == 0 or Path:match("sr") or Path:match("gr") or Path:match("bm") then
			return LoadFile, InitFile
		elseif isSwapped then
			isSwapped = false
			local newLevel = GetLevel(Level)
			local character = ReadFile("/GameData/scripts/missions/level0" .. newLevel .. "/leveli.mfk"):match("AddCharacter%s*%(%s*\"([^\n]-)\"")
			local character2 = ReadFile("/GameData/scripts/missions/level0" .. Level .. "/leveli.mfk"):match("AddCharacter%s*%(%s*\"([^\n]-)\"")
			LoadFile = ReadFile(Path:gsub("level0" .. Level, "level0" .. newLevel)):gsub("//.-([\r\n])", "%1");
			InitFile = ReadFile(Path:gsub("level0" .. Level, "level0" .. newLevel):gsub("l%.mfk", "i.mfk")):gsub("//.-([\r\n])", "%1");
			InitFile = fixInit(InitFile, character2, character, Level, newLevel)
		end
		return LoadFile, InitFile
	end
	
	function SundayDrive.RandomLevelMissions(LoadFile, InitFile, Level, Mission, Path)
		if Level == 7 or Mission == 0 or Path:match("sr") or Path:match("gr") or Path:match("bm") then
			return LoadFile, InitFile
		end
		if ((Level == 1 or Level == 4) and ExistsInTbl(Swapped1, Mission, true)) or ((Level == 2 or Level == 5) and ExistsInTbl(Swapped2, Mission, true)) or ((Level == 3 or Level == 6) and ExistsInTbl(Swapped3, Mission, true)) then
			isSwapped = true
			local newLevel = GetLevel(Level)
			local character = ReadFile("/GameData/scripts/missions/level0" .. newLevel .. "/leveli.mfk"):match("AddCharacter%s*%(%s*\"([^\n]-)\"")
			local character2 = ReadFile("/GameData/scripts/missions/level0" .. Level .. "/leveli.mfk"):match("AddCharacter%s*%(%s*\"([^\n]-)\"")
			LoadFile = ReadFile(Path:gsub("level0" .. Level, "level0" .. newLevel)):gsub("//.-([\r\n])", "%1");
			InitFile = ReadFile(Path:gsub("level0" .. Level, "level0" .. newLevel):gsub("sdl%.mfk", "sdi.mfk")):gsub("//.-([\r\n])", "%1");
			InitFile = fixInit(InitFile, character2, character, Level, newLevel)
		end
		return LoadFile, InitFile
	end
end