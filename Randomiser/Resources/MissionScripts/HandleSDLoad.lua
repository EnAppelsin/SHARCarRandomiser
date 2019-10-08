local Path = "/GameData/" .. GetPath();
loading = true
if MissionModules.SundayDrive then
	local level = tonumber(Path:match("level0(%d)"))
	local mission = tonumber(Path:match("m(%d)sdl"))
	DebugPrint("NEW SD LOAD: Level " .. level .. ", Mission " .. mission)
	local LoadFile = ReadFile(Path):gsub("//.-([\r\n])", "%1");
	local InitFile = ReadFile(Path:gsub("sdl%.mfk", "sdi.mfk")):gsub("//.-([\r\n])", "%1");
	for i = SundayMin,SundayMax do
		if MissionModules.Mission[i] then
			for k,v in pairs(MissionModules.SundayDrive[i]) do
				DebugPrint("Running module: " .. k, 2)
				LoadFile, InitFile = v(LoadFile, InitFile, level, mission, Path)
			end
		end
	end
	LastLevel = nil
	PlayerStats = nil
	SDInit = InitFile
	--[[if Settings.DebugLevel >= 5 then
		DebugPrint("SD Load File:\r\n" .. LoadFile)
		DebugPrint("SD Init File:\r\n" .. InitFile)
	end]]--
	Output(LoadFile)
end