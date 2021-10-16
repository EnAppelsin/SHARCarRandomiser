local args = {...}
local tbl = args[1]
if Settings.RandomCharacter then
	local sort = 5
	local Level = {}
	if not tbl.Level[sort] then
		tbl.Level[sort] = Level
	else
		Level = tbl.Level[sort]
	end
	
	function Level.RandomCharacter(LoadFile, InitFile, Level, Path)
		OrigChar = InitFile:match("AddCharacter%s*%(%s*\"([^\n]-)\"")
		return LoadFile, InitFile
	end
end