if SettingCustomCars then
	local Path = GetPath()
	for k,v in pairs(CustomCarSounds) do
		Path = Path:gsub("\\", "/")
		k = k:gsub("\\", "/")
		if k:lower() == Path:lower() then
			Redirect(v)
			break
		end
	end
end