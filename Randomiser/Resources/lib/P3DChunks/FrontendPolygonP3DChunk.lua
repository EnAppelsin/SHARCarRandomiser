--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.FrontendPolygonP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Name, Version, Translucency, Points, Colours)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Version) == "number", "Arg #2 (Version) must be a number")
	assert(type(Translucency) == "number", "Arg #3 (Translucency) must be a number")
	assert(type(Points) == "table", "Arg #4 (Points) must be a table")
	assert(type(Colours) == "table", "Arg #5 (Colours) must be a table")
	assert(#Points == #Colours, "Arg #3 (Points) and Arg #4 (Colours) must have the same length")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Name = Name,
		Version = Version,
		Translucency = Translucency,
		Points = Points,
		Colours = Colours
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.FrontendPolygonP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Frontend_Polygon)
P3D.FrontendPolygonP3DChunk.new = new
function P3D.FrontendPolygonP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos
	chunk.Name, chunk.Version, chunk.Translucency, num, pos = string_unpack(Endian .. "s1III", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	
	chunk.Points = {}
	for i=1,num do
		local point = {}
		point.X, point.Y, point.Z, pos = string_unpack(Endian .. "fff", chunk.ValueStr, pos)
		chunk.Points[i] = point
	end
	
	chunk.Colours = {}
	for i=1,num do
		local colour = {}
		if Endian == ">" then
			colour.A, colour.R, colour.G, colour.B, pos = string_unpack(Endian .. "BBBB", chunk.ValueStr, pos)
		else
			colour.B, colour.G, colour.R, colour.A, pos = string_unpack(Endian .. "BBBB", chunk.ValueStr, pos)
		end
		chunk.Colours[i] = colour
	end
	
	return chunk
end

function P3D.FrontendPolygonP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local num = #self.Points
	local points = {}
	for i=1,num do
		local point = self.Points[i]
		points[i] = string_pack(self.Endian .. "fff", point.X, point.Y, point.Z)
	end
	local pointsData = table_concat(points)
	
	local colours = {}
	for i=1,num do
		local colour = self.Colours[i]
		if self.Endian == ">" then
			colours[i] = string_pack(self.Endian .. "BBBB", colour.A, colour.R, colour.G, colour.B)
		else
			colours[i] = string_pack(self.Endian .. "BBBB", colour.B, colour.G, colour.R, colour.A)
		end
	end
	local coloursData = table_concat(colours)
	
	local headerLen = 12 + #Name + 1 + 4 + 4 + 4 + num * 12 + num * 4
	return string_pack(self.Endian .. "IIIs1III", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Version, self.Translucency, num) .. pointsData .. coloursData .. chunkData
end