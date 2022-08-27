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

local function new(self, NumPrimGroups, NumOffsetLists, PrimGroupIndices)
	assert(type(NumPrimGroups) == "number", "Arg #1 (NumPrimGroups) must be a number")
	assert(type(NumOffsetLists) == "number", "Arg #2 (NumOffsetLists) must be a number")
	assert(type(PrimGroupIndices) == "table", "Arg #3 (PrimGroupIndices) must be a table")
	assert(NumPrimGroups == #PrimGroupIndices, "Arg #1 (NumPrimGroups) must match the length of Arg #3 (PrimGroupIndices)")
	
	local Data = {
		Chunks = {},
		NumPrimGroups = NumPrimGroups,
		NumOffsetLists = NumOffsetLists,
		PrimGroupIndices = PrimGroupIndices,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.OldExpressionOffsetsP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Old_Expression_Offsets)
P3D.OldExpressionOffsetsP3DChunk.new = new
function P3D.OldExpressionOffsetsP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local pos
	chunk.NumPrimGroups, chunk.NumOffsetLists, pos = string_unpack("<II", chunk.ValueStr)
	
	chunk.PrimGroupIndices = table_pack(string_unpack("<" .. string_rep("I", chunk.NumPrimGroups), chunk.ValueStr, pos))
	chunk.PrimGroupIndices[chunk.NumPrimGroups + 1] = nil
	
	return chunk
end

function P3D.OldExpressionOffsetsP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local primGroupIndicesN = #self.PrimGroupIndices
	
	local headerLen = 12 + 4 + 4 + primGroupIndicesN * 4
	return string_pack("<IIIII" .. string_rep("I", primGroupIndicesN), self.Identifier, headerLen, headerLen + #chunkData, self.NumPrimGroups, self.NumOffsetLists, table_unpack(self.PrimGroupIndices)) .. chunkData
end