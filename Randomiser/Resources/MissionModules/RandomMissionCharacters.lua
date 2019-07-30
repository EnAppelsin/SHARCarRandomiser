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
		for npc in InitFile:gmatch("AddNPC%s*%(%s*\"([^\n]-)\"") do
			table.insert(MissionCharacters, npc)
		end
		return LoadFile, InitFile
	end
end