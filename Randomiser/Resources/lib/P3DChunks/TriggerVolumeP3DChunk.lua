--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.TriggerVolumeP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Name, IsRect, HalfExtents, Matrix)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(IsRect) == "number", "Arg #2 (IsRect) must be a number")
	assert(type(HalfExtents) == "table", "Arg #3 (HalfExtents) must be a table")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Name = Name,
		IsRect = IsRect,
		HalfExtents = HalfExtents,
		Matrix = Matrix,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.TriggerVolumeP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Trigger_Volume)
P3D.TriggerVolumeP3DChunk.new = new
function P3D.TriggerVolumeP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	chunk.HalfExtents = {}
	chunk.Matrix = {}
	chunk.Name, chunk.IsRect, chunk.HalfExtents.X, chunk.HalfExtents.Y, chunk.HalfExtents.Z, chunk.Matrix.M11, chunk.Matrix.M12, chunk.Matrix.M13, chunk.Matrix.M14, chunk.Matrix.M21, chunk.Matrix.M22, chunk.Matrix.M23, chunk.Matrix.M24, chunk.Matrix.M31, chunk.Matrix.M32, chunk.Matrix.M33, chunk.Matrix.M34, chunk.Matrix.M41, chunk.Matrix.M42, chunk.Matrix.M43, chunk.Matrix.M44 = string_unpack(Endian .. "s1Ifffffffffffffffffff", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	
	return chunk
end

function P3D.TriggerVolumeP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + #Name + 1 + 4 + 12 + 64
	return string_pack(self.Endian .. "IIIs1Ifffffffffffffffffff", self.Identifier, headerLen, headerLen + #chunkData, Name, self.IsRect, self.HalfExtents.X, self.HalfExtents.Y, self.HalfExtents.Z, self.Matrix.M11, self.Matrix.M12, self.Matrix.M13, self.Matrix.M14, self.Matrix.M21, self.Matrix.M22, self.Matrix.M23, self.Matrix.M24, self.Matrix.M31, self.Matrix.M32, self.Matrix.M33, self.Matrix.M34, self.Matrix.M41, self.Matrix.M42, self.Matrix.M43, self.Matrix.M44) .. chunkData
end