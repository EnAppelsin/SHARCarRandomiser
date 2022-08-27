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

local function new(self, SplitAxis, SplitPosition, StaticEntityLimit, StaticPhysEntityLimit, IntersectEntityLimit, DynaPhysEntityLimit, FenceEntityLimit, RoadSegmentEntityLimit, PathSegmentEntityLimit, AnimEntityLimit)
	assert(type(SplitAxis) == "number", "Arg #1 (SplitAxis) must be a number.")
	assert(type(SplitPosition) == "number", "Arg #2 (SplitPosition) must be a number.")
	assert(type(StaticEntityLimit) == "number", "Arg #3 (StaticEntityLimit) must be a number.")
	assert(type(StaticPhysEntityLimit) == "number", "Arg #4 (StaticPhysEntityLimit) must be a number.")
	assert(type(IntersectEntityLimit) == "number", "Arg #5 (IntersectEntityLimit) must be a number.")
	assert(type(DynaPhysEntityLimit) == "number", "Arg #6 (DynaPhysEntityLimit) must be a number.")
	assert(type(FenceEntityLimit) == "number", "Arg #7 (FenceEntityLimit) must be a number.")
	assert(type(RoadSegmentEntityLimit) == "number", "Arg #8 (RoadSegmentEntityLimit) must be a number.")
	assert(type(PathSegmentEntityLimit) == "number", "Arg #9 (PathSegmentEntityLimit) must be a number.")
	assert(type(AnimEntityLimit) == "number", "Arg #10 (AnimEntityLimit) must be a number.")

	local Data = {
		Chunks = {},
		SplitAxis = SplitAxis,
		SplitPosition = SplitPosition,
		StaticEntityLimit = StaticEntityLimit,
		StaticPhysEntityLimit = StaticPhysEntityLimit,
		IntersectEntityLimit = IntersectEntityLimit,
		DynaPhysEntityLimit = DynaPhysEntityLimit,
		FenceEntityLimit = FenceEntityLimit,
		RoadSegmentEntityLimit = RoadSegmentEntityLimit,
		PathSegmentEntityLimit = PathSegmentEntityLimit,
		AnimEntityLimit = AnimEntityLimit,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.TreeNode2P3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Tree_Node_2)
P3D.TreeNode2P3DChunk.new = new
function P3D.TreeNode2P3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.SplitAxis, chunk.SplitPosition, chunk.StaticEntityLimit, chunk.StaticPhysEntityLimit, chunk.IntersectEntityLimit, chunk.DynaPhysEntityLimit, chunk.FenceEntityLimit, chunk.RoadSegmentEntityLimit, chunk.PathSegmentEntityLimit, chunk.AnimEntityLimit = string_unpack("<bfIIIIIIII", chunk.ValueStr)

	return chunk
end

function P3D.TreeNode2P3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4
	return string_pack("<IIIbfIIIIIIII", self.Identifier, headerLen, headerLen + #chunkData, self.SplitAxis, self.SplitPosition, self.StaticEntityLimit, self.StaticPhysEntityLimit, self.IntersectEntityLimit, self.DynaPhysEntityLimit, self.FenceEntityLimit, self.RoadSegmentEntityLimit, self.PathSegmentEntityLimit, self.AnimEntityLimit) .. chunkData
end