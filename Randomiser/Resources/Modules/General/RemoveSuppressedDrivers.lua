local table_remove = table.remove

local RemoveSuppressedDrivers = Module("Remove Suppressed Drivers", nil, 1)

RemoveSuppressedDrivers:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	local removed = false
	local functions = LevelLoad.Functions
	for i=#functions,1,-1 do
		if functions[i].Name:lower() == "suppressdriver" then
			removed = true
			table_remove(functions, i)
		end
	end
	
	return removed
end)

return RemoveSuppressedDrivers