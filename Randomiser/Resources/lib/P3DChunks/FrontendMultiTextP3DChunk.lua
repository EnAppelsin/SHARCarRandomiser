--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.FrontendMultiTextP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Name, Version, Position, Dimension, Justification, Colour, Translucency, RotationValue, TextStyleName, ShadowEnabled, ShadowColour, ShadowOffset, CurrentText)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Version) == "number", "Arg #2 (Version) must be a number")
	assert(type(Position) == "table", "Arg #3 (Position) must be a table")
	assert(type(Dimension) == "table", "Arg #4 (Dimension) must be a table")
	assert(type(Justification) == "table", "Arg #5 (Justification) must be a table")
	assert(type(Colour) == "table", "Arg #6 (Colour) must be a table")
	assert(type(Translucency) == "number", "Arg #7 (Translucency) must be a number")
	assert(type(RotationValue) == "number", "Arg #8 (RotationValue) must be a number")
	assert(type(TextStyleName) == "string", "Arg #9 (TextStyleName) must be a string")
	assert(type(ShadowEnabled) == "number", "Arg #10 (ShadowEnabled) must be a number")
	assert(type(ShadowColour) == "table", "Arg #11 (ShadowColour) must be a table")
	assert(type(ShadowOffset) == "table", "Arg #12 (ShadowOffset) must be a table")
	assert(type(CurrentText) == "number", "Arg #13 (CurrentText) must be a number")
	
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
		TextStyleName = TextStyleName,
		ShadowEnabled = ShadowEnabled,
		ShadowColour = ShadowColour,
		ShadowOffset = ShadowOffset,
		CurrentText = CurrentText
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.FrontendMultiTextP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Frontend_Multi_Text)
P3D.FrontendMultiTextP3DChunk.new = new
P3D.FrontendMultiTextP3DChunk.Justifications = {
	Left = 0,
	Right = 1,
	Top = 2,
	Bottom = 3,
	Centre = 4
}
function P3D.FrontendMultiTextP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Position = {}
	chunk.Dimension = {}
	chunk.Justification = {}
	chunk.Colour = {}
	chunk.ShadowColour = {}
	chunk.ShadowOffset = {}
	chunk.Name, chunk.Version, chunk.Position.X, chunk.Position.Y, chunk.Dimension.X, chunk.Dimension.Y, chunk.Justification.X, chunk.Justification.Y, chunk.Colour.B, chunk.Colour.G, chunk.Colour.R, chunk.Colour.A, chunk.Translucency, chunk.RotationValue, chunk.TextStyleName, chunk.ShadowEnabled, chunk.ShadowColour.B, chunk.ShadowColour.G, chunk.ShadowColour.R, chunk.ShadowColour.A, chunk.ShadowOffset.X, chunk.ShadowOffset.Y, chunk.CurrentText = string_unpack(Endian .. "s1IiiIIIIBBBBIfs1BBBBBiiI", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	chunk.TextStyleName = P3D.CleanP3DString(chunk.TextStyleName)
	if Endian == ">" then
		chunk.Colour.B, chunk.Colour.G, chunk.Colour.R, chunk.Colour.A = chunk.Colour.A, chunk.Colour.R, chunk.Colour.G, chunk.Colour.B
		chunk.ShadowColour.B, chunk.ShadowColour.G, chunk.ShadowColour.R, chunk.ShadowColour.A = chunk.ShadowColour.A, chunk.ShadowColour.R, chunk.ShadowColour.G, chunk.ShadowColour.B
	end
	
	return chunk
end

function P3D.FrontendMultiTextP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local TextStyleName = P3D.MakeP3DString(self.TextStyleName)
	
	local Colour = {}
	local ShadowColour = {}
	if self.Endian == ">" then
		Colour.B, Colour.G, Colour.R, Colour.A = self.Colour.A, self.Colour.R, self.Colour.G, self.Colour.B
		ShadowColour.B, ShadowColour.G, ShadowColour.R, ShadowColour.A = self.ShadowColour.A, self.ShadowColour.R, self.ShadowColour.G, self.ShadowColour.B
	else
		Colour.B, Colour.G, Colour.R, Colour.A = self.Colour.B, self.Colour.G, self.Colour.R, self.Colour.A
		ShadowColour.B, ShadowColour.G, ShadowColour.R, ShadowColour.A = self.ShadowColour.B, self.ShadowColour.G, self.ShadowColour.R, self.ShadowColour.A
	end
	
	local headerLen = 12 + #Name + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + #TextStyleName + 1 + 1 + 4 + 4 + 4 + 4
	return string_pack(self.Endian .. "IIIs1IiiIIIIBBBBIfs1BBBBBiiI", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Version, self.Position.X, self.Position.Y, self.Dimension.X, self.Dimension.Y, self.Justification.X, self.Justification.Y, Colour.B, Colour.G, Colour.R, Colour.A, self.Translucency, self.RotationValue, TextStyleName, self.ShadowEnabled, ShadowColour.B, ShadowColour.G, ShadowColour.R, ShadowColour.A, self.ShadowOffset.X, self.ShadowOffset.Y, self.CurrentText) .. chunkData
end