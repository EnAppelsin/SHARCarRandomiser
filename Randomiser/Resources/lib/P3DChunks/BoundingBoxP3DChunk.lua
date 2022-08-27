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

local function new(self, Low, High)
	assert(type(Low) == "table", "Arg #1 (Low) must be a table")
	assert(type(High) == "table", "Arg #2 (High) must be a table")
	
	local Data = {
		Chunks = {},
		Low = Low,
		High = High
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.BoundingBoxP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Bounding_Box)
P3D.BoundingBoxP3DChunk.new = new
function P3D.BoundingBoxP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Low = {}
	chunk.High = {}
	chunk.Low.X, chunk.Low.Y, chunk.Low.Z, chunk.High.X, chunk.High.Y, chunk.High.Z = string_unpack("<ffffff", chunk.ValueStr)
	
	return chunk
end

function P3D.BoundingBoxP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 12 + 12
	return string_pack("<IIIffffff", self.Identifier, headerLen, headerLen + #chunkData, self.Low.X, self.Low.Y, self.Low.Z, self.High.X, self.High.Y, self.High.Z) .. chunkData
end