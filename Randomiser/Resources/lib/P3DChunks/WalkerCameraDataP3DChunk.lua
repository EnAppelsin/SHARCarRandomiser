--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.WalkerCameraDataP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Index, MinMagnitude, MaxMagnitude, Elevation, TargetOffset)
	assert(type(Index) == "number", "Arg #1 (Index) must be a number")
	assert(type(MinMagnitude) == "number", "Arg #2 (MinMagnitude) must be a number")
	assert(type(MaxMagnitude) == "number", "Arg #3 (MaxMagnitude) must be a number")
	assert(type(Elevation) == "number", "Arg #4 (Elevation) must be a number")
	assert(type(TargetOffset) == "table", "Arg #5 (TargetOffset) must be a table")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Index = Index,
		MinMagnitude = MinMagnitude,
		MaxMagnitude = MaxMagnitude,
		Elevation = Elevation,
		TargetOffset = TargetOffset,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.WalkerCameraDataP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Walker_Camera_Data)
P3D.WalkerCameraDataP3DChunk.new = new
function P3D.WalkerCameraDataP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	chunk.TargetOffset = {}
	chunk.Index, chunk.MinMagnitude, chunk.MaxMagnitude, chunk.Elevation, chunk.TargetOffset.X, chunk.TargetOffset.Y, chunk.TargetOffset.Z = string_unpack(Endian .. "Iffffff", chunk.ValueStr)
	
	return chunk
end

function P3D.WalkerCameraDataP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 4 + 4 + 4 + 4 + 12
	return string_pack(self.Endian .. "IIIIffffff", self.Identifier, headerLen, headerLen + #chunkData, self.Index, self.MinMagnitude, self.MaxMagnitude, self.Elevation, self.TargetOffset.X, self.TargetOffset.Y, self.TargetOffset.Z) .. chunkData
end