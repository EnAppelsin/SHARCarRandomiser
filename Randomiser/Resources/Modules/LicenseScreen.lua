local LicenseScreen = Module("License Screen", "LicenseScreen", 5)

local licenses = {}
GetFilesInDirectory(Paths.Resources .. "/Licenses", licenses, ".png")
local licensesN = #licenses
assert(licensesN > 0, "Failed to find any license images")

LicenseScreen:AddP3DHandler("art/frontend/dynaload/images/license/*license*.p3d", function(Path, P3DFile)
	local Sprite = P3DFile:GetChunk(P3D.Identifiers.Sprite)
	if not Sprite then
		return false
	end
	
	Sprite.BlitBorder = 0
	Sprite.Chunks = {}
	
	local Image = P3D.ImageP3DChunk(Sprite.Name, 14000, Sprite.ImageWidth, Sprite.ImageHeight, 32, 0, 1, P3D.ImageP3DChunk.Formats.PNG)
	Sprite:AddChunk(Image)
	
	local ImageData = P3D.ImageDataP3DChunk(ReadFile(licenses[math.random(licensesN)]))
	Image:AddChunk(ImageData)
	
	return true
end)

return LicenseScreen