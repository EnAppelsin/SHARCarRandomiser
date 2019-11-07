local args = {...}
local tbl = args[1]
if Settings.RandomBonusMissions then
	local sort = 5
	local Level = {}
	if not tbl.Level[sort] then
		tbl.Level[sort] = Level
	else
		Level = tbl.Level[sort]
	end
	
	function Level.RandomBonusMissions(LoadFile, InitFile, Level, Path)
		local missions = {}
		local chars = {}
		for npc, skeleton, location, mission, drawable, convo, fuckKnows in InitFile:gmatch("AddNPCCharacterBonusMission%s*%(%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*(%d)") do
			missions[mission] = convo
			chars[mission] = npc
		end
		local oldMission
		local newMission
		local newConvo
		InitFile = InitFile:gsub("(.-)\n", function(original)
			original = original:gsub("AddNPCCharacterBonusMission%s*%(%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*(%d)", function(npc, skeleton, location, mission, drawable, convo, fuckKnows)
				oldMission = mission
				newMission, newConvo = GetRandomFromKVTbl(missions, true)
				local newChar = chars[newMission]
				DebugPrint("Randomised bonus mission \"" .. oldMission .. "\" to \"" .. newMission .. "\"")
				return "AddNPCCharacterBonusMission(\"" .. newChar .. "\",\"" .. skeleton .. "\",\"" .. location .. "\",\"" .. newMission .. "\",\"" .. drawable .. "\",\"" .. newConvo .. "\"," .. (newMission:sub(1, 1) == "b" and "1" or "0")
			end)
			if oldMission and newMission then
				original = original:gsub("SetBonusMissionDialoguePos%s*%(%s*\"" .. oldMission .. "\"", "SetBonusMissionDialoguePos(\"" .. newMission .. "\"")
			end
			return original .. "\n"
		end)
		return LoadFile, InitFile
	end
end