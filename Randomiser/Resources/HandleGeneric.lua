if IsWriting() then
	return
end

local Path = GetPath()
local GamePath = GetGamePath(Path)

local contents
local isChanged = false
for moduleN=1,#Modules do
	local module = Modules[moduleN]
	local handlers = module.Handlers.Generic
	
	for handlerN=1,#handlers do
		local handler = handlers[handlerN]
		
		if WildcardMatch(Path, handler.Path, true, true) then
			if Exists(GamePath, true, false) then
				contents = contents or ReadFile(GamePath)
			end
			
				print("ModuleHandler", "Running generic module: " .. module.Name)
			local success, changed, newContents = pcall(handler.Callback, contents)
			assert(success, string.format("Error running generic handler from module \"%s\":\n%s", module.Name, changed))
			if changed then
				contents = newContents
				isChanged = true
			end
		end
	end
end

if isChanged then
	Output(contents)
end