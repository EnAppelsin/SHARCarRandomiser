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

local function new(self, Name, Version, PageNames)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Version) == "number", "Arg #2 (Version) must be a number")
	assert(type(PageNames) == "table", "Arg #3 (Filename) must be a table")
	
	local Data = {
		Chunks = {},
		Name = Name,
		Version = Version,
		PageNames = PageNames,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.FrontendScreenP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Frontend_Screen)
P3D.FrontendScreenP3DChunk.new = new
function P3D.FrontendScreenP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos
	chunk.Name, chunk.Version, num, pos = string_unpack("<s1II", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	
	chunk.PageNames = table_pack(string_unpack("<" .. string_rep("s1", num), chunk.ValueStr, pos))
	chunk.PageNames[num + 1] = nil
	
	return chunk
end

function P3D.FrontendScreenP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local num = #self.PageNames
	
	local valuesData = string_pack("<" .. string_rep("s1", num), table_unpack(self.PageNames))
	
	local headerLen = 12 + #Name + 1 + 4 + 4 + #valuesData
	return string_pack("<IIIs1II", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Version, num) .. valuesData .. chunkData
end