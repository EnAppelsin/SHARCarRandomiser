if IsWriting() then
	return
end

local Path = GetPath()
local GamePath = GetGamePath(Path)
local Extension = GetFileExtension(Path):lower()

assert(Modules ~= nil and #Modules ~= 0, "ModuleHandler requires a Modules table")

local LevelLoadPattern = "scripts\\missions\\level0%d\\level.mfk"
local LevelInitPattern = "scripts\\missions\\level0%d\\leveli.mfk"

local SundayDriveLoadPattern = "scripts\\missions\\level0%d\\m%dsdl.mfk"
local SundayDriveInitPattern = "scripts\\missions\\level0%d\\md%dsdi.mfk"

local MissionLoadPattern = "scripts\\missions\\level0%d\\m%dl.mfk"
local MissionInitPattern = "scripts\\missions\\level0%d\\m%di.mfk"

local StreetRaceLoadPattern = "scripts\\missions\\level0%d\\sr%dl.mfk"
local StreetRaceInitPattern = "scripts\\missions\\level0%d\\sr%di.mfk"
if Extension == ".mfk" then
	if Path:match(LevelLoadPattern) then
		CurrentLevel = tonumber(Path:match("level0(%d)"))
		local LevelLoad
		local LevelInit
		
		local isChanged = false
		for moduleN=1,#Modules do
			local module = Modules[moduleN]
			local handlers = module.Handlers.Level[CurrentLevel]
			
			for handlerN=1,#handlers do
				local handler = handlers[handlerN]
				
				LevelLoad = LevelLoad or MFKLexer.Lexer:Parse(ReadFile(GamePath))
				LevelInit = LevelInit or MFKLexer.Lexer:Parse(ReadFile(GamePath:sub(1, -5) .. "i.mfk"))
				
				print("ModuleHandler", "Running level module: " .. module.Name)
				local success, changed = pcall(handler, CurrentLevel, LevelLoad, LevelInit)
				assert(success, string.format("Error running level handler from module \"%s\":\n%s", module.Name, changed))
				isChanged = isChanged or changed
			end
		end
		
		if isChanged then
			LevelLoad:Output()
			_G.LevelInit = tostring(LevelInit)
		end
		return
	end
	if Path:match(LevelInitPattern) then
		if LevelInit then
			Output(LevelInit)
			LevelInit = nil
		end
		return
	end
	
	if Path:match(SundayDriveLoadPattern) then
		CurrentMission = tonumber(Path:match("m(%d)sdl%.mfk"))
		local MissionLoad
		local MissionInit
		
		local isChanged = false
		for moduleN=1,#Modules do
			local module = Modules[moduleN]
			local handlers
			if CurrentLevel == 1 then
				handlers = module.Handlers.SundayDrive[CurrentLevel][CurrentMission + 1]
			else
				handlers = module.Handlers.SundayDrive[CurrentLevel][CurrentMission]
			end
			
			for handlerN=1,#handlers do
				local handler = handlers[handlerN]
				
				MissionLoad = MissionLoad or MFKLexer.Lexer:Parse(ReadFile(GamePath))
				MissionInit = MissionInit or MFKLexer.Lexer:Parse(ReadFile(GamePath:sub(1, -6) .. "i.mfk"))
				
				print("ModuleHandler", "Running sunday drive module: " .. module.Name)
				local success, changed = pcall(handler, CurrentLevel, CurrentMission, MissionLoad, MissionInit)
				assert(success, string.format("Error running sunday drive handler from module \"%s\":\n%s", module.Name, changed))
				isChanged = isChanged or changed
			end
		end
		
		if isChanged then
			MissionLoad:Output()
			_G.MissionInit = tostring(MissionInit)
		end
		return
	end
	if Path:match(SundayDriveInitPattern) then
		if MissionInit then
			Output(MissionInit)
			MissionInit = nil
		end
		return
	end
	
	if Path:match(MissionLoadPattern) then
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
				
				MissionLoad = MissionLoad or MFKLexer.Lexer:Parse(ReadFile(GamePath))
				MissionInit = MissionInit or MFKLexer.Lexer:Parse(ReadFile(GamePath:sub(1, -6) .. "i.mfk"))
				
				print("ModuleHandler", "Running mission module: " .. module.Name)
				local success, changed = pcall(handler, CurrentLevel, CurrentMission, MissionLoad, MissionInit)
				assert(success, string.format("Error running mission handler from module \"%s\":\n%s", module.Name, changed))
				isChanged = isChanged or changed
			end
		end
		
		if isChanged then
			MissionLoad:Output()
			_G.MissionInit = tostring(MissionInit)
		end
		return
	end
	if Path:match(MissionInitPattern) then
		if MissionInit then
			Output(MissionInit)
			MissionInit = nil
		end
		return
	end
	
	if Path:match(StreetRaceLoadPattern) then
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
		return
	end
	if Path:match(StreetRaceInitPattern) then
		if StreetRaceInit then
			Output(StreetRaceInit)
			StreetRaceInit = nil
		end
		return
	end
	
	local MFK
	
	local isChanged = false
	for moduleN=1,#Modules do
		local module = Modules[moduleN]
		local handlers = module.Handlers.MFK
		
		for handlerN=1,#handlers do
			local handler = handlers[handlerN]
			
			if WildcardMatch(Path, handler.Path, true, true) then
				MFK = MFK or MFKLexer.Lexer:Parse(ReadFile(GamePath))
				
				print("ModuleHandler", "Running MFK module: " .. module.Name)
				local success, changed = pcall(handler.Callback, Path, MFK)
				assert(success, string.format("Error running MFK handler from module \"%s\":\n%s", module.Name, changed))
				isChanged = isChanged or changed
			end
		end
	end
	
	if isChanged then
		MFK:Output()
	end
	
	return
end

if Extension == ".con" then
	local CON
	
	local isChanged = false
	for moduleN=1,#Modules do
		local module = Modules[moduleN]
		local handlers = module.Handlers.CON
		
		for handlerN=1,#handlers do
			local handler = handlers[handlerN]
			
			if WildcardMatch(Path, handler.Path, true, true) then
				CON = CON or MFKLexer.Lexer:Parse(ReadFile(GamePath))
				
				print("ModuleHandler", "Running CON module: " .. module.Name)
				local success, changed = pcall(handler.Callback, Path, CON)
				assert(success, string.format("Error running CON handler from module \"%s\":\n%s", module.Name, changed))
				isChanged = isChanged or changed
			end
		end
	end
	
	if isChanged then
		CON:Output()
	end
	
	return
end

if Extension == ".p3d" then
	local P3DFile
	
	local isChanged = false
	for moduleN=1,#Modules do
		local module = Modules[moduleN]
		local handlers = module.Handlers.P3D
		
		for handlerN=1,#handlers do
			local handler = handlers[handlerN]
			
			if WildcardMatch(Path, handler.Path, true, true) then
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
	
	return
end

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