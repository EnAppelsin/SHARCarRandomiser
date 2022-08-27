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

local function new(self, Name, Version, Type, Colour, Constant, Linear, Squard, Enabled)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Version) == "number", "Arg #2 (Version) must be a number")
	assert(type(Type) == "number", "Arg #3 (Type) must be a number")
	assert(type(Colour) == "table", "Arg #4 (Colour) must be a table")
	assert(type(Constant) == "number", "Arg #5 (Constant) must be a number")
	assert(type(Linear) == "number", "Arg #6 (Linear) must be a number")
	assert(type(Squard) == "number", "Arg #7 (Squard) must be a number")
	assert(type(Enabled) == "number", "Arg #8 (Enabled) must be a number")
	
	local Data = {
		Chunks = {},
		Name = Name
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.LightP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Light)
P3D.LightP3DChunk.new = new
P3D.LightP3DChunk.Types = {
	Ambient = 0,
	Directional = 2
}
function P3D.LightP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Colour = {}
	chunk.Name, chunk.Version, chunk.Type, chunk.Colour.B, chunk.Colour.G, chunk.Colour.R, chunk.Colour.A, chunk.Constant, chunk.Linear, chunk.Squard, chunk.Enabled = string_unpack("<s1IIBBBBfffI", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	
	return chunk
end

function P3D.LightP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + #Name + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 4
	return string_pack("<IIIs1IIBBBBfffI", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Version, self.Type, self.Colour.B, self.Colour.G, self.Colour.R, self.Colour.A, self.Constant, self.Linear, self.Squard, self.Enabled) .. chunkData
end