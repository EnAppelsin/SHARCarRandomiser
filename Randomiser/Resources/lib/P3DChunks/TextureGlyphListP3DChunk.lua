--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.TextureGlyphListP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Glyphs)
	assert(type(Glyphs) == "table", "Arg #1 (Glyphs) must be a table")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Glyphs = Glyphs
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.TextureGlyphListP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Texture_Glyph_List)
P3D.TextureGlyphListP3DChunk.new = new
function P3D.TextureGlyphListP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos = string_unpack(Endian .. "I", chunk.ValueStr)
	
	chunk.Glyphs = {}
	for i=1,num do
		local glyph = {}
		glyph.BottomLeft = {}
		glyph.TopRight = {}
		glyph.TextureNum, glyph.BottomLeft.X, glyph.BottomLeft.Y, glyph.TopRight.X, glyph.TopRight.Y, glyph.LeftBearing, glyph.RightBearing, glyph.Width, glyph.Advance, glyph.Code, pos = string_unpack(Endian .. "IffffffffI", chunk.ValueStr, pos)
		chunk.Glyphs[i] = glyph
	end
	
	return chunk
end

function P3D.TextureGlyphListP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local glyphsN = #self.Glyphs
	local glyphs = {}
	for i=1,glyphsN do
		local glyph = self.Glyphs[i]
		glyphs[i] = string_pack(self.Endian .. "IffffffffI", glyph.TextureNum, glyph.BottomLeft.X, glyph.BottomLeft.Y, glyph.TopRight.X, glyph.TopRight.Y, glyph.LeftBearing, glyph.RightBearing, glyph.Width, glyph.Advance, glyph.Code)
	end
	local glyphsData = table_concat(glyphs)
	
	local headerLen = 12 + 4 + glyphsN * 40
	return string_pack(self.Endian .. "IIII", self.Identifier, headerLen, headerLen + #chunkData, glyphsN) .. glyphsData .. chunkData
end