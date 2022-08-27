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

local function new(self, Version, Name, TargetName, Stages)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number")
	assert(type(Name) == "string", "Arg #2 (Name) must be a string")
	assert(type(TargetName) == "string", "Arg #3 (TargetName) must be a string")
	assert(type(Stages) == "table", "Arg #4 (Stages) must be a table")
	
	local Data = {
		Chunks = {},
		Version = Version,
		Name = Name,
		TargetName = TargetName,
		Stages = Stages
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.ExpressionGroupP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Expression_Group)
P3D.ExpressionGroupP3DChunk.new = new
function P3D.ExpressionGroupP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos
	chunk.Version, chunk.Name, chunk.TargetName, num, pos = string_unpack("<Is1s1I", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	chunk.TargetName = P3D.CleanP3DString(chunk.TargetName)
	
	chunk.Stages = table_pack(string_unpack("<" .. string_rep("I", num), chunk.ValueStr, pos))
	chunk.Stages[num + 1] = nil
	
	return chunk
end

function P3D.ExpressionGroupP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local TargetName = P3D.MakeP3DString(self.TargetName)
	local stagesN = #self.Stages
	
	local headerLen = 12 + 4 + #Name + 1 + #TargetName + 1 + 4 + stagesN * 4
	return string_pack("<IIIIs1s1I" .. string_rep("I", stagesN), self.Identifier, headerLen, headerLen + #chunkData, self.Version, Name, TargetName, stagesN, table_unpack(self.Stages)) .. chunkData
end