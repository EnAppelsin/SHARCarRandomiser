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

local function new(self, Version, Name, AnimationType, NumFrames, FrameRate, Cyclic)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number")
	assert(type(Name) == "string", "Arg #2 (Name) must be a string")
	assert(type(AnimationType) == "string", "Arg #3 (AnimationType) must be a string")
	assert(type(NumFrames) == "number", "Arg #4 (NumFrames) must be a number")
	assert(type(FrameRate) == "number", "Arg #5 (FrameRate) must be a number")
	assert(type(Cyclic) == "number", "Arg #6 (Cyclic) must be a number")
	
	local Data = {
		Chunks = {},
		Version = Version,
		Name = Name,
		AnimationType = AnimationType,
		NumFrames = NumFrames,
		FrameRate = FrameRate,
		Cyclic = Cyclic,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.AnimationP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Animation)
P3D.AnimationP3DChunk.new = new
function P3D.AnimationP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Version, chunk.Name, chunk.AnimationType, chunk.NumFrames, chunk.FrameRate, chunk.Cyclic = string_unpack("<Is1c4ffI", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	
	return chunk
end

function P3D.AnimationP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + 4 + #Name + 1 + 4 + 4 + 4 + 4
	return string_pack("<IIIIs1c4ffI", self.Identifier, headerLen, headerLen + #chunkData, self.Version, Name, self.AnimationType, self.NumFrames, self.FrameRate, self.Cyclic) .. chunkData
end