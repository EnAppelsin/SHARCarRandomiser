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

local function new(self, Normals)
	assert(type(Normals) == "table", "Arg #1 (Normals) must be a table")
	
	local Data = {
		Chunks = {},
		Normals = Normals
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.NormalListP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Normal_List)
P3D.NormalListP3DChunk.new = new
function P3D.NormalListP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos = string_unpack("<I", chunk.ValueStr)
	
	chunk.Normals = {}
	for i=1,num do
		local normal = {}
		normal.X, normal.Y, normal.Z, pos = string_unpack("<fff", chunk.ValueStr, pos)
		chunk.Normals[i] = normal
	end
	
	return chunk
end

function P3D.NormalListP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local normalsN = #self.Normals
	local normals = {}
	for i=1,normalsN do
		local normal = self.Normals[i]
		normals[i] = string_pack("<fff", normal.X, normal.Y, normal.Z)
	end
	local normalsData = table_concat(normals)
	
	local headerLen = 12 + 4 + normalsN * 12
	return string_pack("<IIII", self.Identifier, headerLen, headerLen + #chunkData, normalsN) .. normalsData .. chunkData
end