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

local function new(self, Version, Name, Type, FrameOffset, HierarchyName, AnimationName)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number.")
	assert(type(Name) == "string", "Arg #2 (Name) must be a string.")
	assert(type(Type) == "string", "Arg #3 (Type) must be a string.")
	assert(type(FrameOffset) == "number", "Arg #4 (FrameOffset) must be a number.")
	assert(type(HierarchyName) == "string", "Arg #5 (HierarchyName) must be a string.")
	assert(type(AnimationName) == "string", "Arg #6 (AnimationName) must be a string.")

	local Data = {
		Chunks = {},
		Version = Version,
		Name = Name,
		Type = Type,
		FrameOffset = FrameOffset,
		HierarchyName = HierarchyName,
		AnimationName = AnimationName,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.OldFrameControllerP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Old_Frame_Controller)
P3D.OldFrameControllerP3DChunk.new = new
function P3D.OldFrameControllerP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Version, chunk.Name, chunk.Type, chunk.FrameOffset, chunk.HierarchyName, chunk.AnimationName = string_unpack("<Is1c4fs1s1", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	chunk.HierarchyName = P3D.CleanP3DString(chunk.HierarchyName)
	chunk.AnimationName = P3D.CleanP3DString(chunk.AnimationName)

	return chunk
end

function P3D.OldFrameControllerP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local HierarchyName = P3D.MakeP3DString(self.HierarchyName)
	local AnimationName = P3D.MakeP3DString(self.AnimationName)
	
	local headerLen = 12 + 4 + #Name + 1 + 4 + 4 + #HierarchyName + 1 + #AnimationName + 1
	return string_pack("<IIIIs1c4fs1s1", self.Identifier, headerLen, headerLen + #chunkData, self.Version, Name, self.Type, self.FrameOffset, HierarchyName, AnimationName) .. chunkData
end