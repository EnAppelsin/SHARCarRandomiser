local FixBookBurningVan = Module("Fix Book Burning Van", nil, 1)

FixBookBurningVan:AddSPTHandler("sound/scripts/car_tune.spt", function(Path, SPT)
	local bookbVCarSoundParameters = SPT:GetClass("carSoundParameters", false, "bookb_v")
	if not bookbVCarSoundParameters then
		return false
	end
	
	local overlayClipMethod = bookbVCarSoundParameters:GetMethod(false, "SetOverlayClipName")
	if not overlayClipMethod then
		return false
	end
	
	overlayClipMethod.Parameters[1] = "book_fire"
	
	return true
end)

FixBookBurningVan:AddSPTHandler("sound/scripts/bookb_v.spt", function(Path, SPT)
	local class = SPTParser.Class("daSoundResourceData", "book_fire")
	class:AddMethod("AddFilename", { "sound\\carsound\\book_fire.rsd", 1.0 })
	class:AddMethod("SetLooping", { true })
	class:AddMethod("SetTrim", { 1.0 })
	class:AddMethod("SetStreaming", { true })

	SPT.Classes[#SPT.Classes + 1] = class
	
	return true
end)

return FixBookBurningVan