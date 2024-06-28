-- Efficiency bullshit, thanks Lua
local assert = assert
local pcall = pcall
local print = print
local string_format = string.format
local WildcardMatch = WildcardMatch
-- End efficiency bullshit

local Path = GetPath()
local GamePath

local MFK

local isChanged = false
for moduleN=1,#Modules do
	local module = Modules[moduleN]
	local handlers = module.Handlers.MFK
	
	for handlerN=1,#handlers do
		local handler = handlers[handlerN]
		
		if WildcardMatch(Path, handler.Path, true, true) then
			GamePath = GamePath or GetGamePath(Path)
			MFK = MFK or MFKLexer.Lexer:Parse(ReadFile(GamePath))
			
			print("ModuleHandler", "Running MFK module: " .. module.Name)
			local success, changed = pcall(handler.Callback, Path, MFK)
			assert(success, string_format("Error running MFK handler from module \"%s\":\n%s", module.Name, changed))
			isChanged = isChanged or changed
		end
	end
end

if isChanged then
	MFK:Output()
end