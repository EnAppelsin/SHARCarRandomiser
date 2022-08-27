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

local function new(self, StaticAttribute, DefaultArea, CanRoll, CanSlide, CanSpin, CanBounce, ExtraAttribute1, ExtraAttribute2, ExtraAttribute3)
	assert(type(StaticAttribute) == "number", "Arg #1 (StaticAttribute) must be a number")
	assert(type(DefaultArea) == "number", "Arg #2 (DefaultArea) must be a number")
	assert(type(CanRoll) == "number", "Arg #3 (CanRoll) must be a number")
	assert(type(CanSlide) == "number", "Arg #4 (CanSlide) must be a number")
	assert(type(CanSpin) == "number", "Arg #5 (CanSpin) must be a number")
	assert(type(CanBounce) == "number", "Arg #6 (CanBounce) must be a number")
	assert(type(ExtraAttribute1) == "number", "Arg #7 (ExtraAttribute1) must be a number")
	assert(type(ExtraAttribute2) == "number", "Arg #8 (ExtraAttribute2) must be a number")
	assert(type(ExtraAttribute3) == "number", "Arg #9 (ExtraAttribute3) must be a number")
	
	local Data = {
		Chunks = {},
		StaticAttribute = StaticAttribute,
		DefaultArea = DefaultArea,
		CanRoll = CanRoll,
		CanSlide = CanSlide,
		CanSpin = CanSpin,
		CanBounce = CanBounce,
		ExtraAttribute1 = ExtraAttribute1,
		ExtraAttribute2 = ExtraAttribute2,
		ExtraAttribute3 = ExtraAttribute3,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.CollisionObjectAttributeP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Collision_Object_Attribute)
P3D.CollisionObjectAttributeP3DChunk.new = new
function P3D.CollisionObjectAttributeP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.StaticAttribute, chunk.DefaultArea, chunk.CanRoll, chunk.CanSlide, chunk.CanSpin, chunk.CanBounce, chunk.ExtraAttribute1, chunk.ExtraAttribute2, chunk.ExtraAttribute3 = string_unpack("<HIHHHHIII", chunk.ValueStr)
	
	return chunk
end

function P3D.CollisionObjectAttributeP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 2 + 4 + 2 + 2 + 2 + 2 + 4 + 4 + 4
	return string_pack("<IIIHIHHHHIII", self.Identifier, headerLen, headerLen + #chunkData, self.StaticAttribute, self.DefaultArea, self.CanRoll, self.CanSlide, self.CanSpin, self.CanBounce, self.ExtraAttribute1, self.ExtraAttribute2, self.ExtraAttribute3) .. chunkData
end