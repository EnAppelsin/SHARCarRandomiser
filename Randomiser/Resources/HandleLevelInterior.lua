local Path = "/GameData/" .. GetPath()

local interiorP3DLevel = string.match(Path, "l(%d)i0%d%.p3d")

if Settings.RandomInteriors and interiorP3DLevel then
	local interiorP3D = "0" .. string.match(Path, "l%di0(%d)")
	DebugPrint("New Level Model: " .. Path)	
	local newInterior = interiorReplace[interiorP3D]
	if newInterior then
		local newP3D = string.gsub(Path, "0%d.p3d", newInterior .. ".p3d")
		if newP3D:match("l1i07") then
			newP3D = newP3D:gsub("l1", "l4")
		end
		Redirect(newP3D)
	end
elseif Path:match("l1i07") then
	Redirect("/GameData/art/l4i07.p3d")
end