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

P3D.GameAttributeColourParameterP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Game_Attribute_Colour_Parameter)
P3D.GameAttributeColourParameterP3DChunk.new = new
function P3D.GameAttributeColourParameterP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Value = {}
	chunk.ParameterName, chunk.Value.B, chunk.Value.G, chunk.Value.R, chunk.Value.A = string_unpack("<s1BBBB", chunk.ValueStr)
	chunk.ParameterName = P3D.CleanP3DString(chunk.ParameterName)
	
	return chunk
end

function P3D.GameAttributeColourParameterP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local ParameterName = P3D.MakeP3DString(self.ParameterName)
	
	local headerLen = 12 + #ParameterName + 1 + 4
	return string_pack("<IIIs1BBBB", self.Identifier, headerLen, headerLen + #chunkData, ParameterName, self.Value.B, self.Value.G, self.Value.R, self.Value.A) .. chunkData
end