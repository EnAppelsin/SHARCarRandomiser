-- Load the file
local Path = "/GameData/" .. GetPath();
local File = ReadFile(Path):gsub("//.-([\r\n])", "%1");

local level = tonumber(Path:match("level0(%d)"))
local mission = tonumber(Path:match("m(%d)sdl"))
DebugPrint("NEW SD LOAD: Level " .. level .. ", Mission " .. mission)
if SettingRandomMissionVehicles then
	LastLevelMV = nil
end
if SettingRandomDirectives then
	iconReplace = {}
	File = File:gsub("LoadP3DFile%s*%(%s*\"art\\frontend\\dynaload\\images\\msnicons([^\n]-)%.p3d\"%s*", function(orig)
		local rand = GetRandomFromTbl(IconP3DPool, false)
		local origName = orig:sub(findLast(orig, "\\") + 1)
		local randName = rand:sub(findLast(rand, "\\") + 1)
		iconReplace[origName] = randName
		DebugPrint("Replacing directive icon " .. origName .. " with " .. randName)
		return "LoadP3DFile(\"art\\frontend\\dynaload\\images\\msnicons" .. rand .. ".p3d\""
	end)
end
LastLevel = nil
PlayerStats = nil
	
Output(File)