-- Efficiency bullshit, thanks Lua
local assert = assert
local pcall = pcall
local print = print
local string_format = string.format
local table_unpack = table.unpack
local WildcardMatch = WildcardMatch
-- End efficiency bullshit

local Path = GetPath()
local GamePath

local SPT

local isChanged = false
for moduleN=1,#Modules do
	local module = Modules[moduleN]
	local handlers = {table_unpack(module.Handlers.SPT)}
	
	for handlerN=1,#handlers do
		local handler = handlers[handlerN]
		
		if WildcardMatch(Path, handler.Path, true, true) then
			GamePath = GamePath or GetGamePath(Path)
			SPT = SPT or SPTParser.SPTFile(GamePath)
			
			print("ModuleHandler", "Running SPT module: " .. module.Name)
			local success, changed = pcall(handler.Callback, Path, SPT)
			assert(success, string_format("Error running SPT handler from module \"%s\":\n%s", module.Name, changed))
			isChanged = isChanged or changed
		end
	end
end

if isChanged then
	Output(tostring(SPT))
end