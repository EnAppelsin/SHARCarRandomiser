local args = {...}
local tbl = args[1]
if Settings.SaveChoiceRSC then
	local sort = 5
	local Level = {}
	if not tbl.Level[sort] then
		tbl.Level[sort] = Level
	else
		Level = tbl.Level[sort]
	end
	
	RandomStaticCarSave = {}
	
	function Level.RandomStaticCar(LoadFile, InitFile, Level, Mission, Path)
		RandomStaticCarSave = {}
		return LoadFile, InitFile, { "RandomStaticCar" }
	end
end