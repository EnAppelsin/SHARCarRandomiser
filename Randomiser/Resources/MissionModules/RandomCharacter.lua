local args = {...}
local tbl = args[1]
if Settings.RandomCharacter then
	function tbl.Level.RandomCharacter(LoadFile, InitFile, Level, Path)
		OrigChar = InitFile:match("AddCharacter%s*%(%s*\"([^\n]-)\"")
		return LoadFile, InitFile
	end
end