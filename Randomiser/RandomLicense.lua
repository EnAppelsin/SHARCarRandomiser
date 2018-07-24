local RandomLicenses = {}
GetFiles(RandomLicenses, ModPath .. "/Resources/Licenses", {".png"}, 1)
DebugPrint("Found " .. #RandomLicenses .. " possible licenses")
local RandomLicense = GetRandomFromTbl(RandomLicenses, false)
DebugPrint("Using " .. RandomLicense .. " as license PNG")

local License = ReadFile("/GameData/art/frontend/dynaload/images/license/licensePC.p3d")

local SpriteOffset, SpriteLength = FindSubchunk(License, SPRITE_CHUNK)
local Sprite = License:sub(SpriteOffset, SpriteLength - 1)
local ImageOffset, ImageLength = FindSubchunk(Sprite, IMAGE_CHUNK)
local Image = Sprite:sub(ImageOffset, ImageLength - 1)
local ImageDataOffset, ImageDataLength = FindSubchunk(Image, IMAGE_DATA_CHUNK)

local NewLicenseData = ReadFile(RandomLicense)
local NewLicenseLength = NewLicenseData:len()
local OldLicenseLength = GetP3DInt4(Image, ImageDataOffset + 4)
local Delta = NewLicenseLength - OldLicenseLength

local NewLicense = License:sub(1, SpriteOffset + ImageOffset - 1 + ImageDataOffset - 1 + 15) .. NewLicenseData

NewLicense = AddP3DInt4(NewLicense, SpriteOffset + 8, Delta)
NewLicense = AddP3DInt4(NewLicense, SpriteOffset + ImageOffset - 1 + 8, Delta)
NewLicense = AddP3DInt4(NewLicense, SpriteOffset + ImageOffset - 1 + ImageDataOffset - 1 + 4, Delta)
NewLicense = AddP3DInt4(NewLicense, SpriteOffset + ImageOffset - 1 + ImageDataOffset - 1 + 8, Delta)
NewLicense = AddP3DInt4(NewLicense, SpriteOffset + ImageOffset - 1 + ImageDataOffset - 1 + 12, Delta)

Output(NewLicense)