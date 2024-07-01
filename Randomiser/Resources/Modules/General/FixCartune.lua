local table_remove = table.remove

local FixCartune = Module("Fix Cartune", nil, 2)

local LoadedSounds = {}

FixCartune:AddSPTHandler("*.spt", function(Path, SPT)
	for daSoundResourceData in SPT:GetClasses("daSoundResourceData") do
		LoadedSounds[daSoundResourceData.Name] = true
	end
	
	return false
end)

local DefaultEngine = "snake_car"
local DefaultDamagedEngine = "fire"
local DefaultHorn = "horn"
local RemoveIfNotLoaded = {
	["SetRoadSkidClipName"] = true,
	["SetDirtSkidClipName"] = true,
	["SetBackupClipName"] = true,
	["SetCarDoorOpenClipName"] = true,
	["SetCarDoorCloseClipName"] = true,
	["SetOverlayClipName"] = true,
}
FixCartune:AddSPTHandler("sound/scripts/car_tune.spt", function(Path, SPT)
	for carSoundParameters in SPT:GetClasses("carSoundParameters") do
		for method, index in carSoundParameters:GetMethods(true) do
			local name = method.Name
			if name == "SetEngineClipName" then
				if not LoadedSounds[method.Parameters[1]] then
					print(string.format("Replacing not-loaded engine sound \"%s\" with \"%s\".", method.Parameters[1], DefaultEngine))
					method.Parameters[1] = DefaultEngine
				end
			elseif name == "SetEngineIdleClipName" then
				if not LoadedSounds[method.Parameters[1]] then
					print(string.format("Replacing not-loaded idle engine sound \"%s\" with \"%s\".", method.Parameters[1], DefaultEngine))
					method.Parameters[1] = DefaultEngine
				end
			elseif name == "SetDamagedEngineClipName" then
				if not LoadedSounds[method.Parameters[1]] then
					print(string.format("Replacing not-loaded damaged engine sound \"%s\" with \"%s\".", method.Parameters[1], DefaultDamagedEngineEngine))
					method.Parameters[1] = DefaultDamagedEngine
				end
			elseif name == "SetHornClipName" then
				if not LoadedSounds[method.Parameters[1]] then
					print(string.format("Replacing not-loaded horn sound \"%s\" with \"%s\".", method.Parameters[1], DefaultHorn))
					method.Parameters[1] = DefaultHorn
				end
			elseif RemoveIfNotLoaded[name] then
				if not LoadedSounds[method.Parameters[1]] then
					print(string.format("Removing not-loaded sound \"%s\".", method.Parameters[1]))
					carSoundParameters:RemoveMethod(index)
				end
			end
		end
	end
	
	return true
end)

return FixCartune