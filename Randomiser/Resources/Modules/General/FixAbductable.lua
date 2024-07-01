local FixAbductable = Module("Fix Abductable", nil, 1000)

local IsUFOPresent = false

local UFOBehaviours = {
	["UFO_ATTACK_ALL"] = true,
	["UFO_BEAM_ALWAYS_ON"] = true,
}
FixAbductable:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	IsUFOPresent = false
	
	local functions = LevelInit.Functions
	for i=1,#functions do
		local func = functions[i]
		if func.Name:lower() == "addbehaviour" and UFOBehaviours[func.Arguments[2]] then
			IsUFOPresent = true
			break
		end
	end
	
	return false
end)

local function MissionHandler(LevelNumber, MissionNumber, MissionLoad, MissionInit)
	if not IsUFOPresent then
		return false
	end
	
	local changed = false
	
	local functions = MissionInit.Functions
	for i=#functions,1,-1 do
		local func = functions[i]
		if func.Name:lower() == "addstagevehicle" then
			changed = true
			
			MissionInit:InsertFunction(i + 1, "SetStageVehicleAbductable", {func.Arguments[1], "false"})
		end
	end
	
	return changed
end
FixAbductable:AddSundayDriveHandler(MissionHandler)
FixAbductable:AddMissionHandler(MissionHandler)
FixAbductable:AddRaceHandler(MissionHandler)

return FixAbductable