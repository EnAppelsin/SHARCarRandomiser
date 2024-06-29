local table_unpack = table.unpack

local Path = GetPath()
local GamePath = GetGamePath(Path)

local GambleRaceLoad
local GambleRaceInit

local isChanged = false
for moduleN=1,#Modules do
	local module = Modules[moduleN]
	local handlers = {table_unpack(module.Handlers.Race[CurrentLevel][4])}
	
	for handlerN=1,#handlers do
		local handler = handlers[handlerN]
		
		GambleRaceLoad = GambleRaceLoad or MFKLexer.Lexer:Parse(ReadFile(GamePath))
		GambleRaceInit = GambleRaceInit or MFKLexer.Lexer:Parse(ReadFile(GamePath:sub(1, -6) .. "i.mfk"))
		
		print("ModuleHandler", "Running gamble race module: " .. module.Name)
		local success, changed = pcall(handler, CurrentLevel, 4, GambleRaceLoad, GambleRaceInit)
		assert(success, string.format("Error running gamble race handler from module \"%s\":\n%s", module.Name, changed))
		isChanged = isChanged or changed
	end
end

if isChanged then
	GambleRaceLoad:Output()
	_G.GambleRaceInit = tostring(GambleRaceInit)
end
