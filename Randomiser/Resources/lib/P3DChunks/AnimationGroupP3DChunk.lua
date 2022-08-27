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

local function new(self, Version, Name, GroupId)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number")
	assert(type(Name) == "string", "Arg #2 (Name) must be a string")
	assert(type(GroupId) == "number", "Arg #3 (GroupId) must be a number")
	
	local Data = {
		Chunks = {},
		Version = Version,
		Name = Name,
		GroupId = GroupId,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.AnimationGroupP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Animation_Group)
P3D.AnimationGroupP3DChunk.new = new
function P3D.AnimationGroupP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Version, chunk.Name, chunk.GroupId = string_unpack("<Is1I", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	
	return chunk
end

function P3D.AnimationGroupP3DChunk:__tostring()
	local chunks = {}
	local chunkN = #self.Chunks
	for i=1,chunkN do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + 4 + #Name + 1 + 4 + 4
	return string_pack("<IIIIs1II", self.Identifier, headerLen, headerLen + #chunkData, self.Version, Name, self.GroupId, chunkN) .. chunkData
end