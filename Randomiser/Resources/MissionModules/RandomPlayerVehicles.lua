local args = {...}
local tbl = args[1]
if Settings.RandomPlayerVehicles then
	function tbl.Level.RandomPlayerVehicles(LoadFile, InitFile, Level)
		LastLevel = nil
		RandomCar = math.random(#RandomCarPoolPlayer)
		RandomCarName = RandomCarPoolPlayer[RandomCar]
		LoadFile = LoadFile:gsub("LoadDisposableCar%s*%(%s*\"[^\n]-\"%s*,%s*\".-\"%s*,%s*\"DEFAULT\"%s*%);", "LoadDisposableCar(\"art\\cars\\" .. RandomCarName .. ".p3d\",\"" .. RandomCarName .. "\",\"DEFAULT\");", 1)
		DebugPrint("Randomising car for level (load) -> " .. RandomCarName)
		
		InitFile = InitFile:gsub("InitLevelPlayerVehicle%s*%(%s*\".-\"%s*,%s*\"([^\n]-)\"%s*,%s*\"DEFAULT\"%s*%)", "InitLevelPlayerVehicle(\"" .. RandomCarName .. "\",\"%1\",\"DEFAULT\")", 1)
		DebugPrint("Randomising car for level -> " .. RandomCarName)
		return LoadFile, InitFile
	end
end