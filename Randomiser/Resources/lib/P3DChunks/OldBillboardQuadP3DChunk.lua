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

local function new(self, Version, Name, BillboardMode, Translation, Colour, Uv0, Uv1, Uv2, Uv3, Width, Height, Distance, UVOffset)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number.")
	assert(type(Name) == "string", "Arg #2 (Name) must be a string.")
	assert(type(BillboardMode) == "string", "Arg #3 (BillboardMode) must be a string.")
	assert(type(Translation) == "table", "Arg #4 (Translation) must be a table.")
	assert(type(Colour) == "table", "Arg #5 (Colour) must be a table.")
	assert(type(Uv0) == "table", "Arg #6 (Uv0) must be a table.")
	assert(type(Uv1) == "table", "Arg #7 (Uv1) must be a table.")
	assert(type(Uv2) == "table", "Arg #8 (Uv2) must be a table.")
	assert(type(Uv3) == "table", "Arg #9 (Uv3) must be a table.")
	assert(type(Width) == "number", "Arg #10 (Width) must be a number.")
	assert(type(Height) == "number", "Arg #11 (Height) must be a number.")
	assert(type(Distance) == "number", "Arg #12 (Distance) must be a number.")
	assert(type(UVOffset) == "table", "Arg #13 (UVOffset) must be a table.")

	local Data = {
		Chunks = {},
		Version = Version,
		Name = Name,
		BillboardMode = BillboardMode,
		Translation = Translation,
		Colour = Colour,
		Uv0 = Uv0,
		Uv1 = Uv1,
		Uv2 = Uv2,
		Uv3 = Uv3,
		Width = Width,
		Height = Height,
		Distance = Distance,
		UVOffset = UVOffset,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.OldBillboardQuadP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Old_Billboard_Quad)
P3D.OldBillboardQuadP3DChunk.new = new
function P3D.OldBillboardQuadP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Translation = {}
	chunk.Colour = {}
	chunk.Uv0 = {}
	chunk.Uv1 = {}
	chunk.Uv2 = {}
	chunk.Uv3 = {}
	chunk.UVOffset = {}
	chunk.Version, chunk.Name, chunk.BillboardMode, chunk.Translation.X, chunk.Translation.Y, chunk.Translation.Z, chunk.Colour.B, chunk.Colour.G, chunk.Colour.R, chunk.Colour.A, chunk.Uv0.X, chunk.Uv0.Y, chunk.Uv1.X, chunk.Uv1.Y, chunk.Uv2.X, chunk.Uv2.Y, chunk.Uv3.X, chunk.Uv3.Y, chunk.Width, chunk.Height, chunk.Distance, chunk.UVOffset.X, chunk.UVOffset.Y = string_unpack("<Is1c4fffBBBBfffffffffffff", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)

	return chunk
end

function P3D.OldBillboardQuadP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + 4 + #Name + 1 + 4 + 12 + 4 + 8 + 8 + 8 + 8 + 4 + 4 + 4 + 8
	return string_pack("<IIIIs1c4fffBBBBfffffffffffff", self.Identifier, headerLen, headerLen + #chunkData, self.Version, Name, self.BillboardMode, self.Translation.X, self.Translation.Y, self.Translation.Z, self.Colour.B, self.Colour.G, self.Colour.R, self.Colour.A, self.Uv0.X, self.Uv0.Y, self.Uv1.X, self.Uv1.Y, self.Uv2.X, self.Uv2.Y, self.Uv3.X, self.Uv3.Y, self.Width, self.Height, self.Distance, self.UVOffset.X, self.UVOffset.Y) .. chunkData
end