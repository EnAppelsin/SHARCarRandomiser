local table_remove = table.remove

local FixCartune = Module("Fix Cartune", nil, 0)

FixCartune:AddSPTHandler("sound/scripts/car_tune.spt", function(Path, SPTFile)
	for carSoundParameters in SPTFile:GetClasses("carSoundParameters") do
		for variable, index in carSoundParameters:GetVariables(true) do
			local name = variable.Name
			if name == "SetEngineClipName" or name == "SetEngineIdleClipName" then
				local clipNameArgument = variable.Arguments[1]
				if clipNameArgument.Value == "tt" then
					clipNameArgument.Value = "apu_car"
				end
			elseif name == "SetOverlayClipName" then
				local clipName = variable.Arguments[1].Value
				if clipName == "" or clipName == "generator" then
					carSoundParameters:RemoveVariable(index)
				end
			end
		end
	end
	
	return true
end)

return FixCartune