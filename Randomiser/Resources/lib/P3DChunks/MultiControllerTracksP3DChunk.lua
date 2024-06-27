--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.MultiControllerTracksP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Tracks)
	assert(type(Tracks) == "table", "Arg #1 (Tracks) must be a table")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Tracks = Tracks,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.MultiControllerTracksP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Multi_Controller_Tracks)
P3D.MultiControllerTracksP3DChunk.new = new
function P3D.MultiControllerTracksP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos = string_unpack(Endian .. "I", chunk.ValueStr)
	
	chunk.Tracks = {}
	for i=1,num do
		local track = {}
		track.Name, track.StartTime, track.EndTime, track.Scale, pos = string_unpack(Endian .. "s1fff", chunk.ValueStr, pos)
		chunk.Tracks[i] = track
		track.Name = P3D.CleanP3DString(track.Name)
	end
	
	return chunk
end

function P3D.MultiControllerTracksP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local tracksN = #self.Tracks
	local tracks = {}
	for i=1,tracksN do
		local track = self.Tracks[i]
		tracks[i] = string_pack(self.Endian .. "s1fff", P3D.MakeP3DString(track.Name), track.StartTime, track.EndTime, track.Scale)
	end
	local tracksData = table_concat(tracks)
	
	local headerLen = 12 + 4 + #tracksData
	return string_pack(self.Endian .. "IIII", self.Identifier, headerLen, headerLen + #chunkData, tracksN) .. tracksData .. chunkData
end