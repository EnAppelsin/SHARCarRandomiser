local Path = "/GameData/" .. GetPath()
local carName = Path:match("[\\/]cars[\\/](.-)%.p3d")
if not loading and loadTime and Settings.RandomStaticCars then
	if not Path:match("huskA%.p3d") and not Path:match("common%.p3d") then
		if Settings.SaveChoiceRSC and RandomStaticCarSave and RandomStaticCarSave[carName] then
			RandomStaticCarName = RandomStaticCarSave[carName]
			RandomStaticCar = carName
		else
			local RandomCar = math.random(#RandomCarPoolPlayer)
			RandomStaticCarName = RandomCarPoolPlayer[RandomCar]
			RandomStaticCar = carName
			if Settings.SaveChoiceRSC then RandomStaticCarSave[carName] = RandomStaticCarName end
		end
		if Settings.UseDebugSettings and Exists("/GameData/RandomiserSettings/RandomStaticCar.txt", true, false) then
			local staticName = ReadFile("/GameData/RandomiserSettings/RandomStaticCar.txt")
			if staticName:len() > 0 then
				RandomStaticCarName = staticName
			end
		end
		DebugPrint("Replacing dynamically loaded car \"" .. carName .. "\" with \"" .. RandomStaticCarName .. "\".")
		if Settings.CustomCars and ExistsInTbl(CustomCarPool, RandomStaticCarName) then
			Output(ReplaceCar(ReadFile("/GameData/CustomCars/" .. RandomStaticCarName .. "/" .. RandomStaticCarName .. ".p3d"), ReadFile(Path)))
		else
			Output(ReplaceCar(ReadFile("/GameData/art/cars/" .. RandomStaticCarName .. ".p3d"), ReadFile(Path)))
		end
	end
	DebugPrint("Not-loading car load: " .. GetPath(), 2)
elseif Settings.CustomCars then
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