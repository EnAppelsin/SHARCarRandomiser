local FixAbductable = Module("Fix Abductable", nil, 1000)

local IsUFOPresent = false

local UFOBehaviours = {
	["UFO_ATTACK_ALL"] = true,
	["UFO_BEAM_ALWAYS_ON"] = true,
}
FixAbductable:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	IsUFOPresent = false
	
	for Function in LevelInit:GetFunctions("AddBehaviour") do
		if UFOBehaviours[Function.Arguments[2]] then
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
	
	for Function, Index in MissionInit:GetFunctions("AddStageVehicle", true) do
		changed = true
		
		MissionInit:InsertFunction(Index + 1, "SetStageVehicleAbductable", {Function.Arguments[1], "false"})
	end
	
	return changed
end
FixAbductable:AddSundayDriveHandler(MissionHandler)
FixAbductable:AddMissionHandler(MissionHandler)
FixAbductable:AddRaceHandler(MissionHandler)

return FixAbductable