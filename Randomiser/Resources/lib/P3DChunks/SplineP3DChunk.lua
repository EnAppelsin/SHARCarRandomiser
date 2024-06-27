--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.SplineP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Name, Positions)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Positions) == "table", "Arg #2 (Positions) must be a table")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Name = Name,
		Positions = Positions
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.SplineP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Spline)
P3D.SplineP3DChunk.new = new
function P3D.SplineP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos
	chunk.Name, num, pos = string_unpack(Endian .. "s1I", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	
	chunk.Positions = {}
	for i=1,num do
		local position = {}
		position.X, position.Y, position.Z, pos = string_unpack(Endian .. "fff", chunk.ValueStr, pos)
		chunk.Positions[i] = position
	end
	
	return chunk
end

function P3D.SplineP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local positionsN = #self.Positions
	local positions = {}
	for i=1,positionsN do
		local position = self.Positions[i]
		positions[i] = string_pack(self.Endian .. "fff", position.X, position.Y, position.Z)
	end
	local positionsData = table_concat(positions)
	
	local headerLen = 12 + #Name + 1 + 4 + positionsN * 12
	return string_pack(self.Endian .. "IIIs1I", self.Identifier, headerLen, headerLen + #chunkData, Name, positionsN) .. positionsData .. chunkData
end