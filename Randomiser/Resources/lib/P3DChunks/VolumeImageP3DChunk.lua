--[[
CREDITS:
	Proddy#7272				- Converting to Lua, P3D Chunk Structure
]]

assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")

local string_format = string.format
local string_pack = string.pack
local string_rep = string.rep
local string_unpack = string.unpack

local table_concat = table.concat
local table_pack = table.pack
local table_unpack = table.unpack

local assert = assert
local type = type

local function new(self, Name, Version, Width, Height, Depth, Bpp, Palettized, HasAlpha, Format)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Version) == "number", "Arg #2 (Version) must be a number")
	assert(type(Width) == "number", "Arg #3 (Width) must be a number")
	assert(type(Height) == "number", "Arg #4 (Height) must be a number")
	assert(type(Depth) == "number", "Arg #5 (Depth) must be a number")
	assert(type(Bpp) == "number", "Arg #6 (Bpp) must be a number")
	assert(type(Palettized) == "number", "Arg #7 (Palettized) must be a number")
	assert(type(HasAlpha) == "number", "Arg #8 (HasAlpha) must be a number")
	assert(type(Format) == "number", "Arg #9 (Format) must be a number")
	
	local Data = {
		Chunks = {},
		Name = Name,
		Version = Version,
		Width = Width,
		Height = Height,
		Depth = Depth,
		Bpp = Bpp,
		Palettized = Palettized,
		HasAlpha = HasAlpha,
		Format = Format
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.VolumeImageP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Volume_Image)
P3D.VolumeImageP3DChunk.new = new
P3D.VolumeImageP3DChunk.Formats = {
	Raw = 0,
	PNG = 1,
	TGA = 2,
	BMP = 3,
	IPU = 4,
	DXT = 5,
	DXT1 = 6,
	DXT2 = 7,
	DXT3 = 8,
	DXT4 = 9,
	DXT5 = 10,
	PS24Bit = 11,
	PS28Bit = 12,
	PS216Bit = 13,
	PS232Bit = 14,
	GC4Bit = 15,
	GC8Bit = 16,
	GC16Bit = 17,
	GC32Bit = 18,
	GCDXT1 = 19,
	Other = 20,
	Invalid = 21,
	PSP4Bit = 25,
}
function P3D.VolumeImageP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Name, chunk.Version, chunk.Width, chunk.Height, chunk.Depth, chunk.Bpp, chunk.Palettized, chunk.HasAlpha, chunk.Format = string_unpack("<s1IIIIIIII", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	
	return chunk
end

function P3D.VolumeImageP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + #Name + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4
	return string_pack("<IIIs1IIIIIIII", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Version, self.Width, self.Height, self.Depth, self.Bpp, self.Palettized, self.HasAlpha, self.Format) .. chunkData
end