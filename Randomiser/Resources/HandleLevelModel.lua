local Path = "/GameData/" .. GetPath()

local interiorP3DLevel = string.match(Path, "l(%d)i0%d%.p3d")

if Settings.RandomInteriors and interiorP3DLevel then
	local interiorP3D = "0" .. string.match(Path, "l%di0(%d)")
	DebugPrint("New Level Model: " .. Path)	
	local newInterior = interiorReplace[interiorP3D]
	if newInterior then
		local newP3D = string.gsub(Path, "0%d.p3d", newInterior .. ".p3d")
		Redirect(newP3D)
	end
end