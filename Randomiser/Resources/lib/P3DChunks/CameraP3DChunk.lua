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

local function new(self, Name, Version, FOV, AspectRatio, NearClip, FarClip, Position, Look, Up)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Version) == "number", "Arg #2 (Version) must be a number")
	assert(type(FOV) == "number", "Arg #3 (FOV) must be a number")
	assert(type(AspectRatio) == "number", "Arg #4 (AspectRatio) must be a number")
	assert(type(NearClip) == "number", "Arg #5 (NearClip) must be a number")
	assert(type(FarClip) == "number", "Arg #6 (FarClip) must be a number")
	assert(type(Position) == "table", "Arg #7 (Position) must be a table")
	assert(type(Look) == "table", "Arg #8 (Look) must be a table")
	assert(type(Up) == "table", "Arg #9 (Up) must be a table")
	
	local Data = {
		Chunks = {},
		Name = Name,
		Version = Version,
		FOV = FOV,
		AspectRatio = AspectRatio,
		NearClip = NearClip,
		FarClip = FarClip,
		Position = Position,
		Look = Look,
		Up = Up
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.CameraP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Camera)
P3D.CameraP3DChunk.new = new
function P3D.CameraP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Position = {}
	chunk.Look = {}
	chunk.Up = {}
	chunk.Name, chunk.Version, chunk.FOV, chunk.AspectRatio, chunk.NearClip, chunk.FarClip, chunk.Position.X, chunk.Position.Y, chunk.Position.Z, chunk.Look.X, chunk.Look.Y, chunk.Look.Z, chunk.Up.X, chunk.Up.Y, chunk.Up.Z = string_unpack("<s1Ifffffffffffff", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	
	return chunk
end

function P3D.CameraP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + #Name + 1 + 4 + 4 + 4 + 4 + 4 + 12 + 12 + 12
	return string_pack("<IIIs1Ifffffffffffff", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Version, self.FOV, self.AspectRatio, self.NearClip, self.FarClip, self.Position.X, self.Position.Y, self.Position.Z, self.Look.X, self.Look.Y, self.Look.Z, self.Up.X, self.Up.Y, self.Up.Z) .. chunkData
end