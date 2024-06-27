--[[
CREDITS:
	Proddy#7272				- Converting to Lua, P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.OldOffsetListP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, KeyIndex, Offsets, PrimGroupIndex)
	assert(type(KeyIndex) == "number", "Arg #1 (KeyIndex) must be a number")
	assert(type(Offsets) == "table", "Arg #2 (Offsets) must be a table")
	assert(type(PrimGroupIndex) == "number", "Arg #3 (PrimGroupIndex) must be a number")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		KeyIndex = KeyIndex,
		Offsets = Offsets,
		PrimGroupIndex = PrimGroupIndex,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.OldOffsetListP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Old_Offset_List)
P3D.OldOffsetListP3DChunk.new = new
function P3D.OldOffsetListP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos
	num, chunk.KeyIndex, pos = string_unpack(Endian .. "II", chunk.ValueStr)
	
	chunk.Offsets = {}
	for i=1,num do
		local offset = {}
		offset.Offset = {}
		offset.Index, offset.Offset.X, offset.Offset.Y, offset.Offset.Z, pos = string_unpack(Endian .. "Ifff", chunk.ValueStr, pos)
		chunk.Offsets[i] = offset
	end
	
	chunk.PrimGroupIndex = string_unpack(Endian .. "I", chunk.ValueStr, pos)
	
	return chunk
end

function P3D.OldOffsetListP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local offsetsN = #self.Offsets
	local offsets = {}
	for i=1,offsetsN do
		local offset = self.Offsets[i]
		offsets[i] = string_pack(self.Endian .. "Ifff", offset.Index, offset.Offset.X, offset.Offset.Y, offset.Offset.Z)
	end
	local offsetsData = table_concat(offsets)
	local offsetsDataLen = #offsetsData
	
	local headerLen = 12 + 4 + 4 + offsetsDataLen + 4
	return string_pack(self.Endian .. "IIIIIc" .. offsetsDataLen .. "I", self.Identifier, headerLen, headerLen + #chunkData, offsetsN, self.KeyIndex, offsetsData, self.PrimGroupIndex) .. chunkData
end