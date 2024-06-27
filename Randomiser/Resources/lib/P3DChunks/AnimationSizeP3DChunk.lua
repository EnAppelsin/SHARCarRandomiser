--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.AnimationSizeP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Version, PC, PS2, XBOX, GC)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number")
	assert(type(PC) == "number", "Arg #2 (PC) must be a number")
	assert(type(PS2) == "number", "Arg #3 (PS2) must be a number")
	assert(type(XBOX) == "number", "Arg #4 (XBOX) must be a number")
	assert(type(GC) == "number", "Arg #5 (GC) must be a number")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Version = Version,
		PC = PC,
		PS2 = PS2,
		XBOX = XBOX,
		GC = GC,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.AnimationSizeP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Animation_Size)
P3D.AnimationSizeP3DChunk.new = new
function P3D.AnimationSizeP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Version, chunk.PC, chunk.PS2, chunk.XBOX, chunk.GC = string_unpack(Endian .. "IIIII", chunk.ValueStr)
	
	return chunk
end

function P3D.AnimationSizeP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 4 + 4 + 4 + 4 + 4
	return string_pack(self.Endian .. "IIIIIIII", self.Identifier, headerLen, headerLen + #chunkData, self.Version, self.PC, self.PS2, self.XBOX, self.GC) .. chunkData
end