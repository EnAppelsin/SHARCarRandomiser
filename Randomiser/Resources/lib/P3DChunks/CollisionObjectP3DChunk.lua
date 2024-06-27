--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.CollisionObjectP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Name, Version, MaterialName, NumSubObject)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Version) == "number", "Arg #2 (Version) must be a number")
	assert(type(MaterialName) == "string", "Arg #3 (MaterialName) must be a string")
	assert(type(NumSubObject) == "number", "Arg #4 (NumSubObject) must be a number")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Name = Name,
		Version = Version,
		MaterialName = MaterialName,
		NumSubObject = NumSubObject
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.CollisionObjectP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Collision_Object)
P3D.CollisionObjectP3DChunk.new = new
function P3D.CollisionObjectP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Name, chunk.Version, chunk.MaterialName, chunk.NumSubObject = string_unpack(Endian .. "s1Is1I", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	chunk.MaterialName = P3D.CleanP3DString(chunk.MaterialName)
	
	return chunk
end

function P3D.CollisionObjectP3DChunk:GetNumOwners()
	local n = 0
	for i=1,#self.Chunks do
		if self.Chunks[i].Identifier == P3D.Identifiers.Collision_Volume_Owner then
			n = n + 1
		end
	end
	return n
end

function P3D.CollisionObjectP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local MaterialName = P3D.MakeP3DString(self.MaterialName)
	
	local headerLen = 12 + #Name + 1 + 4 + #MaterialName + 1 + 4 + 4
	return string_pack(self.Endian .. "IIIs1Is1II", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Version, MaterialName, self.NumSubObject, self:GetNumOwners()) .. chunkData
end