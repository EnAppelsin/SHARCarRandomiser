--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.BooleanChannelP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Version, Param, StartState, Values)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number")
	assert(type(Param) == "string", "Arg #2 (Param) must be a string")
	assert(type(StartState) == "number", "Arg #3 (StartState) must be a number")
	assert(type(Values) == "table", "Arg #4 (Values) must be a table")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Version = Version,
		Param = Param,
		StartState = StartState,
		Values = Values
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.BooleanChannelP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Boolean_Channel)
P3D.BooleanChannelP3DChunk.new = new
function P3D.BooleanChannelP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	local numFrames, pos
	chunk.Version, chunk.Param, chunk.StartState, numFrames, pos = string_unpack(Endian .. "Ic4HI", chunk.ValueStr)
	if Endian == ">" then
		chunk.Param = string_reverse(chunk.Param)
	end
	
	chunk.Values = {string_unpack(Endian .. string_rep("H", numFrames), chunk.ValueStr, pos)}
	chunk.Values[numFrames + 1] = nil
	
	return chunk
end

function P3D.BooleanChannelP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Param = self.Param
	if self.Endian == ">" then
		Param = string_reverse(Param)
	end
	
	local valuesN = #self.Values
	local headerLen = 12 + 4 + 4 + 2 + 4 + valuesN * 2
	return string_pack(self.Endian .. "IIIIc4HI" .. string_rep("H", valuesN), self.Identifier, headerLen, headerLen + #chunkData, self.Version, Param, self.StartState, valuesN, table_unpack(self.Values)) .. chunkData
end