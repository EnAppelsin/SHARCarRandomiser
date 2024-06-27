--[[
CREDITS:
	Proddy#7272				- Converting to Lua, P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.TextureAnimationP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Name, Version, MaterialName, NumFrames, FrameRate, Cyclic)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Version) == "number", "Arg #2 (Version) must be a number")
	assert(type(MaterialName) == "string", "Arg #3 (MaterialName) must be a string")
	assert(type(NumFrames) == "number", "Arg #4 (NumFrames) must be a number")
	assert(type(FrameRate) == "number", "Arg #5 (FrameRate) must be a number")
	assert(type(Cyclic) == "number", "Arg #6 (Cyclic) must be a number")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Name = Name,
		Version = Version,
		MaterialName = MaterialName,
		NumFrames = NumFrames,
		FrameRate = FrameRate,
		Cyclic = Cyclic
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.TextureAnimationP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Texture_Animation)
P3D.TextureAnimationP3DChunk.new = new
function P3D.TextureAnimationP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Name, chunk.Version, chunk.MaterialName, chunk.NumFrames, chunk.FrameRate, chunk.Cyclic = string_unpack(Endian .. "s1Is1IfI", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	chunk.MaterialName = P3D.CleanP3DString(chunk.MaterialName)
	
	return chunk
end

function P3D.TextureAnimationP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local MaterialName = P3D.MakeP3DString(self.MaterialName)
	
	local headerLen = 12 + #Name + 1 + 4 + #MaterialName + 1 + 4 + 4 + 4
	return string_pack(self.Endian .. "IIIs1Is1IfI", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Version, MaterialName, self.NumFrames, self.FrameRate, self.Cyclic) .. chunkData
end