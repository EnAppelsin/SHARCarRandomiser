local math_random = math.random
local table_remove = table.remove

local RandomMissionVehicle = Module("Random Mission Vehicle", "RandomMissionVehicle", 3)

RandomMissionVehicle:AddMissionHandler(function(LevelNumber, MissionNumber, MissionLoad, MissionInit)
	-- TODO: Save on reload if some setting enabled or something
	
	local RandomVehicleIndex = math_random(CarCount)
	local RandomVehicleP3D = CarP3DFiles[RandomVehicleIndex]
	local RandomVehicleName = CarNames[RandomVehicleIndex]
	
	print("Setting mission vehicle to: " .. RandomVehicleName)
	
	local isForced = false
	local functions = MissionLoad.Functions
	
	for i=1,#functions do
		local func = functions[i]
		local name = func.Name:lower()
		if name == "loaddisposablecar" and func.Arguments[3] == "OTHER" then
			isForced = true
			func.Arguments[1] = RandomVehicleP3D
			func.Arguments[2] = RandomVehicleName
			break
		end
	end
	
	if isForced then
		MissionInit:SetAll("InitLevelPlayerVehicle", 1, RandomVehicleName)
	else
		local CarLocator
		local LastStageIndex
		local ResetToHereIndex
		local functions = MissionInit.Functions
		for i=1,#functions do
			local func = functions[i]
			local name = func.Name:lower()
			
			if name == "setmissionresetplayeroutcar" then
				CarLocator = func.Arguments[2]
			elseif name == "setmissionresetplayerincar" then
				CarLocator = func.Arguments[1]
			elseif name == "addstage" then
				LastStageIndex = i
			elseif name == "reset_to_here" then
				ResetToHereIndex = LastStageIndex
			end
			
			if CarLocator and ResetToHereIndex then
				break
			end
		end
		if not CarLocator then
			-- TODO: Is this even possible?
			print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
		end
		MissionInit:InsertFunction(2, "SetForcedCar")
		MissionInit:InsertFunction(2, "InitLevelPlayerVehicle", {RandomVehicleName, CarLocator, "OTHER"})
		
		local stageVehicles = {}
		local stageVehiclesN = 0
		
		if ResetToHereIndex then
			local remove = false
			for i=ResetToHereIndex+1,1,-1 do -- We want the function before AddStage. We've inserted 2. Add 1.
				local func = functions[i]
				local name = func.Name:lower()
				
				if name == "addstagevehicle" then
					stageVehiclesN = stageVehiclesN + 1
					stageVehicles[stageVehiclesN] = func.Arguments
				end
				
				if name == "closestage" then
					remove = true
				end
				
				if remove then
					table_remove(functions, i)
				end
				
				if name == "addstage" then
					remove = false
				end
			end
		end
		
		if stageVehiclesN > 0 then
			local Index
			for i=1,#functions do
				if functions[i].Name:lower() == "addstage" then
					Index = i
					break
				end
			end
			MissionInit:InsertFunction(Index, "AddStage")
			Index = Index + 1
			for i=1,stageVehiclesN do
				MissionInit:InsertFunction(Index, "AddStageVehicle", stageVehicles[i])
				Index = Index + 1
			end
			MissionInit:InsertFunction(Index, "AddObjective", "timer")
			Index = Index + 1
			MissionInit:InsertFunction(Index, "SetDurationTime", 0)
			Index = Index + 1
			MissionInit:InsertFunction(Index, "CloseObjective")
			Index = Index + 1
			MissionInit:InsertFunction(Index, "CloseStage")
			Index = Index + 1
		end
		
		
		for i=#functions,1,-1 do
			if functions[i].Name:lower() == "closestage" then
				MissionInit:InsertFunction(i, "SwapInDefaultCar")
				break
			end
		end
		
		if Settings.RemoveOutOfVehicle then
			local toRemove = {}
			local toRemoveN = 0
			local addCondition
			local remove = false
			for i=1,#functions do
				local func = functions[i]
				local name = func.Name:lower()
				
				if name == "addcondition" then
					if func.Arguments[1] == "damage" then
						addCondition = i
					end
				end
				
				if addCondition then
					if name == "setcondtargetvehicle" then
						if func.Arguments[1] == RandomVehicleName then -- TODO: Check if "current" is valid
							remove = true
						end
					end
					
					if name == "closecondition" then
						if remove then
							for j=addCondition,i do
								toRemoveN = toRemoveN + 1
								toRemove[toRemoveN] = j
							end
						end
						remove = false
						addCondition = nil
					end
				end
			end
			
			for i=toRemoveN,1,-1 do
				table_remove(functions, toRemove[i])
			end
		end
	end
	
	return true
end)

return RandomMissionVehicle