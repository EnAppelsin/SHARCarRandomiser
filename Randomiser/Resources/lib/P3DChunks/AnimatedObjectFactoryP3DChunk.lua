--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.AnimatedObjectFactoryP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Version, Name, BaseAnimation, NumAnimations)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number")
	assert(type(Name) == "string", "Arg #2 (Name) must be a string")
	assert(type(BaseAnimation) == "string", "Arg #3 (BaseAnimation) must be a string")
	assert(type(NumAnimations) == "number", "Arg #4 (NumAnimations) must be a number")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Version = Version,
		Name = Name,
		BaseAnimation = BaseAnimation,
		NumAnimations = NumAnimations,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.AnimatedObjectFactoryP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Animated_Object_Factory)
P3D.AnimatedObjectFactoryP3DChunk.new = new
function P3D.AnimatedObjectFactoryP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Version, chunk.Name, chunk.BaseAnimation, chunk.NumAnimations = string_unpack(Endian .. "Is1s1I", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	chunk.BaseAnimation = P3D.CleanP3DString(chunk.BaseAnimation)
	
	return chunk
end

function P3D.AnimatedObjectFactoryP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local BaseAnimation = P3D.MakeP3DString(self.BaseAnimation)
	
	local headerLen = 12 + 4 + #Name + 1 + #BaseAnimation + 1 + 4
	return string_pack(self.Endian .. "IIIIs1s1I", self.Identifier, headerLen, headerLen + #chunkData, self.Version, Name, BaseAnimation, self.NumAnimations) .. chunkData
end