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

local function new(self, Index, Volume, Stiffness, MaxAngle, MinAngle, DOF)
	assert(type(Index) == "number", "Arg #1 (Index) must be a number.")
	assert(type(Volume) == "number", "Arg #2 (Volume) must be a number.")
	assert(type(Stiffness) == "number", "Arg #3 (Stiffness) must be a number.")
	assert(type(MaxAngle) == "number", "Arg #4 (MaxAngle) must be a number.")
	assert(type(MinAngle) == "number", "Arg #5 (MinAngle) must be a number.")
	assert(type(DOF) == "number", "Arg #6 (DOF) must be a number.")

	local Data = {
		Chunks = {},
		Index = Index,
		Volume = Volume,
		Stiffness = Stiffness,
		MaxAngle = MaxAngle,
		MinAngle = MinAngle,
		DOF = DOF,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.PhysicsJointP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Physics_Joint)
P3D.PhysicsJointP3DChunk.new = new
function P3D.PhysicsJointP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Index, chunk.Volume, chunk.Stiffness, chunk.MaxAngle, chunk.MinAngle, chunk.DOF = string_unpack("<IffffI", chunk.ValueStr)

	return chunk
end

function P3D.PhysicsJointP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 4 + 4 + 4 + 4 + 4 + 4
	return string_pack("<IIIIffffI", self.Identifier, headerLen, headerLen + #chunkData, self.Index, self.Volume, self.Stiffness, self.MaxAngle, self.MinAngle, self.DOF) .. chunkData
end