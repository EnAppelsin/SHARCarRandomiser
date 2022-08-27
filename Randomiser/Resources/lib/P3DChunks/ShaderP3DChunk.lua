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

local function new(self, Name, Version, PddiShaderName, HasTranslucency, VertexNeeds, VertexMask)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string.")
	assert(type(Version) == "number", "Arg #2 (Version) must be a number.")
	assert(type(PddiShaderName) == "string", "Arg #3 (PddiShaderName) must be a string.")
	assert(type(HasTranslucency) == "number", "Arg #4 (HasTranslucency) must be a number.")
	assert(type(VertexNeeds) == "number", "Arg #5 (VertexNeeds) must be a number.")
	assert(type(VertexMask) == "number", "Arg #6 (VertexMask) must be a number.")

	local Data = {
		Chunks = {},
		Name = Name,
		Version = Version,
		PddiShaderName = PddiShaderName,
		HasTranslucency = HasTranslucency,
		VertexNeeds = VertexNeeds,
		VertexMask = VertexMask,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.ShaderP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Shader)
P3D.ShaderP3DChunk.new = new
function P3D.ShaderP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Name, chunk.Version, chunk.PddiShaderName, chunk.HasTranslucency, chunk.VertexNeeds, chunk.VertexMask = string_unpack("<s1Is1III", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	chunk.PddiShaderName = P3D.CleanP3DString(chunk.PddiShaderName)

	return chunk
end

function P3D.ShaderP3DChunk:GetParameter(Param)
	assert(type(Param) == "string", "Arg #1 (Param) must be a string.")
	
	Param = Param:upper()
	for i=1,#self.Chunks do
		local chunk = self.Chunks[i]
		if chunk.Param and P3D.CleanP3DString(chunk.Param) == Param then
			return chunk
		end
	end
end

function P3D.ShaderP3DChunk:__tostring()
	local chunks = {}
	local chunksN = #self.Chunks
	for i=1,chunksN do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local PddiShaderName = P3D.MakeP3DString(self.PddiShaderName)
	
	local headerLen = 12 + #Name + 1 + 4 + #PddiShaderName + 1 + 4 + 4 + 4 + 4
	return string_pack("<IIIs1Is1IIII", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Version, PddiShaderName, self.HasTranslucency, self.VertexNeeds, self.VertexMask, chunksN) .. chunkData
end