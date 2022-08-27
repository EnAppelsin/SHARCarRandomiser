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

local function new(self, Version, ChannelChunkID, NumKeys)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number.")
	assert(type(ChannelChunkID) == "number", "Arg #2 (ChannelChunkID) must be a number.")
	assert(type(NumKeys) == "table", "Arg #3 (NumKeys) must be a table.")

	local Data = {
		Chunks = {},
		Version = Version,
		ChannelChunkID = ChannelChunkID,
		NumKeys = NumKeys,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.AnimationChannelCountP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Animation_Channel_Count)
P3D.AnimationChannelCountP3DChunk.new = new
function P3D.AnimationChannelCountP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos
	chunk.Version, chunk.ChannelChunkID, num, pos = string_unpack("<III", chunk.ValueStr)
	
	chunk.NumKeys = table_pack(string_unpack("<" .. string_rep("H", num), chunk.ValueStr, pos))
	chunk.NumKeys[num + 1] = nil

	return chunk
end

function P3D.AnimationChannelCountP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local numKeysN = #self.NumKeys
	
	local headerLen = 12 + 4 + 4 + 4 + numKeysN * 2
	return string_pack("<IIIIII" .. string_rep("H", numKeysN), self.Identifier, headerLen, headerLen + #chunkData, self.Version, self.ChannelChunkID, numKeysN, table_unpack(self.NumKeys)) .. chunkData
end