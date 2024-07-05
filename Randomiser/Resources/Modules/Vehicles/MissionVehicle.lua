local math_random = math.random
local table_remove = table.remove
local table_unpack = table.unpack

local RandomMissionVehicle = Module("Random Mission Vehicle", "RandomMissionVehicle", 3)

local CarNames = {table_unpack(CarNames)}
local CarP3DFiles = {table_unpack(CarP3DFiles)}
for i=CarCount,1,-1 do
	if not Settings[CarNames[i] .. "Mission"] then
		table_remove(CarNames, i)
		table_remove(CarP3DFiles, i)
	end
end
local CarCount = #CarNames

if CarCount < 5 and Settings[RandomMissionVehicle.Setting] then
	Alert("You must have at least 5 vehicle selected for the random player pool.")
	os.exit()
end

RandomMissionVehicle:AddMissionHandler(function(LevelNumber, MissionNumber, MissionLoad, MissionInit)
	-- TODO: Save on reload if some setting enabled or something
	
	local RandomVehicleName = CarNames[math_random(CarCount)]
	
	print("Setting mission vehicle to: " .. RandomVehicleName)
	
	local isForced = false
	
	for Function in MissionLoad:GetFunctions("LoadDisposableCar") do
		if Function.Arguments[3] == "OTHER" then
			isForced = true
			break
		end
	end
	
	if isForced then
		MissionInit:SetAll("InitLevelPlayerVehicle", 1, RandomVehicleName)
	else
		local CarLocator
		local LastStageIndex
		local ResetToHereIndex
		
		for Function, Index in MissionInit:GetFunctions() do
			local name = Function.Name:lower()
			
			if name == "setmissionresetplayeroutcar" then
				CarLocator = Function.Arguments[2]
			elseif name == "setmissionresetplayerincar" then
				CarLocator = Function.Arguments[1]
			elseif name == "addstage" then
				LastStageIndex = Index
			elseif name == "reset_to_here" then
				ResetToHereIndex = LastStageIndex
			end
			
			if CarLocator and ResetToHereIndex then
				break
			end
		end
		if not CarLocator then
			-- TODO: Is this even possible?
			Alert("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
		end
		MissionInit:InsertFunction(2, "SetForcedCar")
		MissionInit:InsertFunction(2, "InitLevelPlayerVehicle", {RandomVehicleName, CarLocator, "OTHER"})
		
		local stageVehicles = {}
		local stageVehiclesN = 0
		
		if ResetToHereIndex then
			local remove = false
			local functions = MissionInit.Functions
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
			local Function, Index = MissionInit:GetFunction("AddStage")
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
		
		local Function, Index = MissionInit:GetFunction("CloseStage", true)
		MissionInit:InsertFunction(Index, "SetFadeOut", 0.1)
		MissionInit:InsertFunction(Index, "SwapInDefaultCar")
		
		if Settings.RemoveOutOfVehicle then
			local toRemove = {}
			local toRemoveN = 0
			local addCondition
			local remove = false
			for Function, Index in MissionInit:GetFunctions() do
				local name = Function.Name:lower()
				
				if name == "addcondition" then
					if Function.Arguments[1] == "damage" then
						addCondition = Index
					end
				end
				
				if addCondition then
					if name == "setcondtargetvehicle" then
						if Function.Arguments[1] == RandomVehicleName then -- TODO: Check if "current" is valid
							remove = true
						end
					end
					
					if name == "closecondition" then
						if remove then
							for j=addCondition,Index do
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
				MissionInit:RemoveFunction(toRemove[i])
			end
		end
	end
	
	return true
end)

return RandomMissionVehicle