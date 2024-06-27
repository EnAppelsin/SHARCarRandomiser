--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.BreakableObjectP3DChunk == nil, "Chunk type already loaded.")

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

local function new(self, Index, MaxInstances)
	assert(type(Index) == "number", "Arg #1 (Index) must be a number")
	assert(type(MaxInstances) == "number", "Arg #2 (MaxInstances) must be a number")
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Index = Index,
		MaxInstances = MaxInstances
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.BreakableObjectP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Breakable_Object)
P3D.BreakableObjectP3DChunk.new = new
P3D.BreakableObjectP3DChunk.Indexes = {
	Null = -1,
	HydrantBreaking = 3,
	MailboxBreaking = 5,
	ParkingMeterBreaking = 6,
	WoodenCratesBreaking = 7,
	TommacoPlantsBreaking = 8,
	PowerCouplingBreaking = 9,
	PineTreeBreaking = 14,
	OakTreeBreaking = 15,
	BigBarrierBreaking = 16,
	RailCrossBreaking = 17,
	SpaceNeedleBreaking = 18,
	KrustyGlassBreaking = 19,
	CypressTreeBreaking = 20,
	DeadTreeBreaking = 21,
	SkeletonBreaking = 22,
	Willow = 23,
	CarExplosion = 24,
	GlobeLight = 25,
	TreeMorn = 26,
	PalmTreeSmall = 27,
	PalmTreeLarge = 28,
	Stopsign = 29,
	Pumpkin = 30,
	PumpkinMed = 31,
	PumpkinSmall = 32,
	CasinoJump = 33,
}
function P3D.BreakableObjectP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Index, chunk.MaxInstances = string_unpack(Endian .. "II", chunk.ValueStr)
	
	return chunk
end

function P3D.BreakableObjectP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 4 + 4
	return string_pack(self.Endian .. "IIIII", self.Identifier, headerLen, headerLen + #chunkData, self.Index, self.MaxInstances) .. chunkData
end