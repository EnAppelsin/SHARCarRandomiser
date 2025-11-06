local FixMonorail = Module("Fix Book Burning Van", nil, 1)

FixMonorail:AddSPTHandler("sound/scripts/car_tune.spt", function(Path, SPT)
	local monorailCarSoundParameters = SPT:GetClass("carSoundParameters", false, "mono_v")
	if not monorailCarSoundParameters then
		return false
	end
	
	local overlayClipMethod = monorailCarSoundParameters:GetMethod(false, "SetOverlayClipName")
	if not overlayClipMethod then
		return false
	end
	
	overlayClipMethod.Parameters[1] = "mono_overlay"
	
	return true
end)

return FixMonorail