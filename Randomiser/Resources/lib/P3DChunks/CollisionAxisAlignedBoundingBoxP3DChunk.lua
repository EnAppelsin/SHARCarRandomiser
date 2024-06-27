--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.CollisionAxisAlignedBoundingBoxP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Nothing)
	assert(type(Nothing) == "number", "Arg #1 (Nothing) must be a number")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Nothing = Nothing,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.CollisionAxisAlignedBoundingBoxP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Collision_Axis_Aligned_Bounding_Box)
P3D.CollisionAxisAlignedBoundingBoxP3DChunk.new = new
function P3D.CollisionAxisAlignedBoundingBoxP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Nothing = string_unpack(Endian .. "I", chunk.ValueStr)
	
	return chunk
end

function P3D.CollisionAxisAlignedBoundingBoxP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 4
	return string_pack(self.Endian .. "IIII", self.Identifier, headerLen, headerLen + #chunkData, self.Nothing) .. chunkData
end