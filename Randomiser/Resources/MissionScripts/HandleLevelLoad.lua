local Path = "/GameData/" .. GetPath();

if Settings.IsSeeded then
	Seed.HandleModulesLevel(Path)
end

loading = true
if MissionModules.Level then
	local level = tonumber(Path:match("level0(%d)"))
	DebugPrint("NEW LEVEL LOAD: Level " .. level)
	local LoadFile = ReadFile(Path):gsub("//.-([\r\n])", "%1");
	local InitFile = ReadFile(Path:gsub("level%.mfk", "leveli.mfk")):gsub("//.-([\r\n])", "%1");
	for i = LevelMin,LevelMax do
		if MissionModules.Level[i] then
			for k,v in pairs(MissionModules.Level[i]) do
				DebugPrint("Running module: " .. k, 2)
				LoadFile, InitFile = v(LoadFile, InitFile, level, Path)
			end
		end
	end
	LevelInit = InitFile
	if Settings.DebugLevel >= 5 then
		DebugPrint("Level Load File:\r\n" .. LoadFile)
		DebugPrint("Level Init File:\r\n" .. InitFile)
	end
	Output(LoadFile)
end
