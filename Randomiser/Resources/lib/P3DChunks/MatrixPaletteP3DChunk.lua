--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.MatrixPaletteP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Matrices)
	assert(type(Matrices) == "table", "Arg #1 (Matrices) must be a table")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Matrices = Matrices,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.MatrixPaletteP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Matrix_Palette)
P3D.MatrixPaletteP3DChunk.new = new
function P3D.MatrixPaletteP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos = string_unpack(Endian .. "I", chunk.ValueStr)
	
	chunk.Matrices = {string_unpack(Endian .. string_rep("I", num), chunk.ValueStr, pos)}
	chunk.Matrices[num + 1] = nil
	
	return chunk
end

function P3D.MatrixPaletteP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local matricesN = #self.Matrices
	
	local headerLen = 12 + 4 + matricesN * 4
	return string_pack(self.Endian .. "IIII" .. string_rep("I", matricesN), self.Identifier, headerLen, headerLen + #chunkData, matricesN, table_unpack(self.Matrices)) .. chunkData
end