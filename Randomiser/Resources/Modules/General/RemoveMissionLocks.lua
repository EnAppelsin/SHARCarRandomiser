local RemoveMissionLocks = Module("Remove Mission Locks", "RemoveMissionLocks", 1000)

local function RemoveLocks(LevelNumber, MissionNumber, MissionLoad, MissionInit)
	local toRemove = {}
	local toRemoveN = 0
	
	local previousLocked = false
	local remove = false
	for Function, Index in MissionInit:GetFunctions() do
		local name = Function.Name:lower()
		
		if name == "addstage" then
			if previousLocked then
				remove = true
				previousLocked = false
			elseif Function.Arguments[1] == "locked" then
				Function.Arguments = {}
				previousLocked = true
			end
		end
		
		if remove then
			toRemoveN = toRemoveN + 1
			toRemove[toRemoveN] = Index
			
			if name == "closestage" then
				remove = false
			end
		end
	end
	
	for i=toRemoveN,1,-1 do
		MissionInit:RemoveFunction(toRemove[i])
	end
	
	return toRemoveN > 0
end

RemoveMissionLocks:AddSundayDriveHandler(RemoveLocks)
RemoveMissionLocks:AddMissionHandler(RemoveLocks)

return RemoveMissionLocks