--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.OldParticleInstancingInfoP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Version, MaxInstances)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number.")
	assert(type(MaxInstances) == "number", "Arg #2 (MaxInstances) must be a number.")

	local Data = {
		Endian = "<",
		Chunks = {},
		Version = Version,
		MaxInstances = MaxInstances,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.OldParticleInstancingInfoP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Old_Particle_Instancing_Info)
P3D.OldParticleInstancingInfoP3DChunk.new = new
function P3D.OldParticleInstancingInfoP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Version, chunk.MaxInstances = string_unpack(Endian .. "II", chunk.ValueStr)

	return chunk
end

function P3D.OldParticleInstancingInfoP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 4 + 4
	return string_pack(self.Endian .. "IIIII", self.Identifier, headerLen, headerLen + #chunkData, self.Version, self.MaxInstances) .. chunkData
end