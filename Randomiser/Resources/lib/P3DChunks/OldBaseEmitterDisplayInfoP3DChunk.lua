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

local function new(self, Version, Rotation, CutOffMode, UVOffsetRange, SourceRange, EdgeRange)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number.")
	assert(type(Rotation) == "table", "Arg #2 (Rotation) must be a table.")
	assert(type(CutOffMode) == "string", "Arg #3 (CutOffMode) must be a string.")
	assert(type(UVOffsetRange) == "table", "Arg #4 (UVOffsetRange) must be a table.")
	assert(type(SourceRange) == "number", "Arg #5 (SourceRange) must be a number.")
	assert(type(EdgeRange) == "number", "Arg #6 (EdgeRange) must be a number.")

	local Data = {
		Chunks = {},
		Version = Version,
		Rotation = Rotation,
		CutOffMode = CutOffMode,
		UVOffsetRange = UVOffsetRange,
		SourceRange = SourceRange,
		EdgeRange = EdgeRange,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.OldBillboardDisplayInfoP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Old_Billboard_Display_Info)
P3D.OldBillboardDisplayInfoP3DChunk.new = new
function P3D.OldBillboardDisplayInfoP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Rotation = {}
	chunk.UVOffsetRange = {}
	chunk.Version, chunk.Rotation.W, chunk.Rotation.X, chunk.Rotation.Y, chunk.Rotation.Z, chunk.CutOffMode, chunk.UVOffsetRange.X, chunk.UVOffsetRange.Y, chunk.SourceRange, chunk.EdgeRange = string_unpack("<Iffffc4ffff", chunk.ValueStr)

	return chunk
end

function P3D.OldBillboardDisplayInfoP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 4 + 16 + 4 + 8 + 4 + 4
	return string_pack("<IIIIffffc4ffff", self.Identifier, headerLen, headerLen + #chunkData, self.Version, self.Rotation.W, self.Rotation.X, self.Rotation.Y, self.Rotation.Z, self.CutOffMode, self.UVOffsetRange.X, self.UVOffsetRange.Y, self.SourceRange, self.EdgeRange) .. chunkData
end