local table_remove = table.remove

local FixCartune = Module("Fix Cartune", nil, 1)

FixCartune:AddSPTHandler("sound/scripts/car_tune.spt", function(Path, SPT)
	for carSoundParameters in SPT:GetClasses("carSoundParameters") do
		for method, index in carSoundParameters:GetMethods(true) do
			local name = method.Name
			if name == "SetEngineClipName" or name == "SetEngineIdleClipName" then
				if method.Parameters[1] == "tt" then
					method.Parameters[1] = "apu_car"
				end
			elseif name == "SetOverlayClipName" then
				local clipName = method.Parameters[1]
				if clipName == "" or clipName == "generator" then
					carSoundParameters:RemoveMethod(index)
				end
			end
		end
	end
	
	return true
end)

return FixCartune