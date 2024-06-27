--[[
CREDITS:
	Proddy#7272				- Converting to Lua, P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.RailCamP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Name, Behaviour, MinRadius, MaxRadius, TrackRail, TrackDist, ReverseSense, FOV, TargetOffset, AxisPlay, PositionLag, TargetLag)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string.")
	assert(type(Behaviour) == "number", "Arg #2 (Behaviour) must be a number.")
	assert(type(MinRadius) == "number", "Arg #3 (MinRadius) must be a number.")
	assert(type(MaxRadius) == "number", "Arg #4 (MaxRadius) must be a number.")
	assert(type(TrackRail) == "number", "Arg #5 (TrackRail) must be a number.")
	assert(type(TrackDist) == "number", "Arg #6 (TrackDist) must be a number.")
	assert(type(ReverseSense) == "number", "Arg #7 (ReverseSense) must be a number.")
	assert(type(FOV) == "number", "Arg #8 (FOV) must be a number.")
	assert(type(TargetOffset) == "table", "Arg #9 (TargetOffset) must be a table.")
	assert(type(AxisPlay) == "table", "Arg #10 (AxisPlay) must be a table.")
	assert(type(PositionLag) == "number", "Arg #11 (PositionLag) must be a number.")
	assert(type(TargetLag) == "number", "Arg #12 (TargetLag) must be a number.")

	local Data = {
		Endian = "<",
		Chunks = {},
		Name = Name,
		Behaviour = Behaviour,
		MinRadius = MinRadius,
		MaxRadius = MaxRadius,
		TrackRail = TrackRail,
		TrackDist = TrackDist,
		ReverseSense = ReverseSense,
		FOV = FOV,
		TargetOffset = TargetOffset,
		AxisPlay = AxisPlay,
		PositionLag = PositionLag,
		TargetLag = TargetLag,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.RailCamP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Rail_Cam)
P3D.RailCamP3DChunk.new = new
function P3D.RailCamP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	chunk.TargetOffset = {}
	chunk.AxisPlay = {}
	chunk.Name, chunk.Behaviour, chunk.MinRadius, chunk.MaxRadius, chunk.TrackRail, chunk.TrackDist, chunk.ReverseSense, chunk.FOV, chunk.TargetOffset.X, chunk.TargetOffset.Y, chunk.TargetOffset.Z, chunk.AxisPlay.X, chunk.AxisPlay.Y, chunk.AxisPlay.Z, chunk.PositionLag, chunk.TargetLag = string_unpack(Endian .. "s1IffIfIfffffffff", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)

	return chunk
end

function P3D.RailCamP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + #Name + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 12 + 12 + 4 + 4
	return string_pack(self.Endian .. "IIIs1IffIfIfffffffff", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Behaviour, self.MinRadius, self.MaxRadius, self.TrackRail, self.TrackDist, self.ReverseSense, self.FOV, self.TargetOffset.X, self.TargetOffset.Y, self.TargetOffset.Z, self.AxisPlay.X, self.AxisPlay.Y, self.AxisPlay.Z, self.PositionLag, self.TargetLag) .. chunkData
end