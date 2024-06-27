--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.OldBillboardQuadGroupP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Version, Name, Shader, ZTest, ZWrite, Fog)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number.")
	assert(type(Name) == "string", "Arg #2 (Name) must be a string.")
	assert(type(Shader) == "string", "Arg #3 (Shader) must be a string.")
	assert(type(ZTest) == "number", "Arg #4 (ZTest) must be a number.")
	assert(type(ZWrite) == "number", "Arg #5 (ZWrite) must be a number.")
	assert(type(Fog) == "number", "Arg #6 (Fog) must be a number.")

	local Data = {
		Endian = "<",
		Chunks = {},
		Version = Version,
		Name = Name,
		Shader = Shader,
		ZTest = ZTest,
		ZWrite = ZWrite,
		Fog = Fog,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.OldBillboardQuadGroupP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Old_Billboard_Quad_Group)
P3D.OldBillboardQuadGroupP3DChunk.new = new
function P3D.OldBillboardQuadGroupP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Version, chunk.Name, chunk.Shader, chunk.ZTest, chunk.ZWrite, chunk.Fog = string_unpack(Endian .. "Is1s1III", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	chunk.Shader = P3D.CleanP3DString(chunk.Shader)

	return chunk
end

function P3D.OldBillboardQuadGroupP3DChunk:GetNumQuads()
	local n = 0
	for i=1,#self.Chunks do
		if self.Chunks[i].Identifier == P3D.Identifiers.Old_Billboard_Quad then
			n = n + 1
		end
	end
	return n
end

function P3D.OldBillboardQuadGroupP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local Shader = P3D.MakeP3DString(self.Shader)
	
	local headerLen = 12 + 4 + #Name + 1 + #Shader + 1 + 4 + 4 + 4 + 4
	return string_pack(self.Endian .. "IIIIs1s1IIII", self.Identifier, headerLen, headerLen + #chunkData, self.Version, Name, Shader, self.ZTest, self.ZWrite, self.Fog, self:GetNumQuads()) .. chunkData
end