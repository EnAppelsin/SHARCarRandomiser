local Path = "/GameData/" .. GetPath();
if MissionModules.Level then
	local level = tonumber(Path:match("level0(%d)"))
	DebugPrint("NEW LEVEL LOAD: Level " .. level)
	local LoadFile = ReadFile(Path):gsub("//.-([\r\n])", "%1");
	local InitFile = ReadFile(Path:gsub("level%.mfk", "leveli.mfk")):gsub("//.-([\r\n])", "%1");
	for k,v in pairs(MissionModules.Level) do
		DebugPrint("Running module: " .. k, 2)
		LoadFile, InitFile = v(LoadFile, InitFile, level, Path)
	end
	LevelInit = InitFile
	if Settings.DebugLevel >= 5 then
		DebugPrint("Level Load File:\r\n" .. LoadFile)
		DebugPrint("Level Init File:\r\n" .. InitFile)
	end
	Output(LoadFile)
end