--[[
CREDITS:
	Proddy#7272				- Converting to Lua, P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.OldColourOffsetListP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Version, Offsets)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number")
	assert(type(Offsets) == "table", "Arg #2 (Offsets) must be a table")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Version = Version,
		Offsets = Offsets,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.OldColourOffsetListP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Old_Colour_Offset_List)
P3D.OldColourOffsetListP3DChunk.new = new
function P3D.OldColourOffsetListP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos
	chunk.Version, num, pos = string_unpack(Endian .. "II", chunk.ValueStr)
	
	chunk.Offsets = {}
	for i=1,num do
		local offset = {}
		if Endian == ">" then
			offset.A, offset.R, offset.G, offset.B, pos = string_unpack(Endian .. "BBBB", chunk.ValueStr, pos)
		else
			offset.B, offset.G, offset.R, offset.A, pos = string_unpack(Endian .. "BBBB", chunk.ValueStr, pos)
		end
		chunk.Offsets[i] = offset
	end
	
	return chunk
end

function P3D.OldColourOffsetListP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local offsetsN = #self.Offsets
	local offsets = {}
	for i=1,offsetsN do
		local offset = self.Offsets[i]
		offsets[i] = string_pack(self.Endian .. "BBBB", offset.B, offset.G, offset.R, offset.A)
		if self.Endian == ">" then
			offsets[i] = string_pack(self.Endian .. "BBBB", offset.A, offset.R, offset.G, offset.B)
		else
			offsets[i] = string_pack(self.Endian .. "BBBB", offset.B, offset.G, offset.R, offset.A)
		end
	end
	local offsetsData = table_concat(offsets)
	
	local headerLen = 12 + 4 + 4 + offsetsN * 4
	return string_pack(self.Endian .. "IIIII", self.Identifier, headerLen, headerLen + #chunkData, self.Version, offsetsN) .. offsetsData .. chunkData
end