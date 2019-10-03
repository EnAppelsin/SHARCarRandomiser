local args = {...}
local tbl = args[1]
if Settings.RandomChase then
	function tbl.Level.RandomChase(LoadFile, InitFile, Level, Path)
		RandomChase = GetRandomFromTbl(RandomCarPoolChase, false)
		LoadFile = LoadFile .. "\r\nLoadP3DFile(\"art\\cars\\" .. RandomChase .. ".p3d\");"
		DebugPrint("Random chase cars for level -> " .. RandomChase)
		
		if Settings.RandomChaseStats or Settings.RandomStats then
			InitFile = InitFile:gsub("CreateChaseManager%s*%(%s*\"[^\n]-\"%s*,%s*\"[^\n]-\"", "CreateChaseManager(\"" .. RandomChase .."\",\"" .. RandomChase .. ".con\"", 1)
		else
			InitFile = InitFile:gsub("CreateChaseManager%s*%(%s*\"[^\n]-\"", "CreateChaseManager(\"" .. RandomChase .."\"", 1)
		end
		if Settings.RandomChaseAmount then
			local chaseAmount = math.random(1, 5)
			InitFile = InitFile:gsub("SetNumChaseCars%s*%(%s*\"[^\n]-\"", "SetNumChaseCars(\"" .. chaseAmount .."\"", 1)
			DebugPrint("Random chase amount -> " .. chaseAmount)
		end
		return LoadFile, InitFile
	end
	
	function tbl.Mission.RandomChase(LoadFile, InitFile, Level, Mission, Path)
		if not Settings.RandomMissionVehicles then
			local police = {}
			table.insert(police, "cPolice")
			table.insert(police, "cHears")
			for i=1,#police do
				local k = police[i]
				InitFile = InitFile:gsub("AddStageVehicle%s*%(%s*\"" .. k .. "\"", "AddStageVehicle(\"" .. RandomChase .. "\"")
				InitFile = InitFile:gsub("ActivateVehicle%s*%(%s*\"" .. k .. "\"", "ActivateVehicle(\"" .. RandomChase .. "\"")
				InitFile = InitFile:gsub("SetVehicleAIParams%s*%(%s*\"" .. k .. "\"", "SetVehicleAIParams(\"" .. RandomChase .. "\"")
				InitFile = InitFile:gsub("SetStageAIRaceCatchupParams%s*%(%s*\"" .. k .. "\"", "SetStageAIRaceCatchupParams(\"" .. RandomChase .. "\"")
				InitFile = InitFile:gsub("SetStageAITargetCatchupParams%s*%(%s*\"" .. k .. "\"", "SetStageAITargetCatchupParams(\"" .. RandomChase .. "\"")
				InitFile = InitFile:gsub("SetCondTargetVehicle%s*%(%s*\"" .. k .. "\"", "SetCondTargetVehicle(\"" .. RandomChase .. "\"")
				InitFile = InitFile:gsub("SetObjTargetVehicle%s*%(%s*\"" .. k .. "\"", "SetObjTargetVehicle(\"" .. RandomChase .. "\"")
				InitFile = InitFile:gsub("AddDriver%s*%(%s*\"([^\n]-)\"%s*,%s*\"" .. k .. "\"", "AddDriver(\"%1\",\"" .. RandomChase .. "\"")
			end
		end
		return LoadFile, InitFile
	end
end