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

local function new(self, Version, Offsets)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number")
	assert(type(Offsets) == "table", "Arg #2 (Offsets) must be a table")
	
	local Data = {
		Chunks = {},
		Version = Version,
		Offsets = Offsets,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.OldColourOffsetListP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Old_Colour_Offset_List)
P3D.OldColourOffsetListP3DChunk.new = new
function P3D.OldColourOffsetListP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos
	chunk.Version, num, pos = string_unpack("<II", chunk.ValueStr)
	
	chunk.Offsets = {}
	for i=1,num do
		local offset = {}
		offset.B, offset.G, offset.R, offset.A, pos = string_unpack("<BBBB", chunk.ValueStr, pos)
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
		offsets[i] = string_pack("<BBBB", offset.B, offset.G, offset.R, offset.A)
	end
	local offsetsData = table_concat(offsets)
	
	local headerLen = 12 + 4 + 4 + offsetsN * 4
	return string_pack("<IIIII", self.Identifier, headerLen, headerLen + #chunkData, self.Version, offsetsN) .. offsetsData .. chunkData
end