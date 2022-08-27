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

local function new(self, Index, MaxInstances)
	assert(type(Index) == "number", "Arg #1 (Index) must be a number")
	assert(type(MaxInstances) == "number", "Arg #2 (MaxInstances) must be a number")
	
	local Data = {
		Chunks = {},
		Index = Index,
		MaxInstances = MaxInstances
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.BreakableObjectP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Breakable_Object)
P3D.BreakableObjectP3DChunk.new = new
function P3D.BreakableObjectP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Index, chunk.MaxInstances = string_unpack("<II", chunk.ValueStr)
	
	return chunk
end

function P3D.BreakableObjectP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 4 + 4
	return string_pack("<IIIII", self.Identifier, headerLen, headerLen + #chunkData, self.Index, self.MaxInstances) .. chunkData
end