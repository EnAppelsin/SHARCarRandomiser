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

local function new(self, Direction)
	assert(type(Direction) == "table", "Arg #1 (Direction) must be a table")
	
	local Data = {
		Chunks = {},
		Direction = Direction
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.LightDirectionP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Light_Direction)
P3D.LightDirectionP3DChunk.new = new
function P3D.LightDirectionP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Direction = {}
	chunk.Direction.X, chunk.Direction.Y, chunk.Direction.Z = string_unpack("<fff", chunk.ValueStr)
	
	return chunk
end

function P3D.LightDirectionP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 12
	return string_pack("<IIIfff", self.Identifier, headerLen, headerLen + #chunkData, self.Direction.X, self.Direction.Y, self.Direction.Z) .. chunkData
end