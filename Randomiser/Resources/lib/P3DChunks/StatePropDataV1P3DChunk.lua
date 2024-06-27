--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.StatePropDataV1P3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Version, Name, ObjectFactoryName)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number.")
	assert(type(Name) == "string", "Arg #2 (Name) must be a string.")
	assert(type(ObjectFactoryName) == "string", "Arg #3 (ObjectFactoryName) must be a string.")

	local Data = {
		Endian = "<",
		Chunks = {},
		Version = Version,
		Name = Name,
		ObjectFactoryName = ObjectFactoryName,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.StatePropDataV1P3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.State_Prop_Data_V1)
P3D.StatePropDataV1P3DChunk.new = new
function P3D.StatePropDataV1P3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Version, chunk.Name, chunk.ObjectFactoryName = string_unpack(Endian .. "Is1s1", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	chunk.ObjectFactoryName = P3D.CleanP3DString(chunk.ObjectFactoryName)

	return chunk
end

function P3D.StatePropDataV1P3DChunk:GetNumStates()
	local n = 0
	for i=1,#self.Chunks do
		if self.Chunks[i].Identifier == P3D.Identifiers.State_Prop_State_Data_V1 then
			n = n + 1
		end
	end
	return n
end

function P3D.StatePropDataV1P3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local ObjectFactoryName = P3D.MakeP3DString(self.ObjectFactoryName)
	
	local headerLen = 12 + 4 + #Name + 1 + #ObjectFactoryName + 1 + 4
	return string_pack(self.Endian .. "IIIIs1s1I", self.Identifier, headerLen, headerLen + #chunkData, self.Version, Name, ObjectFactoryName, self:GetNumStates()) .. chunkData
end