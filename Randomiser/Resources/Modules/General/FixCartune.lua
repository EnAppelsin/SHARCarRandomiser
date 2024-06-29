local FixCartune = Module("Fix Cartune", nil, 0)

FixCartune:AddGenericHandler("sound/scripts/car_tune.spt", function(contents)
	-- Fix tt engine noise
	contents = contents:gsub("SetEngineClipName %( \"tt\" %)", "SetEngineClipName ( \"snake_car\" )")
	contents = contents:gsub("SetEngineIdleClipName %( \"tt\" %)", "SetEngineIdleClipName ( \"snake_car\" )")
	
	-- Fix empty overlay clip name
	contents = contents:gsub("\r\n    SetOverlayClipName %( \"\" %)", "")
	
	-- Fix non existent overlay clip name
	contents = contents:gsub("\r\n    SetOverlayClipName %( \"generator\" %)", "")
	
	return true, contents
end)

return FixCartune