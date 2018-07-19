if SettingCustomCars then
	local Path = "/GameData/" .. GetPath()
	local carName = Path:match("[\\/]cars[\\/](.-)%.p3d")
	for i = 1, #CustomCarPool do
		if CustomCarPool[i]:lower() == carName:lower() then
			Redirect("/GameData/CustomCars/" .. CustomCarPool[i] .. "/" .. CustomCarPool[i] .. ".p3d")
			break
		end
	end
end