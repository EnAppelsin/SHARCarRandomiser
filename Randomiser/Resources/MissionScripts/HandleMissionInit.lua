-- Load the file
local Path = "/GameData/" .. GetPath();
local File = ReadFile(Path):gsub("//.-([\r\n])", "%1");

local level = tonumber(Path:match("level0(%d)"))
local bmission = tonumber(Path:match("bm(%d)i"))
local mission = tonumber(Path:match("m(%d)i"))
local sr = tonumber(Path:match("sr(%d)i"))
local gr = tonumber(Path:match("gr(%d)i"))
local Midx
if bmission then
	DebugPrint("NEW MISSION INIT: Level " .. level .. ", Bonus Mission " .. bmission)
	Midx = bmission
elseif mission then
	DebugPrint("NEW MISSION INIT: Level " .. level .. ", Mission " .. mission)
	Midx = mission
elseif sr then
	DebugPrint("NEW MISSION INIT: Level " .. level .. ", Street Race " .. sr)
	Midx = sr
elseif gr then
	DebugPrint("NEW MISSION INIT: Level " .. level .. ", Gambling Race " .. gr)
	Midx = gr
end
if SettingRandomMissionVehicles then
	if SettingDifferentCellouts and level == 2 and mission == 7 then
		File = ReadFile(ModPath .. "/Resources/l2m7i.mfk")
	end
	for k,v in pairs(MissionVehicles) do
		DebugPrint("Replacing " .. k .. " with " .. v)
		if SettingRandomMissionVehiclesStats or SettingRandomStats then
			File = File:gsub("AddStageVehicle%s*%(%s*\"" .. k .. "\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\".-\"", "AddStageVehicle(\"" .. v .. "\",\"%1\",\"%2\",\"" .. v .. ".con\"")
		else
			File = File:gsub("AddStageVehicle%s*%(%s*\"" .. k .. "\"", "AddStageVehicle(\"" .. v .. "\"")
		end
		File = File:gsub("ActivateVehicle%s*%(%s*\"" .. k .. "\"", "ActivateVehicle(\"" .. v .. "\"")
		File = File:gsub("SetVehicleAIParams%s*%(%s*\"" .. k .. "\"", "SetVehicleAIParams(\"" .. v .. "\"")
		File = File:gsub("SetStageAIRaceCatchupParams%s*%(%s*\"" .. k .. "\"", "SetStageAIRaceCatchupParams(\"" .. v .. "\"")
		File = File:gsub("SetStageAITargetCatchupParams%s*%(%s*\"" .. k .. "\"", "SetStageAITargetCatchupParams(\"" .. v .. "\"")
		File = File:gsub("SetCondTargetVehicle%s*%(%s*\"" .. k .. "\"", "SetCondTargetVehicle(\"" .. v .. "\"")
		File = File:gsub("SetObjTargetVehicle%s*%(%s*\"" .. k .. "\"", "SetObjTargetVehicle(\"" .. v .. "\"")
		File = File:gsub("AddDriver%s*%(%s*\"([^\n]-)\"%s*,%s*\"" .. k .. "\"", "AddDriver(\"%1\",\"" .. v .. "\"")
	end
	for i = 1, #RemovedTrafficCars do
		local k = RemovedTrafficCars[i]
		local v = GetRandomFromTbl(TrafficCars, false)
		DebugPrint("Replacing " .. k .. " with " .. v)
		if SettingRandomMissionVehiclesStats or SettingRandomStats then
			File = File:gsub("AddStageVehicle%s*%(%s*\"" .. k .. "\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\".-\"", "AddStageVehicle(\"" .. v .. "\",\"%1\",\"%2\",\"" .. v .. ".con\"")
		else
			File = File:gsub("AddStageVehicle%s*%(%s*\"" .. k .. "\"", "AddStageVehicle(\"" .. v .. "\"")
		end
		File = File:gsub("ActivateVehicle%s*%(%s*\"" .. k .. "\"", "ActivateVehicle(\"" .. v .. "\"")
		File = File:gsub("SetVehicleAIParams%s*%(%s*\"" .. k .. "\"", "SetVehicleAIParams(\"" .. v .. "\"")
		File = File:gsub("SetStageAIRaceCatchupParams%s*%(%s*\"" .. k .. "\"", "SetStageAIRaceCatchupParams(\"" .. v .. "\"")
		File = File:gsub("SetStageAITargetCatchupParams%s*%(%s*\"" .. k .. "\"", "SetStageAITargetCatchupParams(\"" .. v .. "\"")
		File = File:gsub("SetCondTargetVehicle%s*%(%s*\"" .. k .. "\"", "SetCondTargetVehicle(\"" .. v .. "\"")
		File = File:gsub("SetObjTargetVehicle%s*%(%s*\"" .. k .. "\"", "SetObjTargetVehicle(\"" .. v .. "\"")
		File = File:gsub("AddDriver%s*%(%s*\"([^\n]-)\"%s*,%s*\"" .. k .. "\"", "AddDriver(\"%1\",\"" .. v .. "\"")
	end
	local TmpDriverPool = {table.unpack(RandomPedPool)}
	File = File:gsub("AddStageVehicle%s*%(%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*%);", function(car, position, action, config, orig)
		local driverName = GetRandomFromTbl(TmpDriverPool, true)
		if #TmpDriverPool == 0 then
			TmpDriverPool = {table.unpack(RandomPedPool)}
		end
		for k in pairs(CarDrivers) do
			if k == orig then
				return "AddStageVehicle(\"" .. car .. "\",\"" .. position .. "\",\"" .. action .. "\",\"" .. config .. "\",\"" .. driverName .. "\");"
			end
		end
		return "AddStageVehicle(\"" .. car .. "\",\"" .. position .. "\",\"" .. action .. "\",\"" .. config .. "\",\"" .. orig .. "\");"
	end)
end
if SettingRandomMissionCharacters then
	MissionCharacters = {}
	local found = "Found mission characters: "
	for npc in File:gmatch("AddNPC%s*%(%s*\"([^\n]-)\"") do
		table.insert(MissionCharacters, npc)
		found = found .. npc .. ", "
	end
	DebugPrint(found)
end
if SettingRandomDirectives then
	File = File:gsub("SetStageMessageIndex%s*%(%s*[+-]?%d+%s*%)", function()
		return "SetStageMessageIndex(" .. math.random(1, 273) .. ")"
	end)
	File = File:gsub("SetPresentationBitmap%s*%(%s*\"art/frontend/dynaload/images/.-%.p3d\"%s*%)", function()
		return "SetPresentationBitmap(\"art/frontend/dynaload/images/" .. GetRandomFromTbl(PresentationP3DPool, false) .. ".p3d\")"
	end)
	for orig,rand in pairs(iconReplace) do
		File = File:gsub("SetHUDIcon%s*%(%s*\"" .. orig .. "\"%s*%)", "SetHUDIcon(\"" .. rand .. "\")")
	end
end
if SettingRandomItems then
	for k,v in pairs(itemReplace) do
		File = File:gsub("AddCollectible%s*%(%s*\"([^\n]-)\"%s*,%s*\"" .. k .. "\"", "AddCollectible(\"%1\",\"" .. v .. "\"")
		File = File:gsub("SetDestination%s*%(%s*\"([^\n]-)\"%s*,%s*\"" .. k .. "\"", "SetDestination(\"%1\",\"" .. v .. "\"")
	end
end
-- The random car should have been predecided by the mission load script
if SettingRandomPlayerVehicles then
	local ForcedMission = false
	local Spawn, Match
	-- Try to find a forced vehicle spawn
	Match = File:match("InitLevelPlayerVehicle%s*%(%s*\".-\"%s*,%s*\".-\"%s*,%s*\"OTHER\"%s*%)")
	if Match ~= nil then
		ForcedMission = true
		-- Replace it with the random vehicle
		File = File:gsub("InitLevelPlayerVehicle%s*%(%s*\".-\"%s*,%s*\"([^\n]-)\"%s*,%s*\"OTHER\"%s*%)", "InitLevelPlayerVehicle(\"" .. RandomCarName .. "\",\"%1\",\"OTHER\")", 1)
	else
		-- Try to find the spawn point
		Match, Spawn = File:match("SetMissionResetPlayerOutCar%s*%(%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*%);")
		if Match == nil then
			Spawn = File:match("SetMissionResetPlayerInCar%s*%(%s*\"([^\n]-)\"%s*%);")
		end
		if Spawn ~= nil then
			File = File:gsub("(SetDynaLoadData%s*%(.-%s*%);%s*\r\n)", "%1InitLevelPlayerVehicle(\"" .. RandomCarName .. "\", \"" .. Spawn .. "\", \"OTHER\");\r\nSetForcedCar();\r\n", 1)
			-- Because we create a "forced vehicle", delete stages before the reset as it automatically respawns you to the reset point anyway
			-- (So objectives like "leave office" or "head to car" don't work)
			-- Also look if we delete a stage which adds a vehicle, then replicate that. (TODO: Is this all?)
			
			-- Take a substring because we don't care about anything after RESET_TO_HERE (which appears once) and if we don't then
			-- Wolves takes AGES to (fail to) match the regex below. 
			ResetIndex = File:find("RESET_TO_HERE%s*%(%s*%)")
			if ResetIndex then
				EarlySubstring = File:sub(1, ResetIndex+15)			
				Match = EarlySubstring:match("AddStage%s*%(.-%s*%);.*(AddStageVehicle%s*%(.-%s*%);).*AddStage%s*%(.-%s*%);%s*\r\n%s*RESET_TO_HERE%s*%(%s*%);")
				FakeStage = ""
				if Match ~= nil then
					FakeStage = "AddStage();\r\n" .. Match .. "\r\nAddObjective(\"timer\");\r\nSetDurationTime(0);\r\nCloseObjective();\r\nCloseStage();\r\n"
					DebugPrint("Creating a fake add vehicle stage")
				end
				File = File:gsub("\r\nAddStage%s*%(.-%s*%);.*AddStage%s*%((.-)%s*%);%s*\r\n%s*RESET_TO_HERE%s*%(%s*%);", "\r\n" .. FakeStage .. "AddStage(%1);\r\nRESET_TO_HERE();", 1)
				DebugPrint("Deleting an early stage")
			end
		end
	end
	-- Debugging
	DebugPrint("Randomising car for mission " ..  Midx .. " -> " .. RandomCarName .. (ForcedMission and " (forced)" or ""))
end
if SettingSkipFMVs then
	File = File:gsub("AddObjective%s*%(\"fmv\"%s*%);.-CloseObjective%s*%(%s*%);", "AddObjective(\"timer\");\r\nSetDurationTime(1);\r\nCloseObjective();", 1)
end
if SettingRandomChase then
	File = File:gsub("\"cPolice\"", "\"" .. RandomChase .. "\"")
	File = File:gsub("\"cHears\"", "\"" .. RandomChase .. "\"")
end
if SettingRandomInteriors then
	File = File:gsub("SetDynaLoadData%s*%(%s*\"([^\n]-)i([^\n]-).p3d@\"", function(data, interior)
		local newInterior = nil
		for k,v in pairs(interiorReplace) do
			if v == interior then
				newInterior = k
				break
			end
		end
		return "SetDynaLoadData(\"" .. data .. "i" .. newInterior .. ".p3d@\""
	end)
end
	
Output(File)