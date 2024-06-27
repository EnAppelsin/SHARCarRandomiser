--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.UVListP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Channel, UVs)
	assert(type(Channel) == "number", "Arg #1 (Channel) must be a number")
	assert(type(UVs) == "table", "Arg #2 (UVs) must be a table")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Channel = Channel,
		UVs = UVs,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.UVListP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.UV_List)
P3D.UVListP3DChunk.new = new
function P3D.UVListP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos
	num, chunk.Channel, pos = string_unpack(Endian .. "II", chunk.ValueStr)
	
	chunk.UVs = {}
	for i=1,num do
		local UV = {}
		UV.X, UV.Y, pos = string_unpack(Endian .. "ff", chunk.ValueStr, pos)
		chunk.UVs[i] = UV
	end
	
	return chunk
end

function P3D.UVListP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local UVsN = #self.UVs
	local UVs = {}
	for i=1,UVsN do
		local UV = self.UVs[i]
		UVs[i] = string_pack(self.Endian .. "ff", UV.X, UV.Y)
	end
	local UVsData = table_concat(UVs)
	
	local headerLen = 12 + 4 + 4 + UVsN * 8
	return string_pack(self.Endian .. "IIIII", self.Identifier, headerLen, headerLen + #chunkData, UVsN, self.Channel) .. UVsData .. chunkData
end