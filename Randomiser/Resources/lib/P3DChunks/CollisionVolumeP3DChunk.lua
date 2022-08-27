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

local function new(self, ObjectReferenceIndex, OwnerIndex)
	assert(type(ObjectReferenceIndex) == "number", "Arg #1 (ObjectReferenceIndex) must be a number")
	assert(type(OwnerIndex) == "number", "Arg #2 (OwnerIndex) must be a number")
	
	local Data = {
		Chunks = {},
		ObjectReferenceIndex = ObjectReferenceIndex,
		OwnerIndex = OwnerIndex
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.CollisionVolumeP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Collision_Volume)
P3D.CollisionVolumeP3DChunk.new = new
function P3D.CollisionVolumeP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.ObjectReferenceIndex, chunk.OwnerIndex = string_unpack("<Ii", chunk.ValueStr)
	
	return chunk
end

function P3D.CollisionVolumeP3DChunk:GetNumSubVolumes()
	local n = 0
	for i=1,#self.Chunks do
		if self.Chunks[i].Identifier == self.Identifier then
			n = n + 1
		end
	end
	return n
end

function P3D.CollisionVolumeP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 4 + 4 + 4
	return string_pack("<IIIIiI", self.Identifier, headerLen, headerLen + #chunkData, self.ObjectReferenceIndex, self.OwnerIndex, self:GetNumSubVolumes()) .. chunkData
end