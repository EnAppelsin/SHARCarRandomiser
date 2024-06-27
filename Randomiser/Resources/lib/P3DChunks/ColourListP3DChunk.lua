--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.ColourListP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Colours)
	assert(type(Colours) == "table", "Arg #1 (Colours) must be a table")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Colours = Colours,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.ColourListP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Colour_List)
P3D.ColourListP3DChunk.new = new
function P3D.ColourListP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos = string_unpack(Endian .. "I", chunk.ValueStr)
	
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

function P3D.ColourListP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local coloursN = #self.Colours
	local colours = {}
	for i=1,coloursN do
		local colour = self.Colours[i]
		if self.Endian == ">" then
			colours[i] = string_pack(self.Endian .. "BBBB", colour.A, colour.R, colour.G, colour.B)
		else
			colours[i] = string_pack(self.Endian .. "BBBB", colour.B, colour.G, colour.R, colour.A)
		end
	end
	local coloursData = table_concat(colours)
	
	local headerLen = 12 + 4 + coloursN * 4
	return string_pack(self.Endian .. "IIII", self.Identifier, headerLen, headerLen + #chunkData, coloursN) .. coloursData .. chunkData
end