if SettingRandomCarSounds then
	-- ENGINE LIST
	local RandomEnginePool = {}

	-- ENGINE IDLE LIST
	local RandomEngineIdlePool = {}

	-- DAMAGED ENGINE LIST
	local RandomDamagedEnginePool = {}

	-- HORN LIST
	local RandomHornPool = {}

	-- OVERLAY LIST
	local RandomOverlayPool = {}

	for engineClip in cartunespt:gmatch("SetEngineClipName%s*%(%s*\"(.-)\"") do
		if not ExistsInTbl(RandomEnginePool, engineClip, false) then
			table.insert(RandomEnginePool, engineClip)
		end
	end
	for engineIdleClip in cartunespt:gmatch("SetEngineIdleClipName%s*%(%s*\"(.-)\"") do
		if not ExistsInTbl(RandomEngineIdlePool, engineIdleClip, false) then
			table.insert(RandomEngineIdlePool, engineIdleClip)
		end
	end
	for damagedEngineClip in cartunespt:gmatch("SetDamagedEngineClipName%s*%(%s*\"(.-)\"") do
		if not ExistsInTbl(RandomDamagedEnginePool, damagedEngineClip, false) then
			table.insert(RandomDamagedEnginePool, damagedEngineClip)
		end
	end
	for hornClip in cartunespt:gmatch("SetHornClipName%s*%(%s*\"(.-)\"") do
		if not ExistsInTbl(RandomHornPool, hornClip, false) then
			table.insert(RandomHornPool, hornClip)
		end
	end
	for overlay in cartunespt:gmatch("SetOverlayClipName%s*%(%s*\"(.-)\"") do
		if not ExistsInTbl(RandomOverlayPool, overlay, false) then
			table.insert(RandomOverlayPool, overlay)
		end
	end

    cartunespt = string.gsub(cartunespt, "SetEngineClipName%s*%(%s*\".-\"", function()
        local engine = RandomEnginePool[math.random(#RandomEnginePool)]
        return "SetEngineClipName ( \"" .. engine .. "\""
    end)
    cartunespt = string.gsub(cartunespt, "SetEngineIdleClipName%s*%(%s*\".-\"", function()
        local engineIdle = RandomEngineIdlePool[math.random(#RandomEngineIdlePool)]
        return "SetEngineIdleClipName ( \"" .. engineIdle .. "\""
    end)
    cartunespt = string.gsub(cartunespt, "SetDamagedEngineClipName%s*%(%s*\".-\"", function()
        local damagedEngine = RandomDamagedEnginePool[math.random(#RandomDamagedEnginePool)]
        return "SetDamagedEngineClipName ( \"" .. damagedEngine .. "\""
    end)
    cartunespt = string.gsub(cartunespt, "SetHornClipName%s*%(%s*\".-\"", function()
        local horn = RandomHornPool[math.random(#RandomHornPool)]
        return "SetHornClipName ( \"" .. horn .. "\""
    end)
    cartunespt = string.gsub(cartunespt, "{(.-)}", function(orig)
        local overlay = RandomOverlayPool[math.random(#RandomOverlayPool)]
        if string.match(orig, "SetOverlayClipName%s*%(%s*\".-\"") then
            orig = string.gsub(orig, "SetOverlayClipName%s*%(%s*\".-\"", "SetOverlayClipName ( \"" .. overlay .. "\"")
        elseif math.random() >= 0.5 then
            --Removed because it appears that if too many cars with an overlay load, it crashes
            --orig = orig .. "    SetOverlayClipName ( \"" .. overlay .. "\" )\r\n"
        end
		return "{" .. orig .. "}"
    end)
end
