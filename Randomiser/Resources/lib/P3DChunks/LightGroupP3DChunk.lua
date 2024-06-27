--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.LightGroupP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Name, Lights)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Lights) == "table", "Arg #2 (Lights) must be a table")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Name = Name,
		Lights = Lights
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.LightGroupP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Light_Group)
P3D.LightGroupP3DChunk.new = new
function P3D.LightGroupP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos
	chunk.Name, num, pos = string_unpack(Endian .. "s1I", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	
	chunk.Lights = {string_unpack(Endian .. string_rep("s1", num), chunk.ValueStr, pos)}
	chunk.Lights[num + 1] = nil
	for i=1,num do
		chunk.Lights[i] = P3D.CleanP3DString(chunk.Lights[i])
	end
	
	return chunk
end

function P3D.LightGroupP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local lights = {}
	local lightsN = #self.Lights
	for i=1,lightsN do
		lights[i] = string_pack(self.Endian .. "s1", P3D.MakeP3DString(self.Lights[i]))
	end
	local lightsData = table_concat(lights)
	
	local headerLen = 12 + #Name + 1 + 4 + #lightsData
	return string_pack(self.Endian .. "IIIs1I", self.Identifier, headerLen, headerLen + #chunkData, Name, lightsN) .. lightsData .. chunkData
end