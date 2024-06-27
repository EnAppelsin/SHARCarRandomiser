--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.ImageP3DChunk == nil, "Chunk type already loaded.")

local string_format = string.format
local string_pack = string.pack
local string_rep = string.rep
local string_reverse = string.reverse
local string_unpack = string.unpack

local table_concat = table.concat
local table_unpack = table.unpack

local assert = assert
local tostring = tostring
local type = type

local function new(self, Name, Version, Width, Height, Bpp, Palettized, HasAlpha, Format)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Version) == "number", "Arg #2 (Version) must be a number")
	assert(type(Width) == "number", "Arg #3 (Width) must be a number")
	assert(type(Height) == "number", "Arg #4 (Height) must be a number")
	assert(type(Bpp) == "number", "Arg #5 (Bpp) must be a number")
	assert(type(Palettized) == "number", "Arg #6 (Palettized) must be a number")
	assert(type(HasAlpha) == "number", "Arg #7 (HasAlpha) must be a number")
	assert(type(Format) == "number", "Arg #8 (Format) must be a number")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Name = Name,
		Version = Version,
		Width = Width,
		Height = Height,
		Bpp = Bpp,
		Palettized = Palettized,
		HasAlpha = HasAlpha,
		Format = Format
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.ImageP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Image)
P3D.ImageP3DChunk.new = new
P3D.ImageP3DChunk.Formats = {
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
function P3D.ImageP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Name, chunk.Version, chunk.Width, chunk.Height, chunk.Bpp, chunk.Palettized, chunk.HasAlpha, chunk.Format = string_unpack(Endian .. "s1IIIIIII", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	
	return chunk
end

function P3D.ImageP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + #Name + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 4
	return string_pack(self.Endian .. "IIIs1IIIIIII", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Version, self.Width, self.Height, self.Bpp, self.Palettized, self.HasAlpha, self.Format) .. chunkData
end