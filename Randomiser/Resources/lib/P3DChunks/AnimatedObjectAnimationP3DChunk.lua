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

local function new(self, Version, Name, FrameRate, NumOldFrameControllers)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number")
	assert(type(Name) == "string", "Arg #2 (Name) must be a string")
	assert(type(FrameRate) == "number", "Arg #3 (FrameRate) must be a number")
	assert(type(NumOldFrameControllers) == "number", "Arg #4 (NumOldFrameControllers) must be a number")
	
	local Data = {
		Chunks = {},
		Version = Version,
		Name = Name,
		FrameRate = FrameRate,
		NumOldFrameControllers = NumOldFrameControllers,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.AnimatedObjectAnimationP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Animated_Object_Animation)
P3D.AnimatedObjectAnimationP3DChunk.new = new
function P3D.AnimatedObjectAnimationP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Version, chunk.Name, chunk.FrameRate, chunk.NumOldFrameControllers = string_unpack("<Is1fI", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	
	return chunk
end

function P3D.AnimatedObjectAnimationP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + 4 + #Name + 1 + 4 + 4
	return string_pack("<IIIIs1fI", self.Identifier, headerLen, headerLen + #chunkData, self.Version, Name, self.FrameRate, self.NumOldFrameControllers) .. chunkData
end