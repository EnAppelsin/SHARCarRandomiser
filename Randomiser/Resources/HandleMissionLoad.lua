local Path = GetPath()
local GamePath = GetGamePath(Path)

CurrentMission = tonumber(Path:match("m(%d)l%.mfk"))
local MissionLoad
local MissionInit

local isChanged = false
for moduleN=1,#Modules do
	local module = Modules[moduleN]
	local handlers
	if CurrentLevel == 1 then
		handlers = module.Handlers.Mission[CurrentLevel][CurrentMission + 1]
	else
		handlers = module.Handlers.Mission[CurrentLevel][CurrentMission]
	end
	
	for handlerN=1,#handlers do
		local handler = handlers[handlerN]
		
		if handler then
			MissionLoad = MissionLoad or MFKLexer.Lexer:Parse(ReadFile(GamePath))
			MissionInit = MissionInit or MFKLexer.Lexer:Parse(ReadFile(GamePath:sub(1, -6) .. "i.mfk"))
			
			print("ModuleHandler", "Running mission module: " .. module.Name)
			local success, changed = pcall(handler, CurrentLevel, CurrentMission, MissionLoad, MissionInit)
			assert(success, string.format("Error running mission handler from module \"%s\":\n%s", module.Name, changed))
			isChanged = isChanged or changed
		end
	end
end

if isChanged then
	MissionLoad:Output(true)
	_G.MissionInit = MissionInit
end
