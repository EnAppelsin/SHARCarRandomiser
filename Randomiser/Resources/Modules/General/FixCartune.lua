local table_remove = table.remove

local FixCartune = Module("Fix Cartune", nil, 0)

FixCartune:AddSPTHandler("sound/scripts/car_tune.spt", function(Path, SPTFile)
	local classes = SPTFile.Classes
	for i=1,#classes do
		local class = classes[i]
		local classType = class.Type
		if classType == "carSoundParameters" then
			local variables = class.Variables
			for j=#variables,1,-1 do
				local variable = variables[j]
				local variableName = variable.Name
				print(variableName)
				if variableName == "SetEngineClipName" or variableName == "SetEngineIdleClipName" then
					if variable.Arguments[1].Value == "tt" then
						variable.Arguments[1].Value = "snake_car"
					end
				elseif variableName == "SetOverlayClipName" then
					local clipName = variable.Arguments[1].Value
					if clipName == "" or clipName == "generator" then
						table_remove(variables, j)
					end
				end
			end
		end
	end
	
	return true
end)

return FixCartune