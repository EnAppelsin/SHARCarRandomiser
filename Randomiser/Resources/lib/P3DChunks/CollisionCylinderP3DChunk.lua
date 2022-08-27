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

local function new(self, CylinderRadius, Length, FlatEnd)
	assert(type(CylinderRadius) == "number", "Arg #1 (CylinderRadius) must be a number")
	assert(type(Length) == "number", "Arg #2 (Length) must be a number")
	assert(type(FlatEnd) == "number", "Arg #3 (FlatEnd) must be a number")
	
	local Data = {
		Chunks = {},
		CylinderRadius = CylinderRadius,
		Length = Length,
		FlatEnd = FlatEnd
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.CollisionCylinderP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Collision_Cylinder)
P3D.CollisionCylinderP3DChunk.new = new
function P3D.CollisionCylinderP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.CylinderRadius, chunk.Length, chunk.FlatEnd = string_unpack("<ffH", chunk.ValueStr)
	
	return chunk
end

function P3D.CollisionCylinderP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 4 + 4 + 2
	return string_pack("<IIIffH", self.Identifier, headerLen, headerLen + #chunkData, self.CylinderRadius, self.Length, self.FlatEnd) .. chunkData
end