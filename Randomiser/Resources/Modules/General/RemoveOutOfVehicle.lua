local table_remove = table.remove

local RemoveOutOfVehicle = Module("Remove Out Of Vehicle", "RemoveOutOfVehicle", 1000)

RemoveOutOfVehicle:AddMissionHandler(function(LevelNumber, MissionNumber, MissionLoad, MissionInit)
	local functions = MissionInit.Functions
	local toRemove = {}
	local toRemoveN = 0
	
	local remove = false
	for i=1,#functions do
		local func = functions[i]
		local name = func.Name:lower()
		
		if name == "addcondition" then
			if func.Arguments[1] == "outofvehicle" then
				remove = true
			end
		end
		
		if remove then
			toRemoveN = toRemoveN + 1
			toRemove[toRemoveN] = i
			
			if name == "closecondition" then
				remove = false
			end
		end
	end
	
	for i=toRemoveN,1,-1 do
		table_remove(functions, toRemove[i])
	end
	
	return toRemoveN > 0
end)

return RemoveOutOfVehicle