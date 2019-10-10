ModPath = GetModPath()
Paths = {}
Paths.ModPath = GetModPath()
Paths.Resources = Paths.ModPath .. "/Resources/"
Paths.MissionModules = Paths.Resources .. "MissionModules/"
dofile(Paths.Resources .. "GlobalArrays.lua")
dofile(Paths.Resources .. "GlobalVariables.lua")
dofile(Paths.Resources .. "GlobalFunctions.lua")
dofile(Paths.Resources .. "MissionScripts/LoadModules.lua")

if Settings.UseDebugSettings then
	if not Confirm("You have Use Debug Settings enabled. This allows a secondary mod to force certain randomisations and sometimes run code.\nAre you sure you want this enabled?") then
		Settings.UseDebugSettings = false
	elseif Exists("/GameData/RandomiserSettings/CustomFiles.lua", true, false) then
		dofile("/GameData/RandomiserSettings/CustomFiles.lua")
	end
end
DebugPrint("Debug settings enabled: " .. (Settings.UseDebugSettings and "true" or "false"))

if #RandomCarPoolPlayer < 5 and SettingRandomPlayerVehicles then
	Alert("You have chosen less than 5 cars for the random player pool. You must choose at least 5 cars.")
	os.exit()
elseif #RandomCarPoolTraffic < 5 and SettingRandomTraffic then
	Alert("You have chosen less than 5 cars for the random traffic pool. You must choose at least 5 cars.")
	os.exit()
elseif #RandomCarPoolMission < 5 and SettingRandomMissionVehicles then
	Alert("You have chosen less than 5 cars for the random mission pool. You must choose at least 5 cars.")
	os.exit()
elseif #RandomCarPoolChase < 5 and SettingRandomChase then
	Alert("You have chosen less than 5 cars for the random chase pool. You must choose at least 5 cars.")
	os.exit()
end

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

DebugPrint("Loaded " .. #RandomCarPoolPlayer .. " cars for the random Player pool")
DebugPrint("Loaded " .. #RandomCarPoolTraffic .. " cars for the random Traffic pool")
DebugPrint("Loaded " .. #RandomCarPoolMission .. " cars for the random Mission pool")
DebugPrint("Loaded " .. #RandomCarPoolChase .. " cars for the random Chase pool")
DebugPrint("Using " .. RandomPedPoolN .. " pedestrians")

if Settings.RandomInteriors then
	if not Confirm("Random Interiors is an experimental addition that can cause the game to be unplayable. If you want to disable this, press Cancel") then
		Settings.RandomInteriors = false
	end
end

if Settings.CustomCars then
	dofile(Paths.Resources .. "CustomCars.lua")
end

dofile(Paths.Resources .. "RandomCarTune.lua")
if Settings.RandomDialogue then
	dofile(Paths.Resources .. "RandomDialogue.lua")
end

if Settings.RandomMissions then
	dofile(Paths.Resources .. "RandomMissions.lua")
end