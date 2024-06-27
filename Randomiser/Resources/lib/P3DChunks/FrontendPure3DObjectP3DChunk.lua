--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.FrontendPure3DObjectP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Name, Version, Position, Dimension, Justification, Colour, Translucency, RotationValue, Pure3DFilename)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Version) == "number", "Arg #2 (Version) must be a number")
	assert(type(Position) == "table", "Arg #3 (Position) must be a table")
	assert(type(Dimension) == "table", "Arg #4 (Dimension) must be a table")
	assert(type(Justification) == "table", "Arg #5 (Justification) must be a table")
	assert(type(Colour) == "table", "Arg #6 (Colour) must be a table")
	assert(type(Translucency) == "number", "Arg #7 (Translucency) must be a number")
	assert(type(RotationValue) == "number", "Arg #8 (RotationValue) must be a number")
	assert(type(Pure3DFilename) == "string", "Arg #9 (Pure3DFilename) must be a string")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Name = Name,
		Version = Version,
		Position = Position,
		Dimension = Dimension,
		Justification = Justification,
		Colour = Colour,
		Translucency = Translucency,
		RotationValue = RotationValue,
		Pure3DFilename = Pure3DFilename
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.FrontendPure3DObjectP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Frontend_Pure3D_Object)
P3D.FrontendPure3DObjectP3DChunk.new = new
P3D.FrontendPure3DObjectP3DChunk.Justifications = {
	Left = 0,
	Right = 1,
	Top = 2,
	Bottom = 3,
	Centre = 4
}
function P3D.FrontendPure3DObjectP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	local pos
	chunk.Position = {}
	chunk.Dimension = {}
	chunk.Justification = {}
	chunk.Colour = {}
	chunk.Name, chunk.Version, chunk.Position.X, chunk.Position.Y, chunk.Dimension.X, chunk.Dimension.Y, chunk.Justification.X, chunk.Justification.Y, chunk.Colour.B, chunk.Colour.G, chunk.Colour.R, chunk.Colour.A, chunk.Translucency, chunk.RotationValue, chunk.Pure3DFilename, pos = string_unpack(Endian .. "s1IiiIIIIBBBBIfs1", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	chunk.Pure3DFilename = P3D.CleanP3DString(chunk.Pure3DFilename)
	if Endian == ">" then
		chunk.Colour.B, chunk.Colour.G, chunk.Colour.R, chunk.Colour.A = chunk.Colour.A, chunk.Colour.R, chunk.Colour.G, chunk.Colour.B
	end
	
	return chunk
end

function P3D.FrontendPure3DObjectP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local Pure3DFilename = P3D.MakeP3DString(self.Pure3DFilename)
	
	local Colour = {}
	if self.Endian == ">" then
		Colour.B, Colour.G, Colour.R, Colour.A = self.Colour.A, self.Colour.R, self.Colour.G, self.Colour.B
	else
		Colour.B, Colour.G, Colour.R, Colour.A = self.Colour.B, self.Colour.G, self.Colour.R, self.Colour.A
	end
	
	local headerLen = 12 + #Name + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + #Pure3DFilename + 1
	return string_pack(self.Endian .. "IIIs1IiiIIIIBBBBIfs1", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Version, self.Position.X, self.Position.Y, self.Dimension.X, self.Dimension.Y, self.Justification.X, self.Justification.Y, Colour.B, Colour.G, Colour.R, Colour.A, self.Translucency, self.RotationValue, Pure3DFilename) .. chunkData
end