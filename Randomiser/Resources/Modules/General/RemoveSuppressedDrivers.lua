local table_remove = table.remove

local RemoveSuppressedDrivers = Module("Remove Suppressed Drivers", nil, 1)

RemoveSuppressedDrivers:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	local removed = false
	for Function, Index in LevelLoad:GetFunctions("SuppressDriver", true) do
		removed = true
		LevelLoad:RemoveFunction(Index)
	end
	
	return removed
end)

return RemoveSuppressedDrivers