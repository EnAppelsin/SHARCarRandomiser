MissionModules = {}
MissionModules.Level = {}
MissionModules.Mission = {}
MissionModules.SundayDrive = {}

local ModuleFiles = {}
GetFiles(ModuleFiles, Paths.MissionModules, {".lua"}, 1)
for i=1, #ModuleFiles do
	loadfile(ModuleFiles[i])(MissionModules)
end