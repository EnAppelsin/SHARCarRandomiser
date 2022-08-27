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

local function new(self, Name, Cyclic, NumberOfCycles, HoldFrame, MinFrame, MaxFrame, RelativeSpeed)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string.")
	assert(type(Cyclic) == "number", "Arg #2 (Cyclic) must be a number.")
	assert(type(NumberOfCycles) == "number", "Arg #3 (NumberOfCycles) must be a number.")
	assert(type(HoldFrame) == "number", "Arg #4 (HoldFrame) must be a number.")
	assert(type(MinFrame) == "number", "Arg #5 (MinFrame) must be a number.")
	assert(type(MaxFrame) == "number", "Arg #6 (MaxFrame) must be a number.")
	assert(type(RelativeSpeed) == "number", "Arg #7 (RelativeSpeed) must be a number.")

	local Data = {
		Chunks = {},
		Name = Name,
		Cyclic = Cyclic,
		NumberOfCycles = NumberOfCycles,
		HoldFrame = HoldFrame,
		MinFrame = MinFrame,
		MaxFrame = MaxFrame,
		RelativeSpeed = RelativeSpeed,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.StatePropFrameControllerDataP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.State_Prop_Frame_Controller_Data)
P3D.StatePropFrameControllerDataP3DChunk.new = new
function P3D.StatePropFrameControllerDataP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Name, chunk.Cyclic, chunk.NumberOfCycles, chunk.HoldFrame, chunk.MinFrame, chunk.MaxFrame, chunk.RelativeSpeed = string_unpack("<s1IIIfff", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)

	return chunk
end

function P3D.StatePropFrameControllerDataP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + #Name + 1 + 4 + 4 + 4 + 4 + 4 + 4
	return string_pack("<IIIs1IIIfff", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Cyclic, self.NumberOfCycles, self.HoldFrame, self.MinFrame, self.MaxFrame, self.RelativeSpeed) .. chunkData
end