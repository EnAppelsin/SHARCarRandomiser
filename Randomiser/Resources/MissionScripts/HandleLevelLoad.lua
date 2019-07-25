-- Load the file
local Path = "/GameData/" .. GetPath();
local File = ReadFile(Path):gsub("//.-([\r\n])", "%1");

local level = tonumber(Path:match("level0(%d)"))
DebugPrint("NEW LEVEL LOAD: Level " .. level)
if SettingRandomMissions then
	DebugPrint("Randomising mission order")
	local missions = {}
	for mission in File:gmatch("AddMission%s*%(%s*\"m(%d)\"") do
		if tonumber(mission) < 8 then
			table.insert(missions, mission)
		end
	end
	File = File:gsub("AddMission%s*%(%s*\"m(%d)\"", function(orig)
		local mission = tonumber(orig)
		if mission < 8 then
			local tmp = {table.unpack(missions)}
			local exists = ExistsInTbl(tmp, orig, false)
			if exists then
				if #tmp > 1 then
					for i = #tmp, 1, -1 do
						if tmp[i] == orig then
							table.remove(tmp, i)
							break
						end
					end
				end
			end
			local newMission = GetRandomFromTbl(tmp, true)
			if exists then
				table.insert(tmp, orig)
			end
			missions = {table.unpack(tmp)}
			DebugPrint("Randomised mission " .. orig .. " to " .. newMission, 1)
			return "AddMission(\"m" .. newMission .. "\""
		else
			return "AddMission(\"m" .. orig .. "\""
		end
	end)
end
if SettingRandomInteriors then
	if level == 1 then
		DebugPrint("Setting up random interiors for level 1")
		interiorReplace = {}
		local tmpl1interiors = {table.unpack(l1interiors)}
		for i = 1, #l1interiors do
			interiorReplace[l1interiors[i]] = GetRandomFromTbl(tmpl1interiors, true)
		end
	elseif level == 2 then
		DebugPrint("Setting up random interiors for level 2")
		interiorReplace = {}
		local tmpl2interiors = {table.unpack(l2interiors)}
		for i = 1, #l2interiors do
			interiorReplace[l2interiors[i]] = GetRandomFromTbl(tmpl2interiors, true)
		end
	elseif level == 3 then
		DebugPrint("Setting up random interiors for level 3")
		interiorReplace = {}
		local tmpl3interiors = {table.unpack(l3interiors)}
		for i = 1, #l3interiors do
			interiorReplace[l3interiors[i]] = GetRandomFromTbl(tmpl3interiors, true)
		end
	elseif level == 4 then
		DebugPrint("Setting up random interiors for level 4")
		interiorReplace = {}
		local tmpl4interiors = {table.unpack(l4interiors)}
		for i = 1, #l4interiors do
			interiorReplace[l4interiors[i]] = GetRandomFromTbl(tmpl4interiors, true)
		end
	elseif level == 5 then
		DebugPrint("Setting up random interiors for level 5")
		interiorReplace = {}
		local tmpl5interiors = {table.unpack(l5interiors)}
		for i = 1, #l5interiors do
			interiorReplace[l5interiors[i]] = GetRandomFromTbl(tmpl5interiors, true)
		end
	elseif level == 6 then
		DebugPrint("Setting up random interiors for level 6")
		interiorReplace = {}
		local tmpl6interiors = {table.unpack(l6interiors)}
		for i = 1, #l6interiors do
			interiorReplace[l6interiors[i]] = GetRandomFromTbl(tmpl6interiors, true)
		end
	elseif level == 7 then
		DebugPrint("Setting up random interiors for level 7")
		interiorReplace = {}
		local tmpl7interiors = {table.unpack(l7interiors)}
		for i = 1, #l7interiors do
			interiorReplace[l7interiors[i]] = GetRandomFromTbl(tmpl7interiors, true)
		end
	end
	local oldName
	local newName
	for k,v in pairs(interiorReplace) do
		oldName = interiorNames[k]
		newName = interiorNames[v]
		DebugPrint("Replacing " .. oldName .. " with " .. newName .. " for random interiors")
		File = File:gsub("GagSetInterior%s*%(%s*\"" .. oldName .. "\"", "GagSetInterior(\"" .. newName .. "\"")
	end
end
if SettingRandomPlayerVehicles then
	LastLevel = nil
	RandomCar = math.random(#RandomCarPoolPlayer)
	RandomCarName = RandomCarPoolPlayer[RandomCar]
	File = File:gsub("(.*)LoadDisposableCar%s*%(%s*\"[^\n]-\"%s*,%s*\".-\"%s*,%s*\"DEFAULT\"%s*%);", "%1LoadDisposableCar(\"art\\cars\\" .. RandomCarName .. ".p3d\",\"" .. RandomCarName .. "\",\"DEFAULT\");", 1)
	DebugPrint("Randomising car for level (load) -> " .. RandomCarName)
end
if SettingRandomMissionVehicles then
	LastLevelMV = nil
end
if SettingRandomTraffic then
	TrafficCars = {}
	local TmpCarPool = {table.unpack(RandomCarPoolTraffic)}
	local Cars = ""
	for i = 1, math.min(5, #TmpCarPool) do
		local carName = GetRandomFromTbl(TmpCarPool, true)
		table.insert(TrafficCars, carName)
		Cars = Cars .. carName .. ", "
	end
	for i = 1, #TrafficCars do
		local carName = TrafficCars[i]
		File = File .. "\r\nLoadP3DFile(\"art\\cars\\" .. carName .. ".p3d\");"
	end
	File = File:gsub("SuppressDriver%s*%(\"([^\n]-)\"%s*%);", "//SuppressDriver(\"%1\");")
	DebugPrint("Random traffic cars for level -> " .. Cars)
end
if SettingRandomChase then
	RandomChase = GetRandomFromTbl(RandomCarPoolChase, false)
	File = File .. "\r\nLoadP3DFile(\"art\\cars\\" .. RandomChase .. ".p3d\");"
	DebugPrint("Random chase cars for level -> " .. RandomChase)
end
if SettingRandomMissionVehicles then
	LastLevelMV = nil
end

Output(File)