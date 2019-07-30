local args = {...}
local tbl = args[1]
if Settings.RandomMissionsCharacters then
	function tbl.Level.RandomMissionsCharacters(LoadFile, InitFile, Level)
		BonusCharacters = {}
		for npc in InitFile:gmatch("AddNPCCharacterBonusMission%s*%(%s*\"([^\n]-)\"") do
			table.insert(BonusCharacters, npc)
		end
		return LoadFile, InitFile
	end
	
	function tbl.SundayDrive.RandomMissionsCharacters(LoadFile, InitFile, Level, Mission)
		MissionCharacters = {}
		local found = "Found mission characters: "
		for npc in InitFile:gmatch("AddNPC%s*%(%s*\"([^\n]-)\"") do
			table.insert(MissionCharacters, npc)
			found = found .. npc .. ", "
		end
		DebugPrint(found)
		return LoadFile, InitFile
	end
	tbl.Mission.RandomMissionsCharacters = tbl.SundayDrive.RandomMissionsCharacters
	--[[function tbl.Mission.RandomMissionsCharacters(LoadFile, InitFile, Level, Mission)
		MissionCharacters = {}
		local found = "Found mission characters: "
		for npc in InitFile:gmatch("AddNPC%s*%(%s*\"([^\n]-)\"") do
			table.insert(MissionCharacters, npc)
			found = found .. npc .. ", "
		end
		DebugPrint(found)
		return LoadFile, InitFile
	end]]--
end