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

local function new(self, Version, Param, Mapping, Constants, Frames, Values)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number")
	assert(type(Param) == "string", "Arg #2 (Param) must be a string")
	assert(type(Mapping) == "table", "Arg #3 (Mapping) must be a table")
	assert(type(Constants) == "number", "Arg #4 (Constants) must be a number")
	assert(type(Frames) == "table", "Arg #5 (Frames) must be a table")
	assert(type(Values) == "table", "Arg #6 (Values) must be a table")
	assert(#Frames == #Values, "Arg #5 (Frames) and Arg #6 (Values) must be of the same length")
	
	local Data = {
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

P3D.Vector2DOFChannelP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Vector_2D_OF_Channel)
P3D.Vector2DOFChannelP3DChunk.new = new
function P3D.Vector2DOFChannelP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos
	chunk.Constants = {}
	chunk.Version, chunk.Param, chunk.Mapping, chunk.Constants.X, chunk.Constants.Y, chunk.Constants.Z, num, pos = string_unpack("<Ic4HfffI", chunk.ValueStr)
	
	chunk.Frames = table_pack(string_unpack("<" .. string_rep("H", num), chunk.ValueStr, pos))
	pos = chunk.Frames[num + 1]
	chunk.Frames[num + 1] = nil
	
	chunk.Values = {}
	for i=1,num do
		local value = {}
		value.X, value.Y, pos = string_unpack("<ff", chunk.ValueStr, pos)
		chunk.Values[i] = value
	end
	
	return chunk
end

function P3D.Vector2DOFChannelP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local num = #self.Frames
	local values = {}
	for i=1,num do
		values[i] = self.Frames[i]
	end
	for i=1,num do
		local value = self.Values[i]
		values[num + i] = string_pack("<ff", value.X, value.Y)
	end
	
	local headerLen = 12 + 4 + 4 + 2 + 12 + 4 + num * 2 + num * 8
	return string_pack("<IIIIc4HfffI" .. string_rep("H", num) .. string_rep("c8", num), self.Identifier, headerLen, headerLen + #chunkData, self.Version, self.Param, self.Mapping, self.Constants.X, self.Constants.Y, self.Constants.Z, num, table_unpack(values)) .. chunkData
end