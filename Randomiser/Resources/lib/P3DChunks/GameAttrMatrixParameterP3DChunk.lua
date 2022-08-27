--[[
CREDITS:
	Proddy#7272				- Converting to Lua, P3D Chunk Structure
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

local function new(self, ParameterName, Value)
	assert(type(ParameterName) == "string", "Arg #1 (ParameterName) must be a string")
	assert(type(Value) == "table", "Arg #2 (Value) must be a table")
	
	local Data = {
		Chunks = {},
		ParameterName = ParameterName,
		Value = Value
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.GameAttributeMatrixParameterP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Game_Attribute_Matrix_Parameter)
P3D.GameAttributeMatrixParameterP3DChunk.new = new
function P3D.GameAttributeMatrixParameterP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Value = {}
	chunk.ParameterName, chunk.Value.M11, chunk.Value.M12, chunk.Value.M13, chunk.Value.M14, chunk.Value.M21, chunk.Value.M22, chunk.Value.M23, chunk.Value.M24, chunk.Value.M31, chunk.Value.M32, chunk.Value.M33, chunk.Value.M34, chunk.Value.M41, chunk.Value.M42, chunk.Value.M43, chunk.Value.M44 = string_unpack("<s1ffffffffffffffff", chunk.ValueStr)
	chunk.ParameterName = P3D.CleanP3DString(chunk.ParameterName)
	
	return chunk
end

function P3D.GameAttributeMatrixParameterP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local ParameterName = P3D.MakeP3DString(self.ParameterName)
	
	local headerLen = 12 + #ParameterName + 1 + 36
	return string_pack("<IIIs1ffffffffffffffff", self.Identifier, headerLen, headerLen + #chunkData, ParameterName, self.Value.M11, self.Value.M12, self.Value.M13, self.Value.M14, self.Value.M21, self.Value.M22, self.Value.M23, self.Value.M24, self.Value.M31, self.Value.M32, self.Value.M33, self.Value.M34, self.Value.M41, self.Value.M42, self.Value.M43, self.Value.M44) .. chunkData
end