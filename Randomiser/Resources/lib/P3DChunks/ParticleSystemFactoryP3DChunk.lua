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

local function new(self, Version, Name, FrameRate, NumAnimFrames, NumOLFrames, CycleAnim, EnableSorting)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number.")
	assert(type(Name) == "string", "Arg #2 (Name) must be a string.")
	assert(type(FrameRate) == "number", "Arg #3 (FrameRate) must be a number.")
	assert(type(NumAnimFrames) == "number", "Arg #4 (NumAnimFrames) must be a number.")
	assert(type(NumOLFrames) == "number", "Arg #5 (NumOLFrames) must be a number.")
	assert(type(CycleAnim) == "number", "Arg #6 (CycleAnim) must be a number.")
	assert(type(EnableSorting) == "number", "Arg #7 (EnableSorting) must be a number.")

	local Data = {
		Chunks = {},
		Version = Version,
		Name = Name,
		FrameRate = FrameRate,
		NumAnimFrames = NumAnimFrames,
		NumOLFrames = NumOLFrames,
		CycleAnim = CycleAnim,
		EnableSorting = EnableSorting,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.ParticleSystemFactoryP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Particle_System_Factory)
P3D.ParticleSystemFactoryP3DChunk.new = new
function P3D.ParticleSystemFactoryP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Version, chunk.Name, chunk.FrameRate, chunk.NumAnimFrames, chunk.NumOLFrames, chunk.CycleAnim, chunk.EnableSorting = string_unpack("<Is1fIIHH", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)

	return chunk
end

function P3D.ParticleSystemFactoryP3DChunk:GetNumEmitters()
	local n = 0
	for i=1,#self.Chunks do
		if self.Chunks[i].Identifier == P3D.Identifiers.Old_Sprite_Emitter then
			n = n + 1
		end
	end
	return n
end

function P3D.ParticleSystemFactoryP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + 4 + #Name + 1 + 4 + 4 + 4 + 2 + 2 + 4
	return string_pack("<IIIIs1fIIHHI", self.Identifier, headerLen, headerLen + #chunkData, self.Version, Name, self.FrameRate, self.NumAnimFrames, self.NumOLFrames, self.CycleAnim, self.EnableSorting, self:GetNumEmitters()) .. chunkData
end