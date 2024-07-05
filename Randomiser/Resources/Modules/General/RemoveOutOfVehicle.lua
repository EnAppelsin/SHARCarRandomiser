local table_remove = table.remove

local RemoveOutOfVehicle = Module("Remove Out Of Vehicle", "RemoveOutOfVehicle", 1000)

RemoveOutOfVehicle:AddMissionHandler(function(LevelNumber, MissionNumber, MissionLoad, MissionInit)
	local toRemove = {}
	local toRemoveN = 0
	
	local remove = false
	for Function, Index in MissionInit:GetFunctions() do
		local name = Function.Name:lower()
		
		if name == "addcondition" then
			if Function.Arguments[1] == "outofvehicle" then
				remove = true
			end
		end
		
		if remove then
			toRemoveN = toRemoveN + 1
			toRemove[toRemoveN] = Index
			
			if name == "closecondition" then
				remove = false
			end
		end
	end
	
	for i=toRemoveN,1,-1 do
		MissionInit:RemoveFunction(toRemove[i])
	end
	
	return toRemoveN > 0
end)

return RemoveOutOfVehicle