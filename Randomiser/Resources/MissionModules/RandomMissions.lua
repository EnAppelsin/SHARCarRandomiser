local args = {...}
local tbl = args[1]
if Settings.RandomMissions then
	local sort = 5
	Level = {}
	if not tbl.Level[sort] then
		tbl.Level[sort] = Level
	else
		Level = tbl.Level[sort]
	end
	
	function Level.RandomMissions(LoadFile, InitFile, Level, Path)
		DebugPrint("Randomising mission order")
		local missions = {}
		for mission in LoadFile:gmatch("AddMission%s*%(%s*\"m(%d)\"") do
			if tonumber(mission) < 8 then
				table.insert(missions, mission)
			end
		end
		LoadFile = LoadFile:gsub("AddMission%s*%(%s*\"m(%d)\"", function(orig)
			local mission = tonumber(orig)
			if mission < 8 then
				local tmp = {table.unpack(missions)}
				local exists = ExistsInTbl(tmp, orig, false)
				if exists then
					if #tmp > 1 then
						for i = #tmp, 1, -1 do
							if tmp[i] == orig then
								table.remove(tmp, i)
								break
							end
						end
					end
				end
				local newMission = GetRandomFromTbl(tmp, true)
				if exists then
					table.insert(tmp, orig)
				end
				missions = {table.unpack(tmp)}
				DebugPrint("Randomised mission " .. orig .. " to " .. newMission, 1)
				return "AddMission(\"m" .. newMission .. "\""
			else
				return "AddMission(\"m" .. orig .. "\""
			end
		end)
		--[[local missions = {"sr1", "sr2", "sr3", "gr1", "bm1"}
		local oldMission
		local newMission
		InitFile = InitFile:gsub("(.-)\n", function(original)
			original = original:gsub("AddNPCCharacterBonusMission%s*%(%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"", function(npc, skeleton, location, mission)
				oldMission = mission
				newMission = GetRandomFromTbl(missions, true)
				return "AddNPCCharacterBonusMission(\"" .. npc .. "\",\"" .. skeleton .. "\",\"" .. location .. "\",\"" .. newMission .. "\""
			end)
			if oldMission and newMission then
				original = original:gsub("SetBonusMissionDialoguePos%s*%(%s*\"" .. oldMission .. "\"", "SetBonusMissionDialoguePos(\"" .. newMission .. "\"")
				original = original:gsub("SetConversationCam%s*%(%s*(%d)%s*,%s*\"([^\n]-)\"%s*,*%s*\"" .. oldMission .. "\"", "SetConversationCam(%1,\"%2\",\"" .. newMission .. "\"")
				original = original:gsub("ClearAmbientAnimations%s*%(%s*\"" .. oldMission .. "\"", "ClearAmbientAnimations(\"" .. newMission .. "\"")
				original = original:gsub("AddAmbientNpcAnimation%s*%(%s*\"([^\n]-)\"%s*,*%s*\"" .. oldMission .. "\"", "AddAmbientNpcAnimation(\"%1\",\"" .. newMission .. "\"")
				original = original:gsub("AddAmbientPcAnimation%s*%(%s*\"([^\n]-)\"%s*,*%s*\"" .. oldMission .. "\"", "AddAmbientPcAnimation(\"%1\",\"" .. newMission .. "\"")
				original = original:gsub("SetCamBestSide%s*%(%s*\"([^\n]-)\"%s*,*%s*\"" .. oldMission .. "\"", "SetCamBestSide(\"%1\",\"" .. newMission .. "\"")
			end
			return original .. "\n"
		end)]]--
		return LoadFile, InitFile
	end
end