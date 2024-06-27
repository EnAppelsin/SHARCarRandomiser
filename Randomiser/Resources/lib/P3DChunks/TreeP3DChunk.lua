--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.TreeP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Minimum, Maximum)
	assert(type(Minimum) == "table", "Arg #1 (Minimum) must be a table.")
	assert(type(Maximum) == "table", "Arg #2 (Maximum) must be a table.")

	local Data = {
		Endian = "<",
		Chunks = {},
		Minimum = Minimum,
		Maximum = Maximum,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.TreeP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Tree)
P3D.TreeP3DChunk.new = new
function P3D.TreeP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	local num
	chunk.Minimum = {}
	chunk.Maximum = {}
	num, chunk.Minimum.X, chunk.Minimum.Y, chunk.Minimum.Z, chunk.Maximum.X, chunk.Maximum.Y, chunk.Maximum.Z = string_unpack(Endian .. "Iffffff", chunk.ValueStr)

	return chunk
end

function P3D.TreeP3DChunk:__tostring()
	local chunks = {}
	local chunksN = #self.Chunks
	for i=1,chunksN do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 4 + 12 + 12
	return string_pack(self.Endian .. "IIIIffffff", self.Identifier, headerLen, headerLen + #chunkData, chunksN, self.Minimum.X, self.Minimum.Y, self.Minimum.Z, self.Maximum.X, self.Maximum.Y, self.Maximum.Z) .. chunkData
end