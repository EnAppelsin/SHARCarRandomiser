Settings = GetSettings()

Paths = {}
Paths.ModPath = GetModPath()
Paths.Resources = Paths.ModPath .. "/Resources/"
Paths.MissionModules = Paths.Resources .. "MissionModules/"
dofile(Paths.Resources .. "GlobalArrays.lua")
dofile(Paths.Resources .. "GlobalVariables.lua")
dofile(Paths.Resources .. "GlobalFunctions.lua")
dofile(Paths.Resources .. "lib/P3D.lua")
dofile(Paths.Resources .. "lib/P3DFunctions.lua")
dofile(Paths.Resources .. "lib/Seed.lua")

GetFiles(RandomCharP3DPool, "/GameData/art/chars/", {".p3d"})
local ExcludedChars = {["npd_m"]=true,["ndr_m"]=true,["nps_m"]=true}
for i=#RandomCharP3DPool,1,-1 do
	local fName = RemoveFileExtension(GetFileName(RandomCharP3DPool[i]))
	if fName:sub(-2) ~= "_m" or ExcludedChars[fName] then
		table.remove(RandomCharP3DPool, i)
	else
		local compName = P3D.CleanP3DString(GetCompositeDrawableName(ReadFile(RandomCharP3DPool[i])))
		if compName:sub(-2) == "_h" then
			RandomPedPool[#RandomPedPool + 1] = compName:sub(1, -3)
		end
	end
end
RandomPedPoolN = #RandomPedPool

if Settings.SpeedrunMode then
	--Force on
	Settings.RandomPlayerVehicles = true
	Settings.RandomTraffic = true
	Settings.RandomChase = true
	Settings.RandomChaseAmount = true
	Settings.RandomChaseStats = true
	Settings.RandomMissionVehicles = true
	Settings.RandomMissionVehiclesStats = true
	Settings.RandomStaticCars = true
	Settings.SaveChoiceRSC = true
	
	--Force off
	Settings.RemoveOutOfCar = false
	Settings.CustomCars = false
	
	-- Remove Husks
	table.remove(RandomCarPoolPlayer, #RandomCarPoolPlayer)
	table.remove(RandomCarPoolTraffic, #RandomCarPoolTraffic)
	table.remove(RandomCarPoolMission, #RandomCarPoolMission)
	table.remove(RandomCarPoolChase, #RandomCarPoolChase)
	
	DebugPrint("Speedrun mode enabled, settings have been overridden")
end

if Settings.IsSeeded then
	Seed.Init()
end

if Settings.UseDebugSettings then
	if not Confirm("You have Use Debug Settings enabled. This allows a secondary mod to force certain randomisations and sometimes run code.\nAre you sure you want this enabled?") then
		Settings.UseDebugSettings = false
	elseif Exists("/GameData/RandomiserSettings/CustomFiles.lua", true, false) then
		dofile("/GameData/RandomiserSettings/CustomFiles.lua")
	end
end

DebugPrint("Debug settings enabled: " .. (Settings.UseDebugSettings and "true" or "false"))

if Settings.VerboseDebug then
	local OldOutput = Output
	local OldRedirect = Redirect

	Output = function(data)
		print("!! Output File for " .. GetPath())
		print("!! " .. base64(data))
		return OldOutput(data)
	end

	Redirect = function(name)
		print("!? Redirect " .. GetPath() .. " -> " .. name)
		return OldRedirect(name)
	end
end

DebugPrint("Randomiser Settings", 2)
for settingName, settingValue in pairs(Settings) do
	DebugPrint("- " .. settingName .. " = " .. tostring(settingValue), 2)
end

if Settings.CustomCars then
	dofile(Paths.Resources .. "CustomCars.lua")
end

if Settings.CustomChars then
	dofile(Paths.Resources .. "CustomChars.lua")
end

dofile(Paths.Resources .. "RandomCarTune.lua")
if Settings.RandomDialogue then
	dofile(Paths.Resources .. "RandomDialogue.lua")
end

if #RandomCarPoolPlayer < 5 and Settings.RandomPlayerVehicles then
	Alert("You have chosen less than 5 cars for the random player pool. You must choose at least 5 cars.")
	os.exit()
elseif #RandomCarPoolTraffic < 5 and Settings.RandomTraffic then
	Alert("You have chosen less than 5 cars for the random traffic pool. You must choose at least 5 cars.")
	os.exit()
elseif #RandomCarPoolMission < 5 and Settings.RandomMissionVehicles then
	Alert("You have chosen less than 5 cars for the random mission pool. You must choose at least 5 cars.")
	os.exit()
elseif #RandomCarPoolChase < 5 and Settings.RandomChase then
	Alert("You have chosen less than 5 cars for the random chase pool. You must choose at least 5 cars.")
	os.exit()
end

DebugPrint("Loaded " .. #RandomCarPoolPlayer .. " cars for the random Player pool")
DebugPrint("Loaded " .. #RandomCarPoolTraffic .. " cars for the random Traffic pool")
DebugPrint("Loaded " .. #RandomCarPoolMission .. " cars for the random Mission pool")
DebugPrint("Loaded " .. #RandomCarPoolChase .. " cars for the random Chase pool")
DebugPrint("Using " .. RandomPedPoolN .. " pedestrians")
DebugPrint("Using " .. #RandomCharP3DPool .. " characters")

dofile(Paths.Resources .. "MissionScripts/LoadModules.lua")

-- Seed.NonModuleSeed
if Settings.IsSeeded then
	Seed.PrintSpoiler()
end
Cache = {}

