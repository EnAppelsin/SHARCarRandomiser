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

local function new(self, VertexShaderName)
	assert(type(VertexShaderName) == "string", "Arg #1 (VertexShaderName) must be a string.")

	local Data = {
		Chunks = {},
		VertexShaderName = VertexShaderName,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.VertexShaderP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Vertex_Shader)
P3D.VertexShaderP3DChunk.new = new
function P3D.VertexShaderP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.VertexShaderName = string_unpack("<s1", chunk.ValueStr)
	chunk.VertexShaderName = P3D.CleanP3DString(chunk.VertexShaderName)

	return chunk
end

function P3D.VertexShaderP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local VertexShaderName = P3D.MakeP3DString(self.VertexShaderName)
	
	local headerLen = 12 + #VertexShaderName + 1
	return string_pack("<IIIs1", self.Identifier, headerLen, headerLen + #chunkData, VertexShaderName) .. chunkData
end