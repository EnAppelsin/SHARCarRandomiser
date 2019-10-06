if Settings.CustomCars then
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
if not loading and Settings.RandomStaticCars then
	local Path = "/GameData/" .. GetPath()
	if not Path:match("huskA%.p3d") and not Path:match("common%.p3d") then
		--Redirect(Paths.Resources .. "famil_v2.p3d")
	end
	DebugPrint("Not-loading car load: " .. GetPath(), 2)
end