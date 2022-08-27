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

local function new(self, Name, NativeX, NativeY, Shader, ImageWidth, ImageHeight, BlitBorder)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string.")
	assert(type(NativeX) == "number", "Arg #2 (NativeX) must be a number.")
	assert(type(NativeY) == "number", "Arg #3 (NativeY) must be a number.")
	assert(type(Shader) == "string", "Arg #4 (Shader) must be a string.")
	assert(type(ImageWidth) == "number", "Arg #5 (ImageWidth) must be a number.")
	assert(type(ImageHeight) == "number", "Arg #6 (ImageHeight) must be a number.")
	assert(type(BlitBorder) == "number", "Arg #7 (BlitBorder) must be a number.")

	local Data = {
		Chunks = {},
		Name = Name,
		NativeX = NativeX,
		NativeY = NativeY,
		Shader = Shader,
		ImageWidth = ImageWidth,
		ImageHeight = ImageHeight,
		BlitBorder = BlitBorder,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.SpriteP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Sprite)
P3D.SpriteP3DChunk.new = new
function P3D.SpriteP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local ImageCount
	chunk.Name, chunk.NativeX, chunk.NativeY, chunk.Shader, chunk.ImageWidth, chunk.ImageHeight, ImageCount, chunk.BlitBorder = string_unpack("<s1IIs1IIII", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	chunk.Shader = P3D.CleanP3DString(chunk.Shader)

	return chunk
end

function P3D.SpriteP3DChunk:GetImageCount()
	local n = 0
	for i=1,#self.Chunks do
		if self.Chunks[i].Identifier == P3D.Identifiers.Image then
			n = n + 1
		end
	end
	return n
end

function P3D.SpriteP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local Shader = P3D.MakeP3DString(self.Shader)
	
	local headerLen = 12 + #Name + 1 + 4 + 4 + #Shader + 1 + 4 + 4 + 4 + 4
	return string_pack("<IIIs1IIs1IIII", self.Identifier, headerLen, headerLen + #chunkData, Name, self.NativeX, self.NativeY, Shader, self.ImageWidth, self.ImageHeight, self:GetImageCount(), self.BlitBorder) .. chunkData
end