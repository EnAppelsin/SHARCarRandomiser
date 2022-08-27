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

local function new(self, Param, Value)
	assert(type(Param) == "string", "Arg #1 (Param) must be a string.")
	assert(type(Value) == "table", "Arg #2 (Value) must be a table.")

	local Data = {
		Chunks = {},
		Param = Param,
		Value = Value,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.ShaderColourParameterP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Shader_Colour_Parameter)
P3D.ShaderColourParameterP3DChunk.new = new
function P3D.ShaderColourParameterP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Value = {}
	chunk.Param, chunk.Value.B, chunk.Value.G, chunk.Value.R, chunk.Value.A = string_unpack("<c4BBBB", chunk.ValueStr)

	return chunk
end

function P3D.ShaderColourParameterP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 4 + 4
	return string_pack("<IIIc4BBBB", self.Identifier, headerLen, headerLen + #chunkData, self.Param, self.Value.B, self.Value.G, self.Value.R, self.Value.A) .. chunkData
end