if SettingCustomCars then
	local Path = "/GameData/" .. GetPath()
	local carName = Path:match("[\\/]cars[\\/](.-)%.p3d")
	for i = 1, #CustomCarPool do
		if CustomCarPool[i]:lower() == carName:lower() then
			if RandomCarName:lower() == carName:lower() or ExistsInTbl(TrafficCars, carName, false) then
				local carData = ReadFile("/GameData/CustomCars/" .. CustomCarPool[i] .. "/" .. CustomCarPool[i] .. ".p3d")
				carData = SetCarCameraIndex(carData, 96)
				Output(carData)
			else
				Redirect("/GameData/CustomCars/" .. CustomCarPool[i] .. "/" .. CustomCarPool[i] .. ".p3d")
			end
			break
		end
	end
end
