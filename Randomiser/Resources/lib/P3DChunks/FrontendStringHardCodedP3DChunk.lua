--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.FrontendStringHardCodedP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, String)
	assert(type(String) == "string", "Arg #1 (String) must be a string")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		String = String
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.FrontendStringHardCodedP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Frontend_String_Hard_Coded)
P3D.FrontendStringHardCodedP3DChunk.new = new
function P3D.FrontendStringHardCodedP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	chunk.String = string_unpack(Endian .. "s1", chunk.ValueStr)
	chunk.String = P3D.CleanP3DString(chunk.String)
	
	return chunk
end

function P3D.FrontendStringHardCodedP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local String = P3D.MakeP3DString(self.String)
	
	local headerLen = 12 + #String + 1
	return string_pack(self.Endian .. "IIIs1", self.Identifier, headerLen, headerLen + #chunkData, String) .. chunkData
end