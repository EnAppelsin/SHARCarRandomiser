local Path = "/GameData/" .. GetPath();
if MissionModules.Mission then
	local level = tonumber(Path:match("level0(%d)"))
	local mission = tonumber(Path:match("m(%d)l"))
	DebugPrint("NEW SD LOAD: Level " .. level .. ", Mission " .. mission)
	local LoadFile = ReadFile(Path):gsub("//.-([\r\n])", "%1");
	local InitFile = ReadFile(Path:gsub("l%.mfk", "i.mfk")):gsub("//.-([\r\n])", "%1");
	for k,v in pairs(MissionModules.Mission) do
		DebugPrint("Running module: " .. k, 2)
		LoadFile, InitFile = v(LoadFile, InitFile, level, mission)
	end
	MissionInit = InitFile
	Output(LoadFile)
end