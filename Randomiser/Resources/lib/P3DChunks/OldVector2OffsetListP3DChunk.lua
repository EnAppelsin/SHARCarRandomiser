--[[
CREDITS:
	Proddy#7272				- Converting to Lua, P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.OldVector2OffsetListP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Version, Offsets, Param)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number")
	assert(type(Offsets) == "table", "Arg #2 (Offsets) must be a table")
	assert(type(Param) == "string", "Arg #3 (Param) must be a string")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Version = Version,
		Offsets = Offsets,
		Param = Param,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.OldVector2OffsetListP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Old_Vector2_Offset_List)
P3D.OldVector2OffsetListP3DChunk.new = new
function P3D.OldVector2OffsetListP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos
	chunk.Version, num, chunk.Param, pos = string_unpack(Endian .. "IIc4", chunk.ValueStr)
	if Endian == ">" then
		chunk.Param = string_reverse(chunk.Param)
	end
	
	chunk.Offsets = {}
	for i=1,num do
		local offset = {}
		offset.X, offset.Y, pos = string_unpack(Endian .. "ff", chunk.ValueStr, pos)
		chunk.Offsets[i] = offset
	end
	
	return chunk
end

function P3D.OldVector2OffsetListP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Param = self.Param
	if self.Endian == ">" then
		Param = string_reverse(Param)
	end
	
	local offsetsN = #self.Offsets
	local offsets = {}
	for i=1,offsetsN do
		local offset = self.Offsets[i]
		offsets[i] = string_pack(self.Endian .. "ff", offset.X, offset.Y)
	end
	local offsetsData = table_concat(offsets)
	
	local headerLen = 12 + 4 + 4 + 4 + offsetsN * 8
	return string_pack(self.Endian .. "IIIIIc4", self.Identifier, headerLen, headerLen + #chunkData, self.Version, offsetsN, Param) .. offsetsData .. chunkData
end