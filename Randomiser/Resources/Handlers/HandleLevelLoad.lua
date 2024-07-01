local Path = GetPath()
local GamePath = GetGamePath(Path)

CurrentLevel = tonumber(Path:match("level0(%d)"))
local LevelLoad
local LevelInit

local isChanged = false
for moduleN=1,#Modules do
	local module = Modules[moduleN]
	local handlers = module.Handlers.Level[CurrentLevel]
	
	for handlerN=1,#handlers do
		local handler = handlers[handlerN]
		
		if handler then
			LevelLoad = LevelLoad or MFKLexer.Lexer:Parse(ReadFile(GamePath))
			LevelInit = LevelInit or MFKLexer.Lexer:Parse(ReadFile(GamePath:sub(1, -5) .. "i.mfk"))
			
			print("ModuleHandler", "Running level module: " .. module.Name)
			local success, changed = pcall(handler, CurrentLevel, LevelLoad, LevelInit)
			assert(success, string.format("Error running level handler from module \"%s\":\n%s", module.Name, changed))
			isChanged = isChanged or changed
		end
	end
end

if isChanged then
	LevelLoad:Output(true)
	_G.LevelInit = LevelInit
end