local args = {...}
local tbl = args[1]
if Settings.RandomUFOs then
	if not RoadPositions then
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
	end
	
	local sort = 5
	local Level = {}
	if not tbl.Level[sort] then
		tbl.Level[sort] = Mission
	else
		Level = tbl.Level[sort]
	end
	
	function Level.RandomUFO(LoadFile, InitFile, Level, Path)
		UFOs = {}
		for ufo in InitFile:gmatch("AddFlyingActorByLocator%s*%(%s*\"[^\n]-\"%s*,%s*\"[^\n]-\"%s*,%s*\"([^\n]-)\"") do
			UFOs[ufo] = true
		end
		return LoadFile, InitFile
	end
end