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

local function new(self, Name, Transform)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string.")
	assert(type(Transform) == "table", "Arg #2 (Transform) must be a table.")

	local Data = {
		Chunks = {},
		Name = Name,
		Transform = Transform,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.OldScenegraphTransformP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Old_Scenegraph_Transform)
P3D.OldScenegraphTransformP3DChunk.new = new
function P3D.OldScenegraphTransformP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local num
	chunk.Transform = {}
	chunk.Name, num, chunk.Transform.M11, chunk.Transform.M12, chunk.Transform.M13, chunk.Transform.M14, chunk.Transform.M21, chunk.Transform.M22, chunk.Transform.M23, chunk.Transform.M24, chunk.Transform.M31, chunk.Transform.M32, chunk.Transform.M33, chunk.Transform.M34, chunk.Transform.M41, chunk.Transform.M42, chunk.Transform.M43, chunk.Transform.M44 = string_unpack("<s1Iffffffffffffffff", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)

	return chunk
end

function P3D.OldScenegraphTransformP3DChunk:__tostring()
	local chunks = {}
	local chunksN = #self.Chunks
	for i=1,chunksN do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + #Name + 1 + 4 + 64
	return string_pack("<IIIs1Iffffffffffffffff", self.Identifier, headerLen, headerLen + #chunkData, Name, chunksN, self.Transform.M11, self.Transform.M12, self.Transform.M13, self.Transform.M14, self.Transform.M21, self.Transform.M22, self.Transform.M23, self.Transform.M24, self.Transform.M31, self.Transform.M32, self.Transform.M33, self.Transform.M34, self.Transform.M41, self.Transform.M42, self.Transform.M43, self.Transform.M44) .. chunkData
end