local args = {...}
local tbl = args[1]
if Settings.RandomMissionVehicles then
	function tbl.Level.RandomMissionVehicles(LoadFile, InitFile, Level)
		LastLevelMV = nil
		return LoadFile, InitFile
	end
	
	function tbl.SundayDrive.RandomMissionVehicles(LoadFile, InitFile, Level, Mission)
		LastLevelMV = nil
		return LoadFile, InitFile
	end
	
	function tbl.Mission.RandomMissionVehicldes(LoadFile, InitFile, Level, Mission)
		DebugPrint("Checking for sub level cars in " .. Level .. "|" .. Mission)
		if Settings.SaveChoiceMV then
			if LastLevelMV == nil or LastLevelMV ~= Level .. "|" .. Mission then			
				MissionVehicles = {}
				local TmpCarPool = {table.unpack(RandomCarPoolMission)}
				if Settings.DifferentCellouts and Level == 2 and Mission == 7 then
					LoadFile = ReadFile(Paths.Resources .. "l2m7l.mfk")
				end
				for orig in LoadFile:gmatch("LoadP3DFile%s*%(%s*\"art\\cars\\([^\n]-)%.p3d\"%s*%);") do
					local carName = GetRandomFromTbl(TmpCarPool, true)
					if #TmpCarPool == 0 then
						TmpCarPool = {table.unpack(RandomCarPoolMission)}
					end
					MissionVehicles[orig] = carName
					DebugPrint("Randomising " .. orig .. " to " .. carName)
				end
				for orig,var2,carType in LoadFile:gmatch("LoadDisposableCar%s*%(%s*\"art\\cars\\([^\n]-)%.p3d\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*%);") do
					if carType == "AI" then
						local carName = GetRandomFromTbl(TmpCarPool, true)
						if #TmpCarPool == 0 then
							TmpCarPool = {table.unpack(RandomCarPoolMission)}
						end
						MissionVehicles[orig] = carName
						DebugPrint("Randomising " .. orig .. " to " .. carName)
					end
				end
			elseif Settings.DifferentCellouts and Level == 2 and Mission == 7 then
				LoadFile = ReadFile(ModPath .. "/Resources/l2m7l.mfk")
			end
			LastLevelMV = Level .. "|" .. Mission
		else
			MissionVehicles = {}
			local TmpCarPool = {table.unpack(RandomCarPoolMission)}
			if Settings.DifferentCellouts and Level == 2 and Mission == 7 then
				LoadFile = ReadFile(ModPath .. "/Resources/l2m7l.mfk")
			end
			for orig in LoadFile:gmatch("LoadP3DFile%s*%(%s*\"art\\cars\\([^\n]-)%.p3d\"%s*%);") do
				local carName = GetRandomFromTbl(TmpCarPool, true)
				if #TmpCarPool == 0 then
					TmpCarPool = {table.unpack(RandomCarPoolMission)}
				end
				MissionVehicles[orig] = carName
				DebugPrint("Randomising " .. orig .. " to " .. carName)
			end
			for orig,var2,carType in LoadFile:gmatch("LoadDisposableCar%s*%(%s*\"art\\cars\\([^\n]-)%.p3d\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*%);") do
				if carType == "AI" then
					local carName = GetRandomFromTbl(TmpCarPool, true)
					if #TmpCarPool == 0 then
						TmpCarPool = {table.unpack(RandomCarPoolMission)}
					end
					MissionVehicles[orig] = carName
					DebugPrint("Randomising " .. orig .. " to " .. carName)
				end
			end
		end
		for k,v in pairs(MissionVehicles) do
			LoadFile = LoadFile:gsub("LoadP3DFile%s*%(%s*\"art\\cars\\" .. k .. "%.p3d\"%s*%);", "LoadP3DFile(\"art\\cars\\" .. v .. ".p3d\");")
			LoadFile = LoadFile:gsub("LoadDisposableCar%s*%(%s*\"art\\cars\\" .. k .."%.p3d\"%s*,%s*\"" .. k .. "\"%s*,%s*\"AI\"%s*%);", "LoadDisposableCar(\"art\\cars\\" .. v .. ".p3d\",\"" .. v .. "\",\"AI\");")
			LoadFile = LoadFile:gsub("LoadDisposableCar%s*%(%s*\"art\\cars\\" .. k .."%.p3d\"%s*,%s*\"cvan\"%s*,%s*\"AI\"%s*%);", "LoadDisposableCar(\"art\\cars\\" .. v .. ".p3d\",\"" .. v .. "\",\"AI\");")
		end
		
		if Settings.DifferentCellouts and Level == 2 and Mission == 7 then
			InitFile = ReadFile(Paths.Resources .. "l2m7i.mfk")
		end
		for k,v in pairs(MissionVehicles) do
			DebugPrint("Replacing " .. k .. " with " .. v)
			if Settings.RandomMissionVehiclesStats or Settings.RandomStats then
				InitFile = InitFile:gsub("AddStageVehicle%s*%(%s*\"" .. k .. "\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\".-\"", "AddStageVehicle(\"" .. v .. "\",\"%1\",\"%2\",\"" .. v .. ".con\"")
			else
				InitFile = InitFile:gsub("AddStageVehicle%s*%(%s*\"" .. k .. "\"", "AddStageVehicle(\"" .. v .. "\"")
			end
			InitFile = InitFile:gsub("ActivateVehicle%s*%(%s*\"" .. k .. "\"", "ActivateVehicle(\"" .. v .. "\"")
			InitFile = InitFile:gsub("SetVehicleAIParams%s*%(%s*\"" .. k .. "\"", "SetVehicleAIParams(\"" .. v .. "\"")
			InitFile = InitFile:gsub("SetStageAIRaceCatchupParams%s*%(%s*\"" .. k .. "\"", "SetStageAIRaceCatchupParams(\"" .. v .. "\"")
			InitFile = InitFile:gsub("SetStageAITargetCatchupParams%s*%(%s*\"" .. k .. "\"", "SetStageAITargetCatchupParams(\"" .. v .. "\"")
			InitFile = InitFile:gsub("SetCondTargetVehicle%s*%(%s*\"" .. k .. "\"", "SetCondTargetVehicle(\"" .. v .. "\"")
			InitFile = InitFile:gsub("SetObjTargetVehicle%s*%(%s*\"" .. k .. "\"", "SetObjTargetVehicle(\"" .. v .. "\"")
			InitFile = InitFile:gsub("AddDriver%s*%(%s*\"([^\n]-)\"%s*,%s*\"" .. k .. "\"", "AddDriver(\"%1\",\"" .. v .. "\"")
		end
		for i = 1, #RemovedTrafficCars do
			local k = RemovedTrafficCars[i]
			local v = GetRandomFromTbl(TrafficCars, false)
			DebugPrint("Replacing " .. k .. " with " .. v)
			if Settings.RandomMissionVehiclesStats or Settings.RandomStats then
				InitFile = InitFile:gsub("AddStageVehicle%s*%(%s*\"" .. k .. "\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\".-\"", "AddStageVehicle(\"" .. v .. "\",\"%1\",\"%2\",\"" .. v .. ".con\"")
			else
				InitFile = InitFile:gsub("AddStageVehicle%s*%(%s*\"" .. k .. "\"", "AddStageVehicle(\"" .. v .. "\"")
			end
			InitFile = InitFile:gsub("ActivateVehicle%s*%(%s*\"" .. k .. "\"", "ActivateVehicle(\"" .. v .. "\"")
			InitFile = InitFile:gsub("SetVehicleAIParams%s*%(%s*\"" .. k .. "\"", "SetVehicleAIParams(\"" .. v .. "\"")
			InitFile = InitFile:gsub("SetStageAIRaceCatchupParams%s*%(%s*\"" .. k .. "\"", "SetStageAIRaceCatchupParams(\"" .. v .. "\"")
			InitFile = InitFile:gsub("SetStageAITargetCatchupParams%s*%(%s*\"" .. k .. "\"", "SetStageAITargetCatchupParams(\"" .. v .. "\"")
			InitFile = InitFile:gsub("SetCondTargetVehicle%s*%(%s*\"" .. k .. "\"", "SetCondTargetVehicle(\"" .. v .. "\"")
			InitFile = InitFile:gsub("SetObjTargetVehicle%s*%(%s*\"" .. k .. "\"", "SetObjTargetVehicle(\"" .. v .. "\"")
			InitFile = InitFile:gsub("AddDriver%s*%(%s*\"([^\n]-)\"%s*,%s*\"" .. k .. "\"", "AddDriver(\"%1\",\"" .. v .. "\"")
		end
		local TmpDriverPool = {table.unpack(RandomPedPool)}
		InitFile = InitFile:gsub("AddStageVehicle%s*%(%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*%);", function(car, position, action, config, orig)
			local driverName = GetRandomFromTbl(TmpDriverPool, true)
			if #TmpDriverPool == 0 then
				TmpDriverPool = {table.unpack(RandomPedPool)}
			end
			for k in pairs(CarDrivers) do
				if k == orig then
					return "AddStageVehicle(\"" .. car .. "\",\"" .. position .. "\",\"" .. action .. "\",\"" .. config .. "\",\"" .. driverName .. "\");"
				end
			end
			return "AddStageVehicle(\"" .. car .. "\",\"" .. position .. "\",\"" .. action .. "\",\"" .. config .. "\",\"" .. orig .. "\");"
		end)
		return LoadFile, InitFile
	end
end