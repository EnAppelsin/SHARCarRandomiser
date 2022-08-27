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

local function new(self, Name, Version, SkeletonName)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string.")
	assert(type(Version) == "number", "Arg #2 (Version) must be a number.")
	assert(type(SkeletonName) == "string", "Arg #3 (SkeletonName) must be a string.")

	local Data = {
		Chunks = {},
		Name = Name,
		Version = Version,
		SkeletonName = SkeletonName
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.SkinP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Skin)
P3D.SkinP3DChunk.new = new
function P3D.SkinP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Name, chunk.Version, chunk.SkeletonName = string_unpack("<s1Is1", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	chunk.SkeletonName = P3D.CleanP3DString(chunk.SkeletonName)

	return chunk
end

function P3D.SkinP3DChunk:GetNumPrimGroups()
	local n = 0
	for i=1,#self.Chunks do
		if self.Chunks[i].Identifier == P3D.Identifiers.Old_Primitive_Group then
			n = n + 1
		end
	end
	return n
end

function P3D.SkinP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local SkeletonName = P3D.MakeP3DString(self.SkeletonName)
	
	local headerLen = 12 + #Name + 1 + 4 + #SkeletonName + 1 + 4
	return string_pack("<IIIs1Is1I", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Version, SkeletonName, self:GetNumPrimGroups()) .. chunkData
end