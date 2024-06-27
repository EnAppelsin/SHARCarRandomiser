--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.OldScenegraphLightGroupP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Name, LightGroupName)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string.")
	assert(type(LightGroupName) == "string", "Arg #2 (LightGroupName) must be a string.")

	local Data = {
		Endian = "<",
		Chunks = {},
		Name = Name,
		LightGroupName = LightGroupName,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.OldScenegraphLightGroupP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Old_Scenegraph_Light_Group)
P3D.OldScenegraphLightGroupP3DChunk.new = new
function P3D.OldScenegraphLightGroupP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Name, chunk.LightGroupName = string_unpack(Endian .. "s1s1", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	chunk.LightGroupName = P3D.CleanP3DString(chunk.LightGroupName)

	return chunk
end

function P3D.OldScenegraphLightGroupP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local LightGroupName = P3D.MakeP3DString(self.LightGroupName)
	
	local headerLen = 12 + #Name + 1 + #LightGroupName + 1
	return string_pack(self.Endian .. "IIIs1s1", self.Identifier, headerLen, headerLen + #chunkData, Name, LightGroupName) .. chunkData
end