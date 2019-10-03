local args = {...}
local tbl = args[1]
if Settings.RandomMissionCharacters then
	function tbl.Level.RandomMissionCharacters(LoadFile, InitFile, Level, Path)
		BonusCharacters = {}
		for npc in InitFile:gmatch("AddNPCCharacterBonusMission%s*%(%s*\"([^\n]-)\"") do
			table.insert(BonusCharacters, npc)
		end
		return LoadFile, InitFile
	end
	
	function tbl.SundayDrive.RandomMissionCharacters(LoadFile, InitFile, Level, Mission, Path)
		MissionCharacters = {}
		local found = "Found mission characters: "
		for npc in InitFile:gmatch("AddNPC%s*%(%s*\"([^\n]-)\"") do
			table.insert(MissionCharacters, npc)
			found = found .. npc .. ", "
		end
		DebugPrint(found)
		return LoadFile, InitFile
	end
	tbl.Mission.RandomMissionCharacters = tbl.SundayDrive.RandomMissionCharacters
end