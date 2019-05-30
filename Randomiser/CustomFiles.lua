ModPath = GetModPath()
dofile(ModPath .. "/Resources/GlobalArrays.lua")
dofile(ModPath .. "/Resources/GlobalVariables.lua")
dofile(ModPath .. "/Resources/GlobalFunctions.lua")

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

DebugPrint("Randomiser Settings", 2)
for settingName, settingValue in pairs(GetSettings()) do
	DebugPrint("- " .. settingName .. " = " .. tostring(settingValue), 2)
end

DebugPrint("Loaded " .. #RandomCarPoolPlayer .. " cars for the random Player pool")
DebugPrint("Loaded " .. #RandomCarPoolTraffic .. " cars for the random Traffic pool")
DebugPrint("Loaded " .. #RandomCarPoolMission .. " cars for the random Mission pool")
DebugPrint("Loaded " .. #RandomCarPoolChase .. " cars for the random Chase pool")
DebugPrint("Using " .. RandomPedPoolN .. " pedestrians")

if SettingRandomInteriors then
	if not Confirm("Random Interiors is an experimental addition that can cause the game to be unplayable. If you want to disable this, press Cancel") then
		SettingRandomInteriors = false
	end
end

if SettingCustomCars then
	dofile(ModPath .. "/Resources/CustomCars.lua")
end

dofile(ModPath .. "/Resources/RandomCarTune.lua")
if SettingRandomDialogue then
	dofile(ModPath .. "/Resources/RandomDialogue.lua")
end

if SettingRandomMissions then
	dofile(ModPath .. "/Resources/RandomMissions.lua")
end