--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.Vector1DOFChannelP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Version, Param, Mapping, Constants, Frames, Values)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number")
	assert(type(Param) == "string", "Arg #2 (Param) must be a string")
	assert(type(Mapping) == "table", "Arg #3 (Mapping) must be a table")
	assert(type(Constants) == "number", "Arg #4 (Constants) must be a number")
	assert(type(Frames) == "table", "Arg #5 (Frames) must be a table")
	assert(type(Values) == "table", "Arg #6 (Values) must be a table")
	assert(#Frames == #Values, "Arg #5 (Frames) and Arg #6 (Values) must be of the same length")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Version = Version,
		Param = Param,
		Mapping = Mapping,
		Constants = Constants,
		Frames = Frames,
		Values = Values
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.Vector1DOFChannelP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Vector_1D_OF_Channel)
P3D.Vector1DOFChannelP3DChunk.new = new
function P3D.Vector1DOFChannelP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos
	chunk.Constants = {}
	chunk.Version, chunk.Param, chunk.Mapping, chunk.Constants.X, chunk.Constants.Y, chunk.Constants.Z, num, pos = string_unpack(Endian .. "Ic4HfffI", chunk.ValueStr)
	if Endian == ">" then
		chunk.Param = string_reverse(chunk.Param)
	end
	
	chunk.Frames = {string_unpack(Endian .. string_rep("H", num), chunk.ValueStr, pos)}
	pos = chunk.Frames[num + 1]
	chunk.Frames[num + 1] = nil
	
	chunk.Values = {string_unpack(Endian .. string_rep("f", num), chunk.ValueStr, pos)}
	chunk.Values[num + 1] = nil
	
	return chunk
end

function P3D.Vector1DOFChannelP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Param = self.Param
	if self.Endian == ">" then
		Param = string_reverse(Param)
	end
	
	local num = #self.Frames
	local values = {}
	for i=1,num do
		values[i] = self.Frames[i]
	end
	for i=1,num do
		values[num + i] = self.Values[i]
	end
	
	local headerLen = 12 + 4 + 4 + 2 + 12 + 4 + num * 2 + num * 4
	return string_pack(self.Endian .. "IIIIc4HfffI" .. string_rep("H", num) .. string_rep("f", num), self.Identifier, headerLen, headerLen + #chunkData, self.Version, Param, self.Mapping, self.Constants.X, self.Constants.Y, self.Constants.Z, num, table_unpack(values)) .. chunkData
end