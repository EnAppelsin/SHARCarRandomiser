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

local function new(self, Name, Version)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string.")
	assert(type(Version) == "number", "Arg #2 (Version) must be a number.")

	local Data = {
		Chunks = {},
		Name = Name,
		Version = Version,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.WorldSphereP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.World_Sphere)
P3D.WorldSphereP3DChunk.new = new
function P3D.WorldSphereP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Name, chunk.Version = string_unpack("<s1I", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)

	return chunk
end

function P3D.WorldSphereP3DChunk:GetNumMeshesAndOldBillboardQuadGroups()
	local n = 0
	local n2 = 0
	for i=1,#self.Chunks do
		local identifier = self.Chunks[i].Identifier
		if identifier == P3D.Identifiers.Mesh then
			n = n + 1
		elseif identifier == P3D.Identifiers.Old_Billboard_Quad_Group then
			n2 = n2 + 1
		end
	end
	return n, n2
end

function P3D.WorldSphereP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local meshN, oldBillboardQuadGroupN = self:GetNumMeshesAndOldBillboardQuadGroups()
	
	local headerLen = 12 + #Name + 1 + 4 + 4 + 4
	return string_pack("<IIIs1III", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Version, meshN, oldBillboardQuadGroupN) .. chunkData
end