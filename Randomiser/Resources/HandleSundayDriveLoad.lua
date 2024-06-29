local table_unpack = table.unpack

local Path = GetPath()
local GamePath = GetGamePath(Path)

CurrentSundayDrive = tonumber(Path:match("m(%d)sdl%.mfk"))
local SundayDriveLoad
local SundayDriveInit

local isChanged = false
for moduleN=1,#Modules do
	local module = Modules[moduleN]
	local handlers
	if CurrentLevel == 1 then
		handlers = {table_unpack(module.Handlers.SundayDrive[CurrentLevel][CurrentSundayDrive + 1])}
	else
		handlers = {table_unpack(module.Handlers.SundayDrive[CurrentLevel][CurrentSundayDrive])}
	end
	
	for handlerN=1,#handlers do
		local handler = handlers[handlerN]
		
		SundayDriveLoad = SundayDriveLoad or MFKLexer.Lexer:Parse(ReadFile(GamePath))
		SundayDriveInit = SundayDriveInit or MFKLexer.Lexer:Parse(ReadFile(GamePath:sub(1, -6) .. "i.mfk"))
		
		print("ModuleHandler", "Running sunday drive module: " .. module.Name)
		local success, changed = pcall(handler, CurrentLevel, CurrentSundayDrive, SundayDriveLoad, SundayDriveInit)
		assert(success, string.format("Error running sunday drive handler from module \"%s\":\n%s", module.Name, changed))
		isChanged = isChanged or changed
	end
end

if isChanged then
	SundayDriveLoad:Output(true)
	_G.SundayDriveInit = SundayDriveInit
end