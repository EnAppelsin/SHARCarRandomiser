--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.MultiControllerTrackP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Version, Name, Type)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number.")
	assert(type(Name) == "string", "Arg #2 (Name) must be a string.")
	assert(type(Type) == "string", "Arg #3 (Type) must be a string.")

	local Data = {
		Endian = "<",
		Chunks = {},
		Version = Version,
		Name = Name,
		Type = Type,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.MultiControllerTrackP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Multi_Controller_Track)
P3D.MultiControllerTrackP3DChunk.new = new
function P3D.MultiControllerTrackP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Version, chunk.Name, chunk.Type = string_unpack(Endian .. "Is1c4", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	if Endian == ">" then
		chunk.Type = string_reverse(chunk.Type)
	end

	return chunk
end

function P3D.MultiControllerTrackP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local Type = self.Type
	if self.Endian == ">" then
		Type = string_reverse(Type)
	end
	
	local headerLen = 12 + 4 + #Name + 1 + 4
	return string_pack(self.Endian .. "IIIIs1c4", self.Identifier, headerLen, headerLen + #chunkData, self.Version, Name, Type) .. chunkData
end