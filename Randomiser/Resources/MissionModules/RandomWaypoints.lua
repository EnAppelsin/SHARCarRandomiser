local args = {...}
local tbl = args[1]
if Settings.RandomWaypoints then
	local startTime = GetTime()
	RoadPositions = {}
	for i=1,7 do
		GetRoads(RoadPositions, i)
		local tbl = RoadPositions["L" .. i]
		local total = 0
		for j=1,#tbl do
			local road = tbl[j]
			total = total + road.Length
		end
		RoadPositions["L" .. i .. "Total"] = total
	end
	local endTime = GetTime()
	DebugPrint("Found " .. #RoadPositions.L1 .. " L1, " .. #RoadPositions.L2 .. " L2, " .. #RoadPositions.L3 .. " L3, " .. #RoadPositions.L4 .. " L4, " .. #RoadPositions.L5 .. " L5, " .. #RoadPositions.L6 .. " L6, " .. #RoadPositions.L7 .. " L7 in " .. (endTime - startTime) * 1000 .. "ms")
	
	local sort = 5
	local Mission = {}
	local SundayDrive = {}
	if not tbl.Mission[sort] then
		tbl.Mission[sort] = Mission
	else
		Mission = tbl.Mission[sort]
	end
	
	function Mission.RandomWaypoints(LoadFile, InitFile, Level, Mission, Path, IsRace)
		if not IsRace then
			Waypoints = {}
			for waypoint in InitFile:gmatch("AddStageWaypoint%s*%(%s*\"([^\n]-)\"") do
				Waypoints[waypoint] = true
			end
			for waypoint in InitFile:gmatch("AddCollectible%s*%(%s*\"([^\n]-)\"") do
				Waypoints[waypoint] = true
			end
			InitFile = InitFile:gsub("SetStageTime%s*%(%s*%d*%s*%);", "")
			InitFile = InitFile:gsub("AddStageTime%s*%(%s*%d*%s*%);", "")
			local types = {["followdistance"] = true, ["timeout"] = true}
			InitFile = InitFile:gsub("AddCondition%s*%(%s*\"([^\n]-)\"%s*%);.-CloseCondition%s*%(%s*%);", function(type)
				if types[type] then return "" end
			end)
		end
		return LoadFile, InitFile
	end
end