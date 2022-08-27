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

local function new(self, Name, Parent, DOF, FreeAxis, PrimaryAxis, SecondaryAxis, TwistAxis, RestPose)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string.")
	assert(type(Parent) == "number", "Arg #2 (Parent) must be a number.")
	assert(type(DOF) == "number", "Arg #3 (DOF) must be a number.")
	assert(type(FreeAxis) == "number", "Arg #4 (FreeAxis) must be a number.")
	assert(type(PrimaryAxis) == "number", "Arg #5 (PrimaryAxis) must be a number.")
	assert(type(SecondaryAxis) == "number", "Arg #6 (SecondaryAxis) must be a number.")
	assert(type(TwistAxis) == "number", "Arg #7 (TwistAxis) must be a number.")
	assert(type(RestPose) == "table", "Arg #8 (RestPose) must be a table.")

	local Data = {
		Chunks = {},
		Name = Name,
		Parent = Parent,
		DOF = DOF,
		FreeAxis = FreeAxis,
		PrimaryAxis = PrimaryAxis,
		SecondaryAxis = SecondaryAxis,
		TwistAxis = TwistAxis,
		RestPose = RestPose,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.SkeletonJointP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Skeleton_Joint)
P3D.SkeletonJointP3DChunk.new = new
function P3D.SkeletonJointP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.RestPose = {}
	chunk.Name, chunk.Parent, chunk.DOF, chunk.FreeAxis, chunk.PrimaryAxis, chunk.SecondaryAxis, chunk.TwistAxis, chunk.RestPose.M11, chunk.RestPose.M12, chunk.RestPose.M13, chunk.RestPose.M14, chunk.RestPose.M21, chunk.RestPose.M22, chunk.RestPose.M23, chunk.RestPose.M24, chunk.RestPose.M31, chunk.RestPose.M32, chunk.RestPose.M33, chunk.RestPose.M34, chunk.RestPose.M41, chunk.RestPose.M42, chunk.RestPose.M43, chunk.RestPose.M44 = string_unpack("<s1Iiiiiiffffffffffffffff", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)

	return chunk
end

function P3D.SkeletonJointP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + #Name + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 64
	return string_pack("<IIIs1Iiiiiiffffffffffffffff", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Parent, self.DOF, self.FreeAxis, self.PrimaryAxis, self.SecondaryAxis, self.TwistAxis, self.RestPose.M11, self.RestPose.M12, self.RestPose.M13, self.RestPose.M14, self.RestPose.M21, self.RestPose.M22, self.RestPose.M23, self.RestPose.M24, self.RestPose.M31, self.RestPose.M32, self.RestPose.M33, self.RestPose.M34, self.RestPose.M41, self.RestPose.M42, self.RestPose.M43, self.RestPose.M44) .. chunkData
end