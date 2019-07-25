local args = {...}
if #args > 0 then
	local tbl = args[1]
	if tbl.Level == nil then
		tbl.Level = {}
	end
	
	if Settings.RandomMissionsCharacters then
		function tbl.Level.RandomMissionsCharacters(LoadFile, InitFile, Level)
			BonusCharacters = {}
			for npc in InitFile:gmatch("AddNPCCharacterBonusMission%s*%(%s*\"([^\n]-)\"") do
				table.insert(BonusCharacters, npc)
			end
			return LoadFile, InitFile
		end
	end
end