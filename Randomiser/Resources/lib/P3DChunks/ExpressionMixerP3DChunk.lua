--[[
CREDITS:
	Proddy#7272				- Converting to Lua, P3D Chunk Structure
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

local function new(self, Version, Name, Type, TargetName, ExpressionGroupName)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number")
	assert(type(Name) == "string", "Arg #2 (Name) must be a string")
	assert(type(Type) == "number", "Arg #3 (Type) must be a number")
	assert(type(TargetName) == "string", "Arg #4 (TargetName) must be a string")
	assert(type(ExpressionGroupName) == "string", "Arg #5 (ExpressionGroupName) must be a string")
	
	local Data = {
		Chunks = {},
		Version = Version,
		Name = Name,
		Type = Type,
		TargetName = TargetName,
		ExpressionGroupName
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.ExpressionMixerP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Expression_Mixer)
P3D.ExpressionMixerP3DChunk.new = new
function P3D.ExpressionMixerP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Version, chunk.Name, chunk.Type, chunk.TargetName, chunk.ExpressionGroupName = string_unpack("<Is1Is1s1", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	chunk.TargetName = P3D.CleanP3DString(chunk.TargetName)
	chunk.ExpressionGroupName = P3D.CleanP3DString(chunk.ExpressionGroupName)
	
	return chunk
end

function P3D.ExpressionMixerP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local TargetName = P3D.MakeP3DString(self.TargetName)
	local ExpressionGroupName = P3D.MakeP3DString(self.ExpressionGroupName)
	
	local headerLen = 12 + 4 + #Name + 1 + 4 + #TargetName + 1 + #ExpressionGroupName + 1
	return string_pack("<IIIIs1Is1s1", self.Identifier, headerLen, headerLen + #chunkData, self.Version, Name, self.Type, TargetName, ExpressionGroupName) .. chunkData
end