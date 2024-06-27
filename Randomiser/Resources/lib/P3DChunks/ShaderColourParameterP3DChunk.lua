--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.ShaderColourParameterP3DChunk == nil, "Chunk type already loaded.")

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
	assert(type(Value) == "table", "Arg #2 (Value) must be a table.")

	local Data = {
		Endian = "<",
		Chunks = {},
		Param = Param,
		Value = Value,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.ShaderColourParameterP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Shader_Colour_Parameter)
P3D.ShaderColourParameterP3DChunk.new = new
function P3D.ShaderColourParameterP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Value = {}
	chunk.Param, chunk.Value.B, chunk.Value.G, chunk.Value.R, chunk.Value.A = string_unpack(Endian .. "c4BBBB", chunk.ValueStr)
	if Endian == ">" then
		chunk.Param = string_reverse(chunk.Param)
		chunk.Value.B, chunk.Value.G, chunk.Value.R, chunk.Value.A = chunk.Value.A, chunk.Value.R, chunk.Value.G, chunk.Value.B
	end

	return chunk
end

function P3D.ShaderColourParameterP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Param = self.Param
	local Value = {}
	if self.Endian == ">" then
		Param = string_reverse(Param)
		Value.B, Value.G, Value.R, Value.A = self.Value.A, self.Value.R, self.Value.G, self.Value.B
	else
		Value.B, Value.G, Value.R, Value.A = self.Value.B, self.Value.G, self.Value.R, self.Value.A
	end
	
	local headerLen = 12 + 4 + 4
	return string_pack(self.Endian .. "IIIc4BBBB", self.Identifier, headerLen, headerLen + #chunkData, Param, Value.B, Value.G, Value.R, Value.A) .. chunkData
end