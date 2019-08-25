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
		local randomise = not Settings.SaveChoiceMV or LastLevelMV == nil or LastLevelMV ~= Level .. "|" .. Mission
		LastLevelMV = Level .. "|" .. Mission
		if randomise then
			MissionVehicles = {}
		end
		local RandomCars = {}
		local TmpCarPool = {}
		local carIndex = 0
		LoadFile = LoadFile:gsub("LoadDisposableCar%s*%(%s*\"art\\cars\\[^\n]-.p3d\"%s*,%s*\"[^\n]-\"%s*,%s*\"AI\"%s*%);", "")
		InitFile = InitFile:gsub("(.-)\n", function(original)
			original = original:gsub("AddStageVehicle%s*%(%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)%.con\"", function(car, spawn, ai, con)
				local carName
				if randomise then
					if #TmpCarPool == 0 then
						TmpCarPool = {table.unpack(RandomCarPoolMission)}
					end
					if MissionVehicles[car] == nil or MissionVehicles[car][spawn] == nil then
						MissionVehicles[car] = {}
						carName = GetRandomFromTbl(TmpCarPool, true)
						MissionVehicles[car][spawn] = carName
					else
						carName = MissionVehicles[car][spawn]
					end
				else
					carName = MissionVehicles[car][spawn]
				end
				if Settings.RandomMissionVehiclesStats or Settings.RandomStats then
					con = carName
				end
				RandomCars[car] = carName
				if not LoadFile:match("LoadDisposableCar%s*%(%s*\"art\\cars\\" .. carName .. ".p3d\"%s*,%s*\"" .. carName .. "\"%s*,%s*\"AI\"%s*%);") then
					LoadFile = LoadFile .. "\r\nLoadDisposableCar(\"art\\cars\\" .. carName .. ".p3d\",\"" .. carName .. "\",\"AI\");"
				end
				DebugPrint("Randomising " .. car .. " to " .. carName)
				return "AddStageVehicle(\"" .. carName .. "\",\"" .. spawn .. "\",\"" .. ai .. "\",\"" .. con .. ".con\""
			end)
			for k,v in pairs(RandomCars) do
			    original = original:gsub("ActivateVehicle%s*%(%s*\"" .. k .. "\"", "ActivateVehicle(\"" .. v .. "\"")
				original = original:gsub("SetVehicleAIParams%s*%(%s*\"" .. k .. "\"", "SetVehicleAIParams(\"" .. v .. "\"")
				original = original:gsub("SetStageAIRaceCatchupParams%s*%(%s*\"" .. k .. "\"", "SetStageAIRaceCatchupParams(\"" .. v .. "\"")
				original = original:gsub("SetStageAITargetCatchupParams%s*%(%s*\"" .. k .. "\"", "SetStageAITargetCatchupParams(\"" .. v .. "\"")
				original = original:gsub("SetCondTargetVehicle%s*%(%s*\"" .. k .. "\"", "SetCondTargetVehicle(\"" .. v .. "\"")
				original = original:gsub("SetObjTargetVehicle%s*%(%s*\"" .. k .. "\"", "SetObjTargetVehicle(\"" .. v .. "\"")
				original = original:gsub("AddDriver%s*%(%s*\"([^\n]-)\"%s*,%s*\"" .. k .. "\"", "AddDriver(\"%1\",\"" .. v .. "\"")
			end
			
			return original .. "\n"
		end)
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