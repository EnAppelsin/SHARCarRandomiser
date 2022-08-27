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

local function new(self, Centre, Radius)
	assert(type(Centre) == "table", "Arg #1 (Centre) must be a table")
	assert(type(Radius) == "number", "Arg #2 (Radius) must be a number")
	
	local Data = {
		Chunks = {},
		Centre = Centre,
		Radius = Radius
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.BoundingSphereP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Bounding_Sphere)
P3D.BoundingSphereP3DChunk.new = new
function P3D.BoundingSphereP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Centre = {}
	chunk.Centre.X, chunk.Centre.Y, chunk.Centre.Z, chunk.Radius = string_unpack("<ffff", chunk.ValueStr)
	
	return chunk
end

function P3D.BoundingSphereP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 12 + 4
	return string_pack("<IIIffff", self.Identifier, headerLen, headerLen + #chunkData, self.Centre.X, self.Centre.Y, self.Centre.Z, self.Radius) .. chunkData
end