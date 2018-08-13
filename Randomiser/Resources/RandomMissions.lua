if SettingRandomMissions then
	--DebugPrint("Randomising mission order")
	--local rootPath = "/GameData/scripts/missions/level0"
	--for i = 1, 7 do
	--	local levelFile = ReadFile(rootPath .. i .. "/level.mfk")
	--	local missions = {}
	--	for mission in levelFile:gmatch("AddMission%s*%(%s*\"m(%d)\"") do
	--		if tonumber(mission) < 8 then
	--			table.insert(missions, mission)
	--		end
	--	end
	--	local missionsN = #missions
	--	if missionsN > 0 then
	--		missionOrder[i] = {}
	--		for j = 1, missionsN do
	--			missionOrder[i][j] = GetRandomFromTbl(missions, true)
	--		end
	--	end
	--end
	
	dialogspt = dialogspt:gsub("L(%d)M%d", "L%1")
	
	--for i = 1, #missionOrder do
	--	for j = 1, #missionOrder[i] do
	--		DebugPrint("Level " .. i .. " Mission " .. j .. " = " .. missionOrder[i][j], 2)
	--	end
	--end
end