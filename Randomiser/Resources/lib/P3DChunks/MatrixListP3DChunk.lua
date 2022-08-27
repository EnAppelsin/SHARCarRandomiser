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

local function new(self, Matrices)
	assert(type(Matrices) == "table", "Arg #1 (Matrices) must be a table")
	
	local Data = {
		Chunks = {},
		Matrices = Matrices,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.MatrixListP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Matrix_List)
P3D.MatrixListP3DChunk.new = new
function P3D.MatrixListP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos = string_unpack("<I", chunk.ValueStr)
	
	chunk.Matrices = {}
	for i=1,num do
		local colour = {}
		colour.B, colour.G, colour.R, colour.A, pos = string_unpack("<BBBB", chunk.ValueStr, pos)
		chunk.Matrices[i] = colour
	end
	
	return chunk
end

function P3D.MatrixListP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local matricesN = #self.Matrices
	local matrices = {}
	for i=1,matricesN do
		local colour = self.Matrices[i]
		matrices[i] = string_pack("<BBBB", colour.B, colour.G, colour.R, colour.A)
	end
	local matricesData = table_concat(matrices)
	
	local headerLen = 12 + 4 + matricesN * 4
	return string_pack("<IIII", self.Identifier, headerLen, headerLen + #chunkData, matricesN) .. matricesData .. chunkData
end