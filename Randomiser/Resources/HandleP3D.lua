local Path = GetPath()
local GamePath

local P3DFile

local isChanged = false
for moduleN=1,#Modules do
	local module = Modules[moduleN]
	local handlers = module.Handlers.P3D
	
	for handlerN=1,#handlers do
		local handler = handlers[handlerN]
		
		if WildcardMatch(Path, handler.Path, true, true) then
			GamePath = GamePath or GetGamePath(Path)
			P3DFile = P3DFile or P3D.P3DFile(GamePath)
			
			print("ModuleHandler", "Running P3D module: " .. module.Name)
			local success, changed = pcall(handler.Callback, Path, P3DFile)
			assert(success, string.format("Error running P3D handler from module \"%s\":\n%s", module.Name, changed))
			isChanged = isChanged or changed
		end
	end
end

if isChanged then
	P3DFile:Output()
end