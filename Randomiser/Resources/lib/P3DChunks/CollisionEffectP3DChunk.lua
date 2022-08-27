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

local function new(self, ClassType, PhyPropID, SoundResourceDataName)
	assert(type(ClassType) == "number", "Arg #1 (ClassType) must be a number")
	assert(type(PhyPropID) == "number", "Arg #2 (PhyPropID) must be a number")
	assert(type(SoundResourceDataName) == "string", "Arg #3 (SoundResourceDataName) must be a string")
	
	local Data = {
		Chunks = {},
		ClassType = ClassType,
		PhyPropID = PhyPropID,
		SoundResourceDataName = SoundResourceDataName
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.CollisionEffectP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Collision_Effect)
P3D.CollisionEffectP3DChunk.new = new
function P3D.CollisionEffectP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.ClassType, chunk.PhyPropID, chunk.SoundResourceDataName = string_unpack("<IIs1", chunk.ValueStr)
	chunk.SoundResourceDataName = P3D.CleanP3DString(chunk.SoundResourceDataName)
	
	return chunk
end

function P3D.CollisionEffectP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local SoundResourceDataName = P3D.MakeP3DString(self.SoundResourceDataName)
	
	local headerLen = 12 + 4 + 4 + #SoundResourceDataName + 1
	return string_pack("<IIIIIs1", self.Identifier, headerLen, headerLen + #chunkData, self.ClassType, self.PhyPropID, SoundResourceDataName) .. chunkData
end