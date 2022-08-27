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

local function new(self, Indices, Positions, Normals)
	assert(type(Indices) == "table", "Arg #1 (Indices) must be a table")
	assert(type(Positions) == "table", "Arg #2 (Positions) must be a table")
	assert(type(Normals) == "table", "Arg #3 (Normals) must be a table")
	assert(#Indices == #Positions, "Arg #1 (Indices) and Arg #2 (Positions) must have the same length")
	assert(#Indices == #Normals, "Arg #1 (Indices) and Arg #3 (Normals) must have the same length")
	
	local Data = {
		Chunks = {},
		Indices = Indices,
		Positions = Positions,
		Normals = Normals
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.IntersectP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Intersect)
P3D.IntersectP3DChunk.new = new
function P3D.IntersectP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos = string_unpack("<I", chunk.ValueStr)
	
	chunk.Indices = table_pack(string_unpack("<" .. string_rep("I", num), chunk.ValueStr, pos))
	pos = chunk.Indices[num + 1]
	chunk.Indices[num + 1] = nil
	
	num, pos = string_unpack("<I", chunk.ValueStr, pos)
	chunk.Positions = {}
	for i=1,num do
		local Position = {}
		Position.X, Position.Y, Position.Z, pos = string_unpack("<fff", chunk.ValueStr, pos)
		chunk.Positions[i] = Position
	end
	
	num, pos = string_unpack("<I", chunk.ValueStr, pos)
	chunk.Normals = {}
	for i=1,num do
		local Normal = {}
		Normal.X, Normal.Y, Normal.Z, pos = string_unpack("<fff", chunk.ValueStr, pos)
		chunk.Normals[i] = Normal
	end
	
	return chunk
end

function P3D.IntersectP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local indicesN = #self.Indices
	
	local positionsN = #self.Positions
	local positions = {}
	for i=1,positionsN do
		local position = self.Positions[i]
		positions[i] = string_pack("<fff", position.X, position.Y, position.Z)
	end
	local positionsData = table_concat(positions)
	local positionsLength = positionsN * 12
	
	local normalsN = #self.Normals
	local normals = {}
	for i=1,normalsN do
		local normal = self.Normals[i]
		normals[i] = string_pack("<fff", normal.X, normal.Y, normal.Z)
	end
	local normalsData = table_concat(normals)
	local normalsLength = normalsN * 12
	
	local values = {}
	for i=1,indicesN do
		values[i] = self.Indices[i]
	end
	local n = indicesN + 1
	values[n] = positionsN
	values[n + 1] = positionsData
	values[n + 2] = normalsN
	values[n + 3] = normalsData
	
	local headerLen = 12 + 4 + indicesN * 4 + 4 + positionsLength + 4 + normalsLength
	return string_pack("<IIII" .. string_rep("I", indicesN) .. "Ic" .. positionsLength .. "Ic" .. normalsLength, self.Identifier, headerLen, headerLen + #chunkData, indicesN, table_unpack(values)) .. chunkData
end