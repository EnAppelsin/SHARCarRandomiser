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

local function new(self, Version, Types)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number")
	assert(type(Types) == "table", "Arg #2 (Types) must be a table")
	
	local Data = {
		Chunks = {},
		Version = Version,
		Types = Types
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.SurfaceTypeListP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Surface_Type_List)
P3D.SurfaceTypeListP3DChunk.new = new
function P3D.SurfaceTypeListP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos
	chunk.Version, num, pos = string_unpack("<II", chunk.ValueStr)
	
	chunk.Types = table_pack(string_unpack("<" .. string_rep("B", num), chunk.ValueStr, pos))
	chunk.Types[num + 1] = nil
	
	return chunk
end

function P3D.SurfaceTypeListP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local typesN = #self.Types
	
	local headerLen = 12 + 4 + 4 + typesN
	return string_pack("<IIIII" .. string_rep("B", typesN), self.Identifier, headerLen, headerLen + #chunkData, self.Version, typesN, table_unpack(self.Types)) .. chunkData
end