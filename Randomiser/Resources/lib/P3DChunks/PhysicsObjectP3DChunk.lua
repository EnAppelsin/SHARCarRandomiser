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

local function new(self, Name, Version, MaterialName, NumJoints, Volume, RestingSensitivity)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Version) == "number", "Arg #2 (Version) must be a number")
	assert(type(MaterialName) == "string", "Arg #3 (MaterialName) must be a string")
	assert(type(NumJoints) == "number", "Arg #4 (NumJoints) must be a number")
	assert(type(Volume) == "number", "Arg #5 (Volume) must be a number")
	assert(type(RestingSensitivity) == "number", "Arg #6 (RestingSensitivity) must be a number")
	
	local Data = {
		Chunks = {},
		Name = Name,
		Version = Version,
		MaterialName = MaterialName,
		NumJoints = NumJoints,
		Volume = Volume,
		RestingSensitivity = RestingSensitivity
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.PhysicsObjectP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Physics_Object)
P3D.PhysicsObjectP3DChunk.new = new
function P3D.PhysicsObjectP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local pos
	chunk.Name, chunk.Version, chunk.MaterialName, chunk.NumJoints, chunk.Volume, chunk.RestingSensitivity, pos = string_unpack("<s1Is1Iff", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	chunk.MaterialName = P3D.CleanP3DString(chunk.MaterialName)
	
	return chunk, pos + 11
end

function P3D.PhysicsObjectP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local MaterialName = P3D.MakeP3DString(self.MaterialName)
	
	local headerLen = 12 + #Name + 1 + 4 + #MaterialName + 1 + 4 + 4 + 4
	return string_pack("<IIIs1Is1Iff", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Version, MaterialName, self.NumJoints, self.Volume, self.RestingSensitivity) .. chunkData
end