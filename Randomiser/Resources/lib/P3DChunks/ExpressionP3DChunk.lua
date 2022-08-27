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

local function new(self, Version, Name, Keys, Indices)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number")
	assert(type(Name) == "string", "Arg #2 (Name) must be a string")
	assert(type(Keys) == "table", "Arg #3 (Keys) must be a table")
	assert(type(Indices) == "table", "Arg #4 (Indices) must be a table")
	assert(#Keys == #Indices, "Arg #3 (Keys) and Arg #4 (Indices) must be of equal length")
	
	local Data = {
		Chunks = {},
		Version = Version,
		Name = Name,
		Keys = Keys,
		Indices = Indices
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.ExpressionP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Expression)
P3D.ExpressionP3DChunk.new = new
function P3D.ExpressionP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos
	chunk.Version, chunk.Name, num, pos = string_unpack("<Is1I", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	
	chunk.Keys = table_pack(string_unpack("<" .. string_rep("f", num), chunk.ValueStr, pos))
	pos = chunk.Keys[num + 1]
	chunk.Keys[num + 1] = nil
	
	chunk.Indices = table_pack(string_unpack("<" .. string_rep("I", num), chunk.ValueStr, pos))
	chunk.Indices[num + 1] = nil
	
	return chunk
end

function P3D.ExpressionP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local keysN = #self.Keys
	local values = {}
	for i=1,keysN do
		values[i] = self.Keys[i]
	end
	for i=1,keysN do
		values[keysN + i] = self.Indices[i]
	end
	
	local headerLen = 12 + 4 + #Name + 1 + 4 + keysN * 4 + keysN * 4
	return string_pack("<IIIIs1I" .. string_rep("f", keysN) .. string_rep("I", keysN), self.Identifier, headerLen, headerLen + #chunkData, self.Version, Name, keysN, table_unpack(values)) .. chunkData
end