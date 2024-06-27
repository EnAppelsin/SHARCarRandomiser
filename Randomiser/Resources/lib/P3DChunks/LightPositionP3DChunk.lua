--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.LightPositionP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Position)
	assert(type(Position) == "table", "Arg #1 (Position) must be a table")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Position = Position
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.LightPositionP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Light_Position)
P3D.LightPositionP3DChunk.new = new
function P3D.LightPositionP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Position = {}
	chunk.Position.X, chunk.Position.Y, chunk.Position.Z = string_unpack(Endian .. "fff", chunk.ValueStr)
	
	return chunk
end

function P3D.LightPositionP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 12
	return string_pack(self.Endian .. "IIIfff", self.Identifier, headerLen, headerLen + #chunkData, self.Position.X, self.Position.Y, self.Position.Z) .. chunkData
end