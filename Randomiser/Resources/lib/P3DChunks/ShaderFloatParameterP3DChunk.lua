--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.ShaderFloatParameterP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Param, Value)
	assert(type(Param) == "string", "Arg #1 (Param) must be a string.")
	assert(#Param <= 4, "Arg #1 (Param) must be 4 characters or less.")
	assert(type(Value) == "number", "Arg #2 (Value) must be a number.")

	local Data = {
		Endian = "<",
		Chunks = {},
		Param = Param,
		Value = Value,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.ShaderFloatParameterP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Shader_Float_Parameter)
P3D.ShaderFloatParameterP3DChunk.new = new
function P3D.ShaderFloatParameterP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Param, chunk.Value = string_unpack(Endian .. "c4f", chunk.ValueStr)
	if Endian == ">" then
		chunk.Param = string_reverse(chunk.Param)
	end

	return chunk
end

function P3D.ShaderFloatParameterP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Param = self.Param
	if self.Endian == ">" then
		Param = string_reverse(Param)
	end
	
	local headerLen = 12 + 4 + 4
	return string_pack(self.Endian .. "IIIc4f", self.Identifier, headerLen, headerLen + #chunkData, Param, self.Value) .. chunkData
end