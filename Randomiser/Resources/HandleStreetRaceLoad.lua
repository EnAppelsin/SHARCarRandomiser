local Path = GetPath()
local GamePath = GetGamePath(Path)

CurrentStreetRace = tonumber(Path:match("sr(%d)l%.mfk"))
local StreetRaceLoad
local StreetRaceInit

local isChanged = false
for moduleN=1,#Modules do
	local module = Modules[moduleN]
	local handlers = module.Handlers.Race[CurrentLevel][CurrentStreetRace]
	
	for handlerN=1,#handlers do
		local handler = handlers[handlerN]
		
		StreetRaceLoad = MissionLoad or MFKLexer.Lexer:Parse(ReadFile(GamePath))
		StreetRaceInit = MissionInit or MFKLexer.Lexer:Parse(ReadFile(GamePath:sub(1, -6) .. "i.mfk"))
		
		print("ModuleHandler", "Running street race module: " .. module.Name)
		local success, changed = pcall(handler, CurrentLevel, CurrentStreetRace, StreetRaceLoad, StreetRaceInit)
		assert(success, string.format("Error running street race handler from module \"%s\":\n%s", module.Name, changed))
		isChanged = isChanged or changed
	end
end

if isChanged then
	StreetRaceLoad:Output()
	_G.StreetRaceInit = tostring(StreetRaceInit)
end
