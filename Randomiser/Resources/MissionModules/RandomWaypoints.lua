local args = {...}
local tbl = args[1]
if Settings.RandomWaypoints then
	GetRoads()
	
	local sort = 5
	local Mission = {}
	if not tbl.Mission[sort] then
		tbl.Mission[sort] = Mission
	else
		Mission = tbl.Mission[sort]
	end
	
	function Mission.RandomWaypoints(LoadFile, InitFile, Level, Mission, Path, IsRace)
		if not IsRace then
			Waypoints = {}
			local WaypointN = 0
			for waypoint in InitFile:gmatch("AddStageWaypoint%s*%(%s*\"([^\n]-)\"") do
				Waypoints[waypoint] = true
				WaypointN = WaypointN + 1
			end
			for waypoint in InitFile:gmatch("AddCollectible%s*%(%s*\"([^\n]-)\"") do
				Waypoints[waypoint] = true
				WaypointN = WaypointN + 1
			end
			for waypoint in InitFile:gmatch("SetDestination%s*%(%s*\"([^\n]-)\"") do
				Waypoints[waypoint] = true
				WaypointN = WaypointN + 1
			end
			for waypoint in InitFile:gmatch("AddCollectibleStateProp%s*%(%s*\"[^\n]-\"%s*,%s*\"([^\n]-)\"") do
				Waypoints[waypoint] = true
				WaypointN = WaypointN + 1
			end
			if WaypointN > 0 then
				InitFile = InitFile:gsub("SetStageTime%s*%(%s*%d*%s*%);", "")
				InitFile = InitFile:gsub("AddStageTime%s*%(%s*%d*%s*%);", "")
				local types = {["followdistance"] = true, ["timeout"] = true}
				InitFile = InitFile:gsub("AddCondition%s*%(%s*\"([^\n]-)\"%s*%);.-CloseCondition%s*%(%s*%);", function(type)
					if types[type] then return "" end
				end)
				InitFile = InitFile:gsub("SetDestination%s*%(%s*\"([^\n]-)\"%s*%);", function(arg)
					if not arg:find("\"") then return "SetDestination(\"" .. arg .. "\",\"carsphere\");" end
				end)
				DebugPrint("Found " .. WaypointN .. " waypoints in L" .. Level .. "M" .. Mission .. ".")
			end
		end
		return LoadFile, InitFile
	end
end