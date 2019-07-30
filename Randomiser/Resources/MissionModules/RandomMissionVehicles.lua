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
end