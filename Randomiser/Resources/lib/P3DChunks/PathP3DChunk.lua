--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.PathP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Positions)
	assert(type(Positions) == "table", "Arg #1 (Positions) must be a table")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Positions = Positions
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.PathP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Path)
P3D.PathP3DChunk.new = new
function P3D.PathP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos = string_unpack(Endian .. "I", chunk.ValueStr)
	
	chunk.Positions = {}
	for i=1,num do
		local position = {}
		position.X, position.Y, position.Z, pos = string_unpack(Endian .. "fff", chunk.ValueStr, pos)
		chunk.Positions[i] = position
	end
	
	return chunk
end

function P3D.PathP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local positionsN = #self.Positions
	local positions = {}
	for i=1,positionsN do
		local position = self.Positions[i]
		positions[i] = string_pack(self.Endian .. "fff", position.X, position.Y, position.Z)
	end
	local positionsData = table_concat(positions)
	
	local headerLen = 12 + 4 + positionsN * 12
	return string_pack(self.Endian .. "IIII", self.Identifier, headerLen, headerLen + #chunkData, positionsN) .. positionsData .. chunkData
end