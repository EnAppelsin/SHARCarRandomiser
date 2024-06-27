--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.FrontendStringTextBibleP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, BibleName, StringID)
	assert(type(BibleName) == "string", "Arg #1 (BibleName) must be a string")
	assert(type(StringID) == "string", "Arg #2 (StringID) must be a string")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		BibleName = BibleName,
		StringID = StringID
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.FrontendStringTextBibleP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Frontend_String_Text_Bible)
P3D.FrontendStringTextBibleP3DChunk.new = new
function P3D.FrontendStringTextBibleP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	chunk.BibleName, chunk.StringID = string_unpack(Endian .. "s1s1", chunk.ValueStr)
	chunk.BibleName = P3D.CleanP3DString(chunk.BibleName)
	chunk.StringID = P3D.CleanP3DString(chunk.StringID)
	
	return chunk
end

function P3D.FrontendStringTextBibleP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local BibleName = P3D.MakeP3DString(self.BibleName)
	local StringID = P3D.MakeP3DString(self.StringID)
	
	local headerLen = 12 + #BibleName + 1 + #StringID + 1
	return string_pack(self.Endian .. "IIIs1s1", self.Identifier, headerLen, headerLen + #chunkData, BibleName, StringID) .. chunkData
end