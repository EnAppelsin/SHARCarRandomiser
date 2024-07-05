local math_random = math.random
local table_remove = table.remove
local table_unpack = table.unpack

local RandomDrivers = Module("Random Drivers", "RandomDrivers", 10)

RandomDrivers:AddCONHandler("*.con", function(Path, CON)
	if WildcardMatch(Path, "scripts/cars/*husk*.con", true, true) then
		return false
	end
	local randomDriver = CharNames[math_random(CharCount)]
	print("Setting driver to \"" .. randomDriver .. "\" for: " .. Path)
	
	if not CON:SetAll("SetDriver", 1, randomDriver) then
		CON:AddFunction("SetDriver", randomDriver)
	end
	
	return true
end)

local DriverFunctions = {
	["activatevehicle"] = 4,
	["addstagevehicle"] = 5,
}

local CarDrivers = {
	["apu"] = {"apu_v"},
	["bart"] = {"bart_v", "honor_v"},
	["cletus"] = {"cletu_v"},
	["cbg"] = {"comic_v"},
	["lisa"] = {"elect_v", "lisa_v"},
	["homer"] = {"famil_v", "homer_v"},
	["frink"] = {"frink_v"},
	["grandpa"] = {"gramp_v", "gramR_v"},
	["marge"] = {"marge_v"},
	["otto"] = {"otto_v"},
	["skinner"] = {"skinn_m1", "skinn_v"},
	["smithers"] = {"smith_v"},
	["snake"] = {"snake_v"},
	["wiggum"] = {"wiggu_v"},
	["zmale1"] = {"zombi_v"},
}

local function MissionDrivers(LevelNumber, MissionNumber, MissionLoad, MissionInit)
	local changed = false
	local driverPool = {table_unpack(CharNames)}
	for Function in MissionInit:GetFunctions("AddStageVehicle") do
		if CarDrivers[Function.Arguments[5]] then
			changed = true
			
			local randomDriverIndex = math_random(#driverPool)
			local randomDriver = driverPool[randomDriverIndex]
			table_remove(driverPool, randomDriverIndex)
			if #driverPool == 0 then
				driverPool = {table_unpack(CharNames)}
			end
			
			print("Setting driver to \"" .. randomDriver .. "\" for: " .. Function.Arguments[1])
			
			Function.Arguments[5] = randomDriver
		end
	end
	return changed
end

RandomDrivers:AddSundayDriveHandler(MissionDrivers)
RandomDrivers:AddMissionHandler(MissionDrivers)
RandomDrivers:AddRaceHandler(MissionDrivers)

return RandomDrivers