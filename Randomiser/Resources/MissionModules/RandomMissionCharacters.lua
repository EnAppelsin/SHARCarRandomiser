local args = {...}
local tbl = args[1]
if Settings.RandomMissionCharacters then
	local sort = 5
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
	
	function Level.RandomMissionCharacters(LoadFile, InitFile, Level, Path)
		BonusCharacters = {}
		for npc in InitFile:gmatch("AddNPCCharacterBonusMission%s*%(%s*\"([^\n]-)\"") do
			table.insert(BonusCharacters, npc)
		end
		return LoadFile, InitFile, { "BonusCharacters" }
	end
	
	function SundayDrive.RandomMissionCharacters(LoadFile, InitFile, Level, Mission, Path)
		MissionCharacters = {}
		local found = "Found mission characters: "
		for npc in InitFile:gmatch("AddNPC%s*%(%s*\"([^\n]-)\"") do
			table.insert(MissionCharacters, npc)
			found = found .. npc .. ", "
		end
		DebugPrint(found)
		return LoadFile, InitFile, { "MissionCharacters" }
	end
	Mission.RandomMissionCharacters = SundayDrive.RandomMissionCharacters
end