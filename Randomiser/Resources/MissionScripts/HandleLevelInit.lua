-- Load the file
local Path = "/GameData/" .. GetPath();
local File = ReadFile(Path):gsub("//.-([\r\n])", "%1");

local level = tonumber(Path:match("level0(%d)"))
DebugPrint("NEW LEVEL INIT: Level " .. level)
if SettingRandomCharacter then
	OrigChar = File:match("AddCharacter%s*%(%s*\"([^\n]-)\"")
	--RandomChar = GetRandomFromTbl(RandomCharP3DPool, false)
end
if SettingRandomPlayerVehicles then
	File = File:gsub("InitLevelPlayerVehicle%s*%(%s*\".-\"%s*,%s*\"([^\n]-)\"%s*,%s*\"DEFAULT\"%s*%)", "InitLevelPlayerVehicle(\"" .. RandomCarName .. "\",\"%1\",\"DEFAULT\")", 1)
	DebugPrint("Randomising car for level -> " .. RandomCarName)
end
if SettingRandomPedestrians then
	local Peds = ""
	local TmpPedPool = {table.unpack(RandomPedPool)}
	local groups = {}
	for group in File:gmatch("CreatePedGroup%s*%(%s*(%d)%s*%);") do
		table.insert(groups, group)
	end
	local ret = ""
	for i = 1, #groups do
		local group = groups[i]
		DebugPrint("Randomising group " .. group)
		ret = ret .. "CreatePedGroup( " .. group .. " );\r\n"
		for i = 1, 7 do
			local pedName = GetRandomFromTbl(TmpPedPool, true)
			if not TmpPedPool or #TmpPedPool == 0 then
				TmpPedPool = {table.unpack(RandomPedPool)}
			end
			Peds = Peds .. pedName .. ", "
			ret = ret .. "AddPed(\"" .. pedName .. "\", 1);\r\n"
		end
		ret = ret .. "ClosePedGroup( );"
	end
	File = File:gsub("CreatePedGroup%s*%(%s*(%d)%s*%);(.*)ClosePedGroup%s*%(%s*%);", function(group, current)
		return ret
	end)
	LevelCharacters = {}
	for npc in File:gmatch("AddAmbientCharacter%s*%(%s*\"([^\n]-)\"") do
		table.insert(LevelCharacters, npc)
	end
	DebugPrint("Random pedestrians for level -> " .. Peds)
end
if SettingRandomMissionCharacters then
	BonusCharacters = {}
	for npc in File:gmatch("AddNPCCharacterBonusMission%s*%(%s*\"([^\n]-)\"") do
		table.insert(BonusCharacters, npc)
	end
end
if SettingRandomTraffic then
	RemovedTrafficCars = {}
	File = File:gsub("CreateTrafficGroup", "//CreateTrafficGroup", 1)
	File = File:gsub("AddTrafficModel%s*%(%s*\"(.-)\"", function(car)
		table.insert(RemovedTrafficCars, car)
		return "//AddTrafficModel(\"" .. car .. "\"" --( "minivanA"
	end)
	File = File:gsub("CloseTrafficGroup", "//CloseTrafficGroup", 1)
	File = File .. "\r\nCreateTrafficGroup( 0 );"
	for i = 1, #TrafficCars do
		local carName = TrafficCars[i]
		local amount = 1
		if i == 1 then
			if #TrafficCars == 4 then
				amount = 2
			elseif #TrafficCars == 3 then
				amount = 3
			elseif #TrafficCars == 2 then
				amount = 4
			elseif #TrafficCars == 1 then
				amount = 5
			end
		end
		File = File .. "\r\nAddTrafficModel( \"" .. carName .. "\"," .. amount .. " );"
	end
	File = File .. "\r\nCloseTrafficGroup( );"
end
if SettingRandomChase then
	if SettingRandomChaseStats or SettingRandomStats then
		File = File:gsub("CreateChaseManager%s*%(%s*\"[^\n]-\"%s*,%s*\"[^\n]-\"", "CreateChaseManager(\"" .. RandomChase .."\",\"" .. RandomChase .. ".con\"", 1)
	else
		File = File:gsub("CreateChaseManager%s*%(%s*\"[^\n]-\"", "CreateChaseManager(\"" .. RandomChase .."\"", 1)
	end
	if SettingRandomChaseAmount then
		local chaseAmount = math.random(1, 5)
		File = File:gsub("SetNumChaseCars%s*%(%s*\"[^\n]-\"", "SetNumChaseCars(\"" .. chaseAmount .."\"", 1)
		DebugPrint("Random chase amount -> " .. chaseAmount)
	end
end

Output(File)