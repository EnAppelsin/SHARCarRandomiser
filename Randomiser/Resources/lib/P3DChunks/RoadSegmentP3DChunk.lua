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

local function new(self, Name, RoadDataSegment, Transform, Scale)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string.")
	assert(type(RoadDataSegment) == "string", "Arg #2 (RoadDataSegment) must be a string.")
	assert(type(Transform) == "table", "Arg #3 (Transform) must be a table.")
	assert(type(Scale) == "table", "Arg #4 (Scale) must be a table.")

	local Data = {
		Chunks = {},
		Name = Name,
		RoadDataSegment = RoadDataSegment,
		Transform = Transform,
		Scale = Scale,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.RoadSegmentP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Road_Segment)
P3D.RoadSegmentP3DChunk.new = new
function P3D.RoadSegmentP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Transform = {}
	chunk.Scale = {}
	chunk.Name, chunk.RoadDataSegment, chunk.Transform.M11, chunk.Transform.M12, chunk.Transform.M13, chunk.Transform.M14, chunk.Transform.M21, chunk.Transform.M22, chunk.Transform.M23, chunk.Transform.M24, chunk.Transform.M31, chunk.Transform.M32, chunk.Transform.M33, chunk.Transform.M34, chunk.Transform.M41, chunk.Transform.M42, chunk.Transform.M43, chunk.Transform.M44, chunk.Scale.M11, chunk.Scale.M12, chunk.Scale.M13, chunk.Scale.M14, chunk.Scale.M21, chunk.Scale.M22, chunk.Scale.M23, chunk.Scale.M24, chunk.Scale.M31, chunk.Scale.M32, chunk.Scale.M33, chunk.Scale.M34, chunk.Scale.M41, chunk.Scale.M42, chunk.Scale.M43, chunk.Scale.M44 = string_unpack("<s1s1ffffffffffffffffffffffffffffffff", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	chunk.RoadDataSegment = P3D.CleanP3DString(chunk.RoadDataSegment)

	return chunk
end

function P3D.RoadSegmentP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local RoadDataSegment = P3D.MakeP3DString(self.RoadDataSegment)
	
	local headerLen = 12 + #Name + 1 + #RoadDataSegment + 1 + 64 + 64
	return string_pack("<IIIs1s1ffffffffffffffffffffffffffffffff", self.Identifier, headerLen, headerLen + #chunkData, Name, RoadDataSegment, self.Transform.M11, self.Transform.M12, self.Transform.M13, self.Transform.M14, self.Transform.M21, self.Transform.M22, self.Transform.M23, self.Transform.M24, self.Transform.M31, self.Transform.M32, self.Transform.M33, self.Transform.M34, self.Transform.M41, self.Transform.M42, self.Transform.M43, self.Transform.M44, self.Scale.M11, self.Scale.M12, self.Scale.M13, self.Scale.M14, self.Scale.M21, self.Scale.M22, self.Scale.M23, self.Scale.M24, self.Scale.M31, self.Scale.M32, self.Scale.M33, self.Scale.M34, self.Scale.M41, self.Scale.M42, self.Scale.M43, self.Scale.M44) .. chunkData
end