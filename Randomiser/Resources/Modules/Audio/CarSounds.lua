local math_random = math.random

local RandomCarSounds = Module("Random Car Sounds", "RandomCarSounds")

RandomCarSounds:AddSPTHandler("sound/scripts/car_tune.spt", function(Path, SPT)
	local EngineNoisesMap = {}
	local EngineNoises = {}
	local EngineNoisesN = 0
	
	local HornNoisesMap = {}
	local HornNoises = {}
	local HornNoisesN = 0
	
	local OverlayNoisesMap = {}
	local OverlayNoises = {}
	local OverlayNoisesN = 0
	
	for carSoundParameters in SPT:GetClasses("carSoundParameters") do
		for method, index in carSoundParameters:GetMethods(true) do
			local name = method.Name
			if name == "SetEngineClipName" or name == "SetEngineIdleClipName" or name == "SetDamagedEngineClipName" then
				local engineNoise = method.Parameters[1]
				if not EngineNoisesMap[engineNoise] then
					EngineNoisesMap[engineNoise] = true
					
					EngineNoisesN = EngineNoisesN + 1
					EngineNoises[EngineNoisesN] = engineNoise
				end
			elseif name == "SetHornClipName" then
				local hornNoise = method.Parameters[1]
				if not HornNoisesMap[hornNoise] then
					HornNoisesMap[hornNoise] = true
					
					HornNoisesN = HornNoisesN + 1
					HornNoises[HornNoisesN] = hornNoise
				end
			elseif name == "SetOverlayClipName" then
				local overlayNoise = method.Parameters[1]
				if not OverlayNoisesMap[overlayNoise] then
					OverlayNoisesMap[overlayNoise] = true
					
					OverlayNoisesN = OverlayNoisesN + 1
					OverlayNoises[OverlayNoisesN] = overlayNoise
				end
			end
		end
		
	end
	
	for carSoundParameters in SPT:GetClasses("carSoundParameters") do
		local hasOverlay = false
		for method, index in carSoundParameters:GetMethods(true) do
			local name = method.Name
			if name == "SetEngineClipName" or name == "SetEngineIdleClipName" or name == "SetDamagedEngineClipName" then
				method.Parameters[1] = EngineNoises[math_random(EngineNoisesN)]
			elseif name == "SetHornClipName" then
				method.Parameters[1] = HornNoises[math_random(HornNoisesN)]
			elseif name == "SetOverlayClipName" then
				hasOverlay = true
				method.Parameters[1] = OverlayNoises[math_random(OverlayNoisesN)]
			end
		end
		if math.random(4) == 1 then -- 25% to have an overlay
			if not hasOverlay then
				carSoundParameters:AddMethod("SetOverlayClipName", {OverlayNoises[math_random(OverlayNoisesN)]})
			end
		else
			if hasOverlay then
				for SetOverlayClipName, Index in carSoundParameters:GetMethods(true, "SetOverlayClipName") do
					carSoundParameters:RemoveMethod(Index)
				end
			end
		end
	end
	
	return true
end)

return RandomCarSounds