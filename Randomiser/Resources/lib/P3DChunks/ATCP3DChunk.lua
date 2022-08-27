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

local function new(self, Entries)
	assert(type(Entries) == "table", "Arg #1 (Entries) must be a table")
	
	local Data = {
		Chunks = {},
		Entries = Entries
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.ATCP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.ATC)
P3D.ATCP3DChunk.new = new
function P3D.ATCP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local count, pos = string_unpack("<I", chunk.ValueStr)
	
	local Entries = {}
	for i=1,count do
		local entry = {}
		entry.SoundResourceDataName, entry.Particle, entry.BreakableObject, entry.Friction, entry.Mass, entry.Elasticity, pos = string_unpack("<s1s1s1fff", chunk.ValueStr, pos)
		entry.SoundResourceDataName = P3D.CleanP3DString(entry.SoundResourceDataName)
		entry.Particle = P3D.CleanP3DString(entry.Particle)
		entry.BreakableObject = P3D.CleanP3DString(entry.BreakableObject)
		Entries[i] = entry
	end
	chunk.Entries = Entries
	
	return chunk
end

function P3D.ATCP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local entryCount = #self.Entries
	local entries = {}
	for i=1,entryCount do
		local entry = self.Entries[i]
		entries[i] = string_pack("<s1s1s1fff", P3D.MakeP3DString(entry.SoundResourceDataName), P3D.MakeP3DString(entry.Particle), P3D.MakeP3DString(entry.BreakableObject), entry.Friction, entry.Mass, entry.Elasticity)
	end
	local entryData = table_concat(entries)
	
	local headerLen = 12 + 4 + #entryData
	return string_pack("<IIII", self.Identifier, headerLen, headerLen + #chunkData, entryCount) .. entryData .. chunkData
end