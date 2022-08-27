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

local function new(self, Version, Param, Frames, Values)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number")
	assert(type(Param) == "string", "Arg #2 (Param) must be a string")
	assert(type(Frames) == "table", "Arg #3 (Frames) must be a table")
	assert(type(Values) == "table", "Arg #4 (Values) must be a table")
	assert(#Frames == #Values, "Arg #3 (Frames) and Arg #4 (Values) must have the same length")
	
	local Data = {
		Chunks = {},
		Version = Version,
		Param = Param,
		Frames = Frames,
		Values = Values
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.CompressedQuaternionChannelP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Compressed_Quaternion_Channel)
P3D.CompressedQuaternionChannelP3DChunk.new = new
function P3D.CompressedQuaternionChannelP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local numFrames, pos
	chunk.Version, chunk.Param, numFrames, pos = string_unpack("<Ic4I", chunk.ValueStr)
	
	chunk.Frames = table_pack(string_unpack("<" .. string_rep("H", numFrames), chunk.ValueStr, pos))
	pos = chunk.Frames[numFrames + 1]
	chunk.Frames[numFrames + 1] = nil
	
	chunk.Values = {}
	for i=1,numFrames do
		local value = {}
		value.W, value.X, value.Y, value.Z, pos = string_unpack("<hhhh", chunk.ValueStr, pos)
		value.W = value.W / 32767
		value.X = value.X / 32767
		value.Y = value.Y / 32767
		value.Z = value.Z / 32767
		chunk.Values[i] = value
	end
	
	return chunk
end

local math_floor = math.floor
local function round(val)
	return math_floor(val + 0.5)
end

function P3D.CompressedQuaternionChannelP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local framesN = #self.Frames
	local values = {}
	for i=1,framesN do
		local value = self.Values[i]
		values[i] = string_pack("<hhhh", round(value.W * 32767), round(value.X * 32767), round(value.Y * 32767), round(value.Z * 32767))
	end
	local valuesData = table_concat(values)
	
	local headerLen = 12 + 4 + 4 + 4 + framesN * 2 + framesN * 8
	return string_pack("<IIIIc4I" .. string_rep("H", framesN), self.Identifier, headerLen, headerLen + #chunkData, self.Version, self.Param, framesN, table_unpack(self.Frames)) .. valuesData .. chunkData
end