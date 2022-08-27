local Path = GetPath()
local GamePath = GetGamePath(Path)
local InitPath = GamePath:sub(1, -6) .. "i.mfk"
local Level = GamePath:match("^/GameData/scripts/missions/level0(%d)")
Level = tonumber(Level)

local LoadFile
local InitFile

local Changed = false
for i=1,#Modules do
	local Module = Modules[i]
	
	if Module.HandleMissions then
		LoadFile = LoadFile or MFKLexer.Lexer:Parse(ReadFile(GamePath))
		InitFile = InitFile or MFKLexer.Lexer:Parse(ReadFile(InitPath))
		
		if Module.HandleMissions(LoadFile, InitFile, Level) then
			Changed = true
		end
	end
end

if Changed then
	LoadFile:Output(true)
	MissionInit = InitFile:__tostring(true)
end