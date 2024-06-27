--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.AnimP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Name, Version, HasAlpha)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Version) == "number", "Arg #2 (Version) must be a number")
	assert(type(HasAlpha) == "number", "Arg #3 (HasAlpha) must be a number")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Name = Name,
		Version = Version,
		HasAlpha = HasAlpha,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.AnimP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Anim)
P3D.AnimP3DChunk.new = new
function P3D.AnimP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Name, chunk.Version, chunk.HasAlpha = string_unpack(Endian .. "s1II", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	
	return chunk
end

function P3D.AnimP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + #Name + 1 + 4 + 4
	return string_pack(self.Endian .. "IIIs1II", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Version, self.HasAlpha) .. chunkData
end