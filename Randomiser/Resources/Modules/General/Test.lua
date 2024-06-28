local Test = Module("Test", nil, 0)

Test:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	print("Level handler: L" .. LevelNumber)
end)

Test:AddSundayDriveHandler(function(LevelNumber, MissionNumber, MissionLoad, MissionInit)
	print("SundayDrive handler: L" .. LevelNumber .. "SD" .. MissionNumber)
end)

Test:AddMissionHandler(function(LevelNumber, MissionNumber, MissionLoad, MissionInit)
	print("Mission handler: L" .. LevelNumber .. "M" .. MissionNumber)
end)

Test:AddRaceHandler(function(LevelNumber, RaceNumber, RaceLoad, RaceInit)
	print("Race handler: L" .. LevelNumber .. "SR" .. RaceNumber)
end)

--[[Test:AddGenericHandler("*", function()
	print("Generic handler: " .. GetPath())
end)]]

return Test