local assert = assert
local type = type

local math_random = math.random
local string_format = string.format

local GetFileExtension = GetFileExtension

function GetGamePath(Path)
	Path = FixSlashes(Path,false,true)
	if Path:sub(1,1) ~= "/" then Path = "/GameData/"..Path end
	return Path
end

function GetFilesInDirectory(Dir, Tbl, Extension, ProcessSubDirs)
	assert(type(Dir) == "string", "Arg #1 (Dir) must be a string")
	assert(type(Tbl) == "table", "Arg #2 (Tbl) must be a table")
	assert(Extensions == nil or type(Extension) == "string", "Arg #3 (Extension) must be a string")
	if Extension then
		Extension = Extension:lower()
	end
	
	DirectoryGetEntries(Dir, function(Entry, IsDir)
		if IsDir then
			if ProcessSubDirs then
				GetFilesInDirectory(string_format("%s/%s", Dir, Entry), Tbl, Extension, true)
			end
			return true
		end
		
		if Extension == nil or GetFileExtension(Entry):lower() == Extension then
			Tbl[#Tbl + 1] = string_format("%s/%s", Dir, Entry)
		end
		
		return true
	end)
end

function ShuffleTable(tbl)
	for i=#tbl,2,-1 do
		local j = math_random(i)
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
end