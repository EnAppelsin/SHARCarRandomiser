local args = {...}
if #args > 0 then
	local tbl = args[1]
	if tbl.Level == nil then
		tbl.Level = {}
	end
	
	if Settings.RandomCharacter then
		function tbl.Level.RandomCharacter(LoadFile, InitFile, Level)
			OrigChar = InitFile:match("AddCharacter%s*%(%s*\"([^\n]-)\"")
			return LoadFile, InitFile
		end
	end
end