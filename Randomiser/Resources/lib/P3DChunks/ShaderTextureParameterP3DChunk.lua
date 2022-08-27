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
	assert(type(Value) == "string", "Arg #2 (Value) must be a string.")

	local Data = {
		Chunks = {},
		Param = Param,
		Value = Value,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.ShaderTextureParameterP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Shader_Texture_Parameter)
P3D.ShaderTextureParameterP3DChunk.new = new
function P3D.ShaderTextureParameterP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Param, chunk.Value = string_unpack("<c4s1", chunk.ValueStr)
	chunk.Value = P3D.CleanP3DString(chunk.Value)

	return chunk
end

function P3D.ShaderTextureParameterP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Value = P3D.MakeP3DString(self.Value)
	
	local headerLen = 12 + 4 + #Value + 1
	return string_pack("<IIIc4s1", self.Identifier, headerLen, headerLen + #chunkData, self.Param, Value) .. chunkData
end