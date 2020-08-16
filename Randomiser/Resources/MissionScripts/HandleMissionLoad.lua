local Path = "/GameData/" .. GetPath();
loading = true
if MissionModules.Mission then
	local level = tonumber(Path:match("level0(%d)"))
	local prefix, mission = Path:match("([bsg]?[rm])(%d)l")
	mission = tonumber(mission)
	local misstype, missname
	if prefix == "m" then
		misstype = MissionType.Normal
		missname = "Mission"
	elseif prefix == "sr" then
		misstype = MissionType.Race
		missname = "Race"
	elseif prefix == "bm" then
		misstype = MissionType.BonusMission
		missname = "Bonus Mission"
	elseif prefix == "gr" then
		misstype = MissionType.GamblingRace
		missname = "Gambling Race"
	else
		error("unknown mission script type")
	end
	DebugPrint("NEW MISSION/RACE LOAD: Level " .. level .. ", " .. missname .. " " .. mission)
	local LoadFile = ReadFile(Path):gsub("//.-([\r\n])", "%1");
	local InitFile = ReadFile(Path:gsub("l%.mfk", "i.mfk")):gsub("//.-([\r\n])", "%1");
	for i = MissionMin,MissionMax do
		if MissionModules.Mission[i] then
			for k,v in pairs(MissionModules.Mission[i]) do
				DebugPrint("Running module: " .. k, 2)
				LoadFile, InitFile = v(LoadFile, InitFile, level, mission, Path, misstype)
			end
		end
	end
	MissionInit = InitFile
	if Settings.DebugLevel >= 5 then
		DebugPrint("Mission Load File:\r\n" .. LoadFile)
		DebugPrint("Mission Init File:\r\n" .. InitFile)
	end
	Output(LoadFile)
end