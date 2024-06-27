--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.OldBaseEmitterP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Version, Name, ParticleType, GeneratorType, ZTest, ZWrite, Fog, MaxParticles, InfiniteLife, RotationalCohesion, TranslationalCohesion)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number.")
	assert(type(Name) == "string", "Arg #2 (Name) must be a string.")
	assert(type(ParticleType) == "string", "Arg #3 (ParticleType) must be a string.")
	assert(type(GeneratorType) == "string", "Arg #4 (GeneratorType) must be a string.")
	assert(type(ZTest) == "number", "Arg #5 (ZTest) must be a number.")
	assert(type(ZWrite) == "number", "Arg #6 (ZWrite) must be a number.")
	assert(type(Fog) == "number", "Arg #7 (Fog) must be a number.")
	assert(type(MaxParticles) == "number", "Arg #8 (MaxParticles) must be a number.")
	assert(type(InfiniteLife) == "number", "Arg #9 (InfiniteLife) must be a number.")
	assert(type(RotationalCohesion) == "number", "Arg #10 (RotationalCohesion) must be a number.")
	assert(type(TranslationalCohesion) == "number", "Arg #11 (TranslationalCohesion) must be a number.")

	local Data = {
		Endian = "<",
		Chunks = {},
		Version = Version,
		Name = Name,
		ParticleType = ParticleType,
		GeneratorType = GeneratorType,
		ZTest = ZTest,
		ZWrite = ZWrite,
		Fog = Fog,
		MaxParticles = MaxParticles,
		InfiniteLife = InfiniteLife,
		RotationalCohesion = RotationalCohesion,
		TranslationalCohesion = TranslationalCohesion,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.OldBaseEmitterP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Old_Base_Emitter)
P3D.OldBaseEmitterP3DChunk.new = new
function P3D.OldBaseEmitterP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Version, chunk.Name, chunk.ParticleType, chunk.GeneratorType, chunk.ZTest, chunk.ZWrite, chunk.Fog, chunk.MaxParticles, chunk.InfiniteLife, chunk.RotationalCohesion, chunk.TranslationalCohesion = string_unpack(Endian .. "Is1c4c4IIIIIff", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	if Endian == ">" then
		chunk.ParticleType = string_reverse(chunk.ParticleType)
		chunk.GeneratorType = string_reverse(chunk.GeneratorType)
	end

	return chunk
end

function P3D.OldBaseEmitterP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local ParticleType = self.ParticleType
	local GeneratorType = self.GeneratorType
	if self.Endian == ">" then
		ParticleType = string_reverse(ParticleType)
		GeneratorType = string_reverse(GeneratorType)
	end
	
	local headerLen = 12 + 4 + #Name + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4
	return string_pack(self.Endian .. "IIIIs1c4c4IIIIIff", self.Identifier, headerLen, headerLen + #chunkData, self.Version, Name, ParticleType, GeneratorType, self.ZTest, self.ZWrite, self.Fog, self.MaxParticles, self.InfiniteLife, self.RotationalCohesion, self.TranslationalCohesion) .. chunkData
end