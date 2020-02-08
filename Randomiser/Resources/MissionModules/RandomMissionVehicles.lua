local args = {...}
local tbl = args[1]
if Settings.RandomMissionVehicles then
	local sort = 4
	local Level = {}
	local Mission = {}
	local SundayDrive = {}
	if not tbl.Level[sort] then
		tbl.Level[sort] = Level
	else
		Level = tbl.Level[sort]
	end
	if not tbl.Mission[sort] then
		tbl.Mission[sort] = Mission
	else
		Mission = tbl.Mission[sort]
	end
	if not tbl.SundayDrive[sort] then
		tbl.SundayDrive[sort] = SundayDrive
	else
		SundayDrive = tbl.SundayDrive[sort]
	end
	
	function Level.RandomMissionVehicles(LoadFile, InitFile, Level, Path)
		LastLevelMV = nil
		return LoadFile, InitFile
	end
	
	function SundayDrive.RandomMissionVehicles(LoadFile, InitFile, Level, Mission, Path)
		LastLevelMV = nil
		return LoadFile, InitFile
	end
	
	function Mission.RandomMissionVehicldes(LoadFile, InitFile, Level, Mission, Path)
		DebugPrint("Checking for sub level cars in " .. Level .. "|" .. Mission)
		local randomise = not Settings.SaveChoiceMV or LastLevelMV == nil or LastLevelMV ~= Path
		LastLevelMV = Path
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
					if not MissionVehicles[car] then
						MissionVehicles[car] = {}
					end
					if not MissionVehicles[car][spawn] then
						carName = GetRandomFromTbl(TmpCarPool, true)
						MissionVehicles[car][spawn] = carName
					else
						carName = MissionVehicles[car][spawn]
					end
				else
					carName = MissionVehicles[car][spawn]
				end
				if carName then
					if Settings.RandomMissionVehiclesStats or Settings.RandomStats then
						con = carName
					end
					RandomCars[car] = carName
					if not LoadFile:match("LoadDisposableCar%s*%(%s*\"art\\cars\\" .. carName .. ".p3d\"%s*,%s*\"" .. carName .. "\"%s*,%s*\"AI\"%s*%);") then
						LoadFile = LoadFile .. "\r\nLoadDisposableCar(\"art\\cars\\" .. carName .. ".p3d\",\"" .. carName .. "\",\"AI\");"
					end
					DebugPrint("Randomising " .. car .. " to " .. carName)
					return "AddStageVehicle(\"" .. carName .. "\",\"" .. spawn .. "\",\"" .. ai .. "\",\"" .. con .. ".con\""
				else
					DebugPrint("Not randomising \"" .. car .. "\" at \"" .. spawn .. "\" because nil value" .. (ForcedMission and " (randomise)" or ""))
					if not LoadFile:match("LoadDisposableCar%s*%(%s*\"art\\cars\\" .. car .. ".p3d\"%s*,%s*\"" .. car .. "\"%s*,%s*\"AI\"%s*%);") then
						LoadFile = LoadFile .. "\r\nLoadDisposableCar(\"art\\cars\\" .. car .. ".p3d\",\"" .. car .. "\",\"AI\");"
					end
				end
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
		MissionDrivers = {}
		local TmpDriverPool = {table.unpack(RandomPedPool)}
		InitFile = InitFile:gsub("AddStageVehicle%s*%(%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*%);", function(car, position, action, config, orig)
			local driverName = GetRandomFromTbl(TmpDriverPool, true)
			if #TmpDriverPool == 0 then
				TmpDriverPool = {table.unpack(RandomPedPool)}
			end
			MissionDrivers[#MissionDrivers + 1] = MissionDrivers
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