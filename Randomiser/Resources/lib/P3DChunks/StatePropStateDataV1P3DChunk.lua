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

local function new(self, Name, AutoTransition, OutState, NumDrawables, NumFrameControllers, NumEvents, NumCallbacks, OutFrame)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string.")
	assert(type(AutoTransition) == "number", "Arg #2 (AutoTransition) must be a number.")
	assert(type(OutState) == "number", "Arg #3 (OutState) must be a number.")
	assert(type(NumDrawables) == "number", "Arg #4 (NumDrawables) must be a number.")
	assert(type(NumFrameControllers) == "number", "Arg #5 (NumFrameControllers) must be a number.")
	assert(type(NumEvents) == "number", "Arg #6 (NumEvents) must be a number.")
	assert(type(NumCallbacks) == "number", "Arg #7 (NumCallbacks) must be a number.")
	assert(type(OutFrame) == "number", "Arg #8 (OutFrame) must be a number.")

	local Data = {
		Chunks = {},
		Name = Name,
		AutoTransition = AutoTransition,
		OutState = OutState,
		NumDrawables = NumDrawables,
		NumFrameControllers = NumFrameControllers,
		NumEvents = NumEvents,
		NumCallbacks = NumCallbacks,
		OutFrame = OutFrame,
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.StatePropStateDataV1P3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.State_Prop_State_Data_V1)
P3D.StatePropStateDataV1P3DChunk.new = new
function P3D.StatePropStateDataV1P3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Name, chunk.AutoTransition, chunk.OutState, chunk.NumDrawables, chunk.NumFrameControllers, chunk.NumEvents, chunk.NumCallbacks, chunk.OutFrame = string_unpack("<s1IIIIIIf", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)

	return chunk
end

function P3D.StatePropStateDataV1P3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + #Name + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 4
	return string_pack("<IIIs1IIIIIIf", self.Identifier, headerLen, headerLen + #chunkData, Name, self.AutoTransition, self.OutState, self.NumDrawables, self.NumFrameControllers, self.NumEvents, self.NumCallbacks, self.OutFrame) .. chunkData
end