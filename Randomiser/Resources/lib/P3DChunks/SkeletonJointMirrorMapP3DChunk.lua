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

local function new(self, MappedJointIndex, XAxisMap, YAxisMap, ZAxisMap)
	assert(type(MappedJointIndex) == "number", "Arg #1 (MappedJointIndex) must be a number.")
	assert(type(XAxisMap) == "number", "Arg #2 (XAxisMap) must be a number.")
	assert(type(YAxisMap) == "number", "Arg #3 (YAxisMap) must be a number.")
	assert(type(ZAxisMap) == "number", "Arg #4 (ZAxisMap) must be a number.")

	local Data = {
		Chunks = {},
		MappedJointIndex = MappedJointIndex,
		XAxisMap = XAxisMap,
		YAxisMap = YAxisMap,
		ZAxisMap = ZAxisMap,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.SkeletonJointMirrorMapP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Skeleton_Joint_Mirror_Map)
P3D.SkeletonJointMirrorMapP3DChunk.new = new
function P3D.SkeletonJointMirrorMapP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.MappedJointIndex, chunk.XAxisMap, chunk.YAxisMap, chunk.ZAxisMap = string_unpack("<Ifff", chunk.ValueStr)

	return chunk
end

function P3D.SkeletonJointMirrorMapP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 4 + 4 + 4 + 4
	return string_pack("<IIIIfff", self.Identifier, headerLen, headerLen + #chunkData, self.MappedJointIndex, self.XAxisMap, self.YAxisMap, self.ZAxisMap) .. chunkData
end