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

local function new(self, Weights)
	assert(type(Weights) == "table", "Arg #1 (Weights) must be a table")
	
	local Data = {
		Chunks = {},
		Weights = Weights
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.WeightListP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Weight_List)
P3D.WeightListP3DChunk.new = new
function P3D.WeightListP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos = string_unpack("<I", chunk.ValueStr)
	
	chunk.Weights = {}
	for i=1,num do
		local weight = {}
		weight.X, weight.Y, weight.Z, pos = string_unpack("<fff", chunk.ValueStr, pos)
		chunk.Weights[i] = weight
	end
	
	return chunk
end

function P3D.WeightListP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local weightsN = #self.Weights
	local weights = {}
	for i=1,weightsN do
		local weight = self.Weights[i]
		weights[i] = string_pack("<fff", weight.X, weight.Y, weight.Z)
	end
	local weightsData = table_concat(weights)
	
	local headerLen = 12 + 4 + weightsN * 12
	return string_pack("<IIII", self.Identifier, headerLen, headerLen + #chunkData, weightsN) .. weightsData .. chunkData
end