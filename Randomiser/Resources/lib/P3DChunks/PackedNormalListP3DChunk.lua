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

P3D.PackedNormalListP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Packed_Normal_List)
P3D.PackedNormalListP3DChunk.new = new
function P3D.PackedNormalListP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos = string_unpack("<I", chunk.ValueStr)
	
	chunk.Normals = table_pack(string_unpack("<" .. string_rep("B", num), chunk.ValueStr, pos))
	chunk.Normals[num + 1] = nil
	
	return chunk
end

function P3D.PackedNormalListP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local normalsN = #self.Normals
	
	local headerLen = 12 + 4 + normalsN
	return string_pack("<IIII" .. string_rep("B", normalsN), self.Identifier, headerLen, headerLen + #chunkData, normalsN, table_unpack(self.Normals)) .. chunkData
end