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

local function new(self, Version, Perspective)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number.")
	assert(type(Perspective) == "number", "Arg #2 (Perspective) must be a number.")

	local Data = {
		Chunks = {},
		Version = Version,
		Perspective = Perspective,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.OldBillboardPerspectiveInfoP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Old_Billboard_Perspective_Info)
P3D.OldBillboardPerspectiveInfoP3DChunk.new = new
function P3D.OldBillboardPerspectiveInfoP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Version, chunk.Perspective = string_unpack("<II", chunk.ValueStr)

	return chunk
end

function P3D.OldBillboardPerspectiveInfoP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 4 + 4
	return string_pack("<IIIII", self.Identifier, headerLen, headerLen + #chunkData, self.Version, self.Perspective) .. chunkData
end