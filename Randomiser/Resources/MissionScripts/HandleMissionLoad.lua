local Path = "/GameData/" .. GetPath();
loading = true
if MissionModules.Mission then
	local level = tonumber(Path:match("level0(%d)"))
	local mission = tonumber(Path:match("[rm](%d)l"))
	DebugPrint("NEW MISSION/RACE LOAD: Level " .. level .. ", Mission/Race " .. mission)
	local LoadFile = ReadFile(Path):gsub("//.-([\r\n])", "%1");
	local InitFile = ReadFile(Path:gsub("l%.mfk", "i.mfk")):gsub("//.-([\r\n])", "%1");
	for i = MissionMin,MissionMax do
		if MissionModules.Mission[i] then
			for k,v in pairs(MissionModules.Mission[i]) do
				DebugPrint("Running module: " .. k, 2)
				LoadFile, InitFile = v(LoadFile, InitFile, level, mission, Path)
			end
		end
	end
	MissionInit = InitFile
	--[[if Settings.DebugLevel >= 5 then
		DebugPrint("Mission Load File:\r\n" .. LoadFile)
		DebugPrint("Mission Init File:\r\n" .. InitFile)
	end]]--
	Output(LoadFile)
end