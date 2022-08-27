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

local function new(self, Name, Type, StartIntersection, EndIntersection, MaximumCars, Speed, Intelligence, Shortcut)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string.")
	assert(type(Type) == "number", "Arg #2 (Type) must be a number.")
	assert(type(StartIntersection) == "string", "Arg #3 (StartIntersection) must be a string.")
	assert(type(EndIntersection) == "string", "Arg #4 (EndIntersection) must be a string.")
	assert(type(MaximumCars) == "number", "Arg #5 (MaximumCars) must be a number.")
	assert(type(Speed) == "number", "Arg #6 (Speed) must be a number.")
	assert(type(Intelligence) == "number", "Arg #7 (Intelligence) must be a number.")
	assert(type(Shortcut) == "number", "Arg #8 (Shortcut) must be a number.")

	local Data = {
		Chunks = {},
		Name = Name,
		Type = Type,
		StartIntersection = StartIntersection,
		EndIntersection = EndIntersection,
		MaximumCars = MaximumCars,
		Speed = Speed,
		Intelligence = Intelligence,
		Shortcut = Shortcut,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.RoadP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Road)
P3D.RoadP3DChunk.new = new
function P3D.RoadP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Name, chunk.Type, chunk.StartIntersection, chunk.EndIntersection, chunk.MaximumCars, chunk.Speed, chunk.Intelligence, chunk.Shortcut = string_unpack("<s1Is1s1IBBB", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	chunk.StartIntersection = P3D.CleanP3DString(chunk.StartIntersection)
	chunk.EndIntersection = P3D.CleanP3DString(chunk.EndIntersection)

	return chunk
end

function P3D.RoadP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local StartIntersection = P3D.MakeP3DString(self.StartIntersection)
	local EndIntersection = P3D.MakeP3DString(self.EndIntersection)
	
	local headerLen = 12 + #Name + 1 + 4 + #StartIntersection + 1 + #EndIntersection + 1 + 4 + 1 + 1 + 1 + 1
	return string_pack("<IIIs1Is1s1IBBBx", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Type, StartIntersection, EndIntersection, self.MaximumCars, self.Speed, self.Intelligence, self.Shortcut) .. chunkData
end