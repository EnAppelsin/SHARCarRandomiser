local args = {...}
if #args > 0 then
	local tbl = args[1]
	if tbl.Level == nil then
		tbl.Level = {}
	end
	
	if Settings.RandomMissionVehicles then
		function tbl.Level.RandomMissionVehicles(LoadFile, InitFile, Level)
			LastLevelMV = nil
			return LoadFile, InitFile
		end
	end
end