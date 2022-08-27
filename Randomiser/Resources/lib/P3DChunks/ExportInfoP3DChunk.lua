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

local function new(self, Name)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	
	local Data = {
		Chunks = {},
		Name = Name
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.ExportInfoP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Export_Info)
P3D.ExportInfoP3DChunk.new = new
function P3D.ExportInfoP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Name = string_unpack("<s1", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	
	return chunk
end

function P3D.ExportInfoP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + #Name + 1
	return string_pack("<IIIs1", self.Identifier, headerLen, headerLen + #chunkData, Name) .. chunkData
end