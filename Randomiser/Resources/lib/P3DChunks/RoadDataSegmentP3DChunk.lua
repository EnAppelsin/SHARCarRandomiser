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

local function new(self, Name, Type, Lanes, HasShoulder, Position, Position2, Position3)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Type) == "number", "Arg #2 (Type) must be a number")
	assert(type(Lanes) == "number", "Arg #3 (Lanes) must be a number")
	assert(type(HasShoulder) == "number", "Arg #4 (HasShoulder) must be a number")
	assert(type(Position) == "table", "Arg #5 (Position) must be a table")
	assert(type(Position2) == "table", "Arg #6 (Position2) must be a table")
	assert(type(Position3) == "table", "Arg #7 (Position3) must be a table")
	
	local Data = {
		Chunks = {},
		Name = Name,
		Type = Type,
		Lanes = Lanes,
		HasShoulder = HasShoulder,
		Position = Position,
		Position2 = Position2,
		Position3 = Position3
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.RoadDataSegmentP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Road_Data_Segment)
P3D.RoadDataSegmentP3DChunk.new = new
function P3D.RoadDataSegmentP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Position = {}
	chunk.Position2 = {}
	chunk.Position3 = {}
	chunk.Name, chunk.Type, chunk.Lanes, chunk.HasShoulder, chunk.Position.X, chunk.Position.Y, chunk.Position.Z, chunk.Position2.X, chunk.Position2.Y, chunk.Position2.Z, chunk.Position3.X, chunk.Position3.Y, chunk.Position3.Z = string_unpack("<s1IIIfffffffff", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	
	return chunk
end

function P3D.RoadDataSegmentP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + #Name + 1 + 4 + 4 + 4 + 12 + 12 + 12
	return string_pack("<IIIs1IIIfffffffff", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Type, self.Lanes, self.HasShoulder, self.Position.X, self.Position.Y, self.Position.Z, self.Position2.X, self.Position2.Y, self.Position2.Z, self.Position3.X, self.Position3.Y, self.Position3.Z) .. chunkData
end