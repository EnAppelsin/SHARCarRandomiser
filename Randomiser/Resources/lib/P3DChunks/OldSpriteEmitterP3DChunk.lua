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

local function new(self, Version, Name, ShaderName, AngleMode, Angle, TextureAnimMode, NumTextureFrames, TextureFrameRate)
	assert(type(Version) == "number", "Arg #1 (Version) must be a number.")
	assert(type(Name) == "string", "Arg #2 (Name) must be a string.")
	assert(type(ShaderName) == "string", "Arg #3 (ShaderName) must be a string.")
	assert(type(AngleMode) == "string", "Arg #4 (AngleMode) must be a string.")
	assert(type(Angle) == "number", "Arg #5 (Angle) must be a number.")
	assert(type(TextureAnimMode) == "string", "Arg #6 (TextureAnimMode) must be a string.")
	assert(type(NumTextureFrames) == "number", "Arg #7 (NumTextureFrames) must be a number.")
	assert(type(TextureFrameRate) == "number", "Arg #8 (TextureFrameRate) must be a number.")

	local Data = {
		Chunks = {},
		Version = Version,
		Name = Name,
		ShaderName = ShaderName,
		AngleMode = AngleMode,
		Angle = Angle,
		TextureAnimMode = TextureAnimMode,
		NumTextureFrames = NumTextureFrames,
		TextureFrameRate = TextureFrameRate,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.OldSpriteEmitterP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Old_Sprite_Emitter)
P3D.OldSpriteEmitterP3DChunk.new = new
function P3D.OldSpriteEmitterP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Version, chunk.Name, chunk.ShaderName, chunk.AngleMode, chunk.Angle, chunk.TextureAnimMode, chunk.NumTextureFrames, chunk.TextureFrameRate = string_unpack("<Is1s1c4fc4II", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	chunk.ShaderName = P3D.CleanP3DString(chunk.ShaderName)

	return chunk
end

function P3D.OldSpriteEmitterP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local ShaderName = P3D.MakeP3DString(self.ShaderName)
	
	local headerLen = 12 + 4 + #Name + 1 + #ShaderName + 1 + 4 + 4 + 4 + 4 + 4
	return string_pack("<IIIIs1s1c4fc4II", self.Identifier, headerLen, headerLen + #chunkData, self.Version, Name, ShaderName, self.AngleMode, self.Angle, self.TextureAnimMode, self.NumTextureFrames, self.TextureFrameRate) .. chunkData
end