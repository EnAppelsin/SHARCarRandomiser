local Path = GetPath()
local GamePath = GetGamePath(Path)

CurrentMission = 9
local BonusMissionLoad
local BonusMissionInit

local isChanged = false
for moduleN=1,#Modules do
	local module = Modules[moduleN]
	local handlers = module.Handlers.Mission[CurrentLevel][CurrentMission]
	
	for handlerN=1,#handlers do
		local handler = handlers[handlerN]
		
		if handler then
			BonusMissionLoad = BonusMissionLoad or MFKLexer.Lexer:Parse(ReadFile(GamePath))
			BonusMissionInit = BonusMissionInit or MFKLexer.Lexer:Parse(ReadFile(GamePath:sub(1, -6) .. "i.mfk"))
			
			print("ModuleHandler", "Running mission module: " .. module.Name)
			local success, changed = pcall(handler, CurrentLevel, CurrentMission, BonusMissionLoad, BonusMissionInit)
			assert(success, string.format("Error running bonus mission handler from module \"%s\":\n%s", module.Name, changed))
			isChanged = isChanged or changed
		end
	end
end

if isChanged then
	BonusMissionLoad:Output(true)
	_G.BonusMissionInit = BonusMissionInit
end
