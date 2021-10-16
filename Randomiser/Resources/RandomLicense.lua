local RandomLicenses = {}
GetFiles(RandomLicenses, Paths.Resources .. "Licenses", {".png"}, 1)
DebugPrint("Found " .. #RandomLicenses .. " possible licenses")
local RandomLicense = GetRandomFromTbl(RandomLicenses, false)
DebugPrint("Using " .. RandomLicense .. " as license PNG")

local License = ReadFile("/GameData/art/frontend/dynaload/images/license/licensePC.p3d")
local NewLicenseData = ReadFile(RandomLicense)
Output(SetSpriteImage(License, NewLicenseData, 640, 480))