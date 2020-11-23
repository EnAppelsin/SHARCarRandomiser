MissionModules = {}
MissionModules.Level = {}
MissionModules.Mission = {}
MissionModules.SundayDrive = {}

MissionType = 
{
	Normal = 1,
	Race = 2,
	BonusMission = 3,
	GamblingRace = 4
}

local ModuleFiles = {}
GetFiles(ModuleFiles, Paths.MissionModules, {".lua"}, 1)
for i=1, #ModuleFiles do
	DebugPrint("Loading module: " .. ModuleFiles[i], 2)
	assert(loadfile(ModuleFiles[i]))(MissionModules)
end

LevelMin = 0
LevelMax = 0
MissionMin = 0
MissionMax = 0
SundayMin = 0
SundayMax = 0
for k,_ in pairs(MissionModules.Level) do
	local i = tonumber(k)
	if LevelMin == 0 then
		LevelMin = i
	else
		LevelMin = math.min(LevelMin, i)
	end
	if LevelMax == 0 then
		LevelMax = i
	else
		LevelMax = math.max(LevelMax, i)
	end
end
for k,_ in pairs(MissionModules.Mission) do
	local i = tonumber(k)
	if MissionMin == 0 then
		MissionMin = i
	else
		MissionMin = math.min(MissionMin, i)
	end
	if MissionMax == 0 then
		MissionMax = i
	else
		MissionMax = math.max(MissionMax, i)
	end
end
for k,_ in pairs(MissionModules.SundayDrive) do
	local i = tonumber(k)
	if SundayMin == 0 then
		SundayMin = i
	else
		SundayMin = math.min(SundayMin, i)
	end
	if SundayMax == 0 then
		SundayMax = i
	else
		SundayMax = math.max(SundayMax, i)
	end
end

if Settings.IsSeeded then
	DebugPrint("Generating seeded mission scripts")
	Seed.CacheModulesMission()
end
