local table_remove = table.remove

local RemoveMissionLocks = Module("Remove Mission Locks", "RemoveMissionLocks", 1000)

local function RemoveLocks(LevelNumber, MissionNumber, MissionLoad, MissionInit)
	local functions = MissionInit.functions
	local toRemove = {}
	local toRemoveN = 0
	
	local previousLocked = false
	local remove = false
	for i=1,#functions do
		local func = functions[i]
		local name = func.Name:lower()
		
		if name == "addstage" then
			if previousLocked then
				remove = true
				previousLocked = false
			elseif func.Arguments[1] == "locked" then
				func.Arguments = {}
				previousLocked = true
			end
		end
		
		if remove then
			toRemoveN = toRemoveN + 1
			toRemove[toRemoveN] = i
			
			if name == "closestage" then
				remove = false
			end
		end
	end
	
	for i=toRemoveN,1,-1 do
		table.remove(functions, toRemove[i])
	end
	
	return toRemoveN > 0
end

RemoveMissionLocks:AddSundayDriveHandler(RemoveLocks)
RemoveMissionLocks:AddMissionHandler(RemoveLocks)

return RemoveMissionLocks