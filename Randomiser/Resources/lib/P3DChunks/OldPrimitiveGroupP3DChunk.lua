--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.OldPrimitiveGroupP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Version, ShaderName, PrimitiveType, NumVertices, NumIndices, NumMatrices)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number.")
	assert(type(ShaderName) == "string", "Arg #2 (ShaderName) must be a string.")
	assert(type(PrimitiveType) == "number", "Arg #3 (PrimitiveType) must be a number.")
	assert(type(NumVertices) == "number", "Arg #4 (NumVertices) must be a number.")
	assert(type(NumIndices) == "number", "Arg #5 (NumIndices) must be a number.")
	assert(type(NumMatrices) == "number", "Arg #6 (NumMatrices) must be a number.")

	local Data = {
		Endian = "<",
		Chunks = {},
		Version = Version,
		ShaderName = ShaderName,
		PrimitiveType = PrimitiveType,
		NumVertices = NumVertices,
		NumIndices = NumIndices,
		NumMatrices = NumMatrices,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.OldPrimitiveGroupP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Old_Primitive_Group)
P3D.OldPrimitiveGroupP3DChunk.new = new
P3D.OldPrimitiveGroupP3DChunk.PrimitiveTypes = {
	TriangleList = 0,
	TriangleStrip = 1,
	LineList = 2,
	LineStrip = 3
}
P3D.OldPrimitiveGroupP3DChunk.VertexTypes = {
	UVs = 1,
	UVs2 = 2,
	UVs3 = 3,
	UVs4 = 4,
	UVs5 = 5,
	UVs6 = 6,
	UVs7 = 7,
	UVs8 = 8,
	Normals = 1 << 4,
	Colours = 1 << 5,
	Specular = 1 << 6,
	Matrices = 1 << 7,
	Weights = 1 << 8,
	Size = 1 << 9,
	W = 1 << 10,
	BiNormal = 1 << 11,
	Tangent = 1 << 12,
	Position = 1 << 13,
	Colour2 = 1 << 14,
	ColourCount1 = 1<<15,
	ColourCount2 = 2<<15,
	ColourCount3 = 3<<15,
	ColourCount4 = 4<<15,
	ColourCount5 = 5<<15,
	ColourCount6 = 6<<15,
	ColourCount7 = 7<<15,
	ColourMask = 7<<15,
	ColourMaskOffset = 15,
}
function P3D.OldPrimitiveGroupP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	local num
	chunk.Version, chunk.ShaderName, chunk.PrimitiveType, num, chunk.NumVertices, chunk.NumIndices, chunk.NumMatrices = string_unpack(Endian .. "Is1IIIII", chunk.ValueStr)
	chunk.ShaderName = P3D.CleanP3DString(chunk.ShaderName)

	return chunk
end

local VertexTypeMap = {
	[P3D.Identifiers.Packed_Normal_List] = P3D.OldPrimitiveGroupP3DChunk.VertexTypes.Normals,
	[P3D.Identifiers.Normal_List] = P3D.OldPrimitiveGroupP3DChunk.VertexTypes.Normals,
	[P3D.Identifiers.Colour_List] = P3D.OldPrimitiveGroupP3DChunk.VertexTypes.Colours,
	[P3D.Identifiers.Matrix_List] = P3D.OldPrimitiveGroupP3DChunk.VertexTypes.Matrices,
	[P3D.Identifiers.Matrix_Palette] = P3D.OldPrimitiveGroupP3DChunk.VertexTypes.Matrices,
	[P3D.Identifiers.Weight_List] = P3D.OldPrimitiveGroupP3DChunk.VertexTypes.Weights,
	[P3D.Identifiers.Position_List] = P3D.OldPrimitiveGroupP3DChunk.VertexTypes.Position,
}
local UVTypeMap = {
	P3D.OldPrimitiveGroupP3DChunk.VertexTypes.UVs,
	P3D.OldPrimitiveGroupP3DChunk.VertexTypes.UVs2,
	P3D.OldPrimitiveGroupP3DChunk.VertexTypes.UVs3,
	P3D.OldPrimitiveGroupP3DChunk.VertexTypes.UVs4,
	P3D.OldPrimitiveGroupP3DChunk.VertexTypes.UVs5,
	P3D.OldPrimitiveGroupP3DChunk.VertexTypes.UVs6,
	P3D.OldPrimitiveGroupP3DChunk.VertexTypes.UVs7,
	P3D.OldPrimitiveGroupP3DChunk.VertexTypes.UVs8,
}
function P3D.OldPrimitiveGroupP3DChunk:GetVertexType()
	local vertexType = 0
	
	local uvN = 0
	for i=1,#self.Chunks do
		local identifier = self.Chunks[i].Identifier
		if identifier == P3D.Identifiers.UV_List then
			uvN = uvN + 1
		else
			local chunkVertexType = VertexTypeMap[identifier]
			if chunkVertexType then
				vertexType = vertexType | chunkVertexType
			end
		end
	end
	if uvN > 0 then
		assert(uvN <= 8, "Old Primitive Groups can only have a maximum of 8 UV Lists")
		vertexType = vertexType | UVTypeMap[uvN]
	end
	
	return vertexType
end

function P3D.OldPrimitiveGroupP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local ShaderName = P3D.MakeP3DString(self.ShaderName)
	
	local headerLen = 12 + 4 + #ShaderName + 1 + 4 + 4 + 4 + 4 + 4
	return string_pack(self.Endian .. "IIIIs1IIIII", self.Identifier, headerLen, headerLen + #chunkData, self.Version, ShaderName, self.PrimitiveType, self:GetVertexType(), self.NumVertices, self.NumIndices, self.NumMatrices) .. chunkData
end