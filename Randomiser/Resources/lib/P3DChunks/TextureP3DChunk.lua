--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
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

local function new(self, Name, Version, Width, Height, Bpp, AlphaDepth, NumMipMaps, TextureType, Usage, Priority)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string.")
	assert(type(Version) == "number", "Arg #2 (Version) must be a number.")
	assert(type(Width) == "number", "Arg #3 (Width) must be a number.")
	assert(type(Height) == "number", "Arg #4 (Height) must be a number.")
	assert(type(Bpp) == "number", "Arg #5 (Bpp) must be a number.")
	assert(type(AlphaDepth) == "number", "Arg #6 (AlphaDepth) must be a number.")
	assert(type(NumMipMaps) == "number", "Arg #7 (NumMipMaps) must be a number.")
	assert(type(TextureType) == "number", "Arg #8 (TextureType) must be a number.")
	assert(type(Usage) == "number", "Arg #9 (Usage) must be a number.")
	assert(type(Priority) == "number", "Arg #10 (Priority) must be a number.")

	local Data = {
		Chunks = {},
		Name = Name,
		Version = Version,
		Width = Width,
		Height = Height,
		Bpp = Bpp,
		AlphaDepth = AlphaDepth,
		NumMipMaps = NumMipMaps,
		TextureType = TextureType,
		Usage = Usage,
		Priority = Priority,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.TextureP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Texture)
P3D.TextureP3DChunk.new = new
function P3D.TextureP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Name, chunk.Version, chunk.Width, chunk.Height, chunk.Bpp, chunk.AlphaDepth, chunk.NumMipMaps, chunk.TextureType, chunk.Usage, chunk.Priority = string_unpack("<s1IIIIIIIII", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)

	return chunk
end

function P3D.TextureP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + #Name + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4
	return string_pack("<IIIs1IIIIIIIII", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Version, self.Width, self.Height, self.Bpp, self.AlphaDepth, self.NumMipMaps, self.TextureType, self.Usage, self.Priority) .. chunkData
end