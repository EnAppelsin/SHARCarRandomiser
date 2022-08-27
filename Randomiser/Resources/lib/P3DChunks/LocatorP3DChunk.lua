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

local function new(self, Name, Position, Type, ...)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Position) == "table", "Arg #2 (Position) must be a table")
	assert(type(Type) == "number", "Arg #3 (Type) must be a number")
	local args = {...}
	
	local Data = {
		Chunks = {},
		Name = Name,
		Position = Position,
		Type = Type
	}
	
	if Type == 0 then -- Event
		local Event = args[1]
		local Parameter = args[2]
		assert(type(Event) == "number", "Arg #4 (Event) must be a number")
		assert(Parameter == nil or type(Parameter) == "number", "Arg #5 (Parameter) must be a number")
		
		Data.Event = Event
		Data.Parameter = Parameter
	elseif Type == 1 then -- Script
		local Key = args[1]
		assert(type(Key) == "string", "Key must be a string")
		
		Data.Key = Key
	elseif Type == 2 then -- Generic
		-- No extra data
	elseif Type == 3 then -- Car Start
		local Rotation = args[1]
		local ParkedCar = args[2]
		local FreeCar = args[3]
		assert(type(Rotation) == "number", "Arg #4 (Rotation) must be a number")
		assert(ParkedCar == nil or type(ParkedCar) == "number", "Arg #5 (ParkedCar) must be a number")
		assert(FreeCar == nil or type(FreeCar) == "string", "Arg #6 (FreeCar) must be a String")
		
		Data.Rotation = Rotation
		Data.ParkedCar = ParkedCar
		Data.FreeCar = FreeCar
	elseif Type == 4 then -- Spline
		-- No extra data
	elseif Type == 5 then -- Dynamic Zone
		local DynaLoadData = args[1]
		assert(type(DynaLoadData) == "string", "Arg #4 (DynaLoadData) must be a string")
		
		Data.DynaLoadData = DynaLoadData
	elseif Type == 6 then -- Occlusion
		local Occlusions = args[1]
		assert(Occlusions == nil or type(Occlusions) == "number", "Arg #4 (Occlusions) must be a number")
		
		Data.Occlusions = Occlusinos
	elseif Type == 7 then -- Interior Entrance
		local InteriorName = args[1]
		local Right = args[2]
		local Up = args[3]
		local Front = args[4]
		assert(type(InteriorName) == "string", "Arg #4 (InteriorName) must be a string")
		assert(type(Right) == "table", "Arg #5 (Right) must be a table")
		assert(type(Up) == "table", "Arg #6 (Up) must be a table")
		assert(type(Front) == "table", "Arg #7 (Front) must be a table")
		
		Data.InteriorName = InteriorName
		Data.Right = Right
		Data.Up = Up
		Data.Front = Front
	elseif Type == 8 then -- Directional
		local Right = args[1]
		local Up = args[2]
		local Front = args[3]
		assert(type(Right) == "table", "Arg #4 (Right) must be a table")
		assert(type(Up) == "table", "Arg #5 (Up) must be a table")
		assert(type(Front) == "table", "Arg #6 (Front) must be a table")
		
		Data.Right = Right
		Data.Up = Up
		Data.Front = Front
	elseif Type == 9 then -- Action
		local ObjectName = args[1]
		local JointName = args[2]
		local ActionName = args[3]
		local ButtonInput = args[4]
		local ShouldTransform = args[5]
		assert(type(ObjectName) == "string", "Arg #4 (ObjectName) must be a string")
		assert(type(JointName) == "string", "Arg #5 (JointName) must be a string")
		assert(type(ActionName) == "string", "Arg #6 (ActionName) must be a string")
		assert(type(ButtonInput) == "number", "Arg #7 (ButtonInput) must be a number")
		assert(type(ShouldTransform) == "number", "Arg #8 (ShouldTransform) must be a number")
		
		Data.ObjectName = ObjectName
		Data.JointName = JointName
		Data.ActionName = ActionName
		Data.ButtonInput = ButtonInput
		Data.ShouldTransform = ShouldTransform
	elseif Type == 10 then -- FOV
		local FOV = args[1]
		local Time = args[2]
		local Rate = args[3]
		assert(type(FOV) == "number", "Arg #4 (FOV) must be a number")
		assert(type(Time) == "number", "Arg #5 (Time) must be a number")
		assert(type(Rate) == "number", "Arg #6 (Rate) must be a number")
		
		Data.FOV = FOV
		Data.Time = Time
		Data.Rate = Rate
	elseif Type == 11 then -- Breakable Camera
		-- No extra data
	elseif Type == 12 then -- Static Camera
		local TargetPosition = args[1]
		local FOV = args[2]
		local TargetLag = args[3]
		local FollowPlayer = args[4]
		local TransitionTargetRate = args[5]
		local Flags = args[6]
		local CutInOut = args[7]
		local Data2 = args[8]
		assert(type(TargetPosition) == "table", "Arg #4 (TargetPosition) must be a table")
		assert(type(FOV) == "number", "Arg #5 (FOV) must be a number")
		assert(type(TargetLag) == "number", "Arg #6 (TargetLag) must be a number")
		assert(type(FollowPlayer) == "number", "Arg #7 (FollowPlayer) must be a number")
		assert(TransitionTargetRate == nil or type(TransitionTargetRate) == "number", "Arg #8 (TransitionTargetRate) must be a number")
		assert(Flags == nil or type(Flags) == "number", "Arg #9 (Flags) must be a number")
		assert(CutInOut == nil or type(CutInOut) == "number", "Arg #10 (CutInOut) must be a number")
		assert(Data2 == nil or type(Data2) == "number", "Arg #11 (Data) must be a number")
		
		Data.TargetPosition = TargetPosition
		Data.FOV = FOV
		Data.TargetLag = TargetLag
		Data.FollowPlayer = FollowPlayer
		Data.TransitionTargetRate = TransitionTargetRate
		Data.Flags = Flags
		Data.CutInOut = CutInOut
		Data.Data = Data2
	elseif Type == 13 then -- Ped Group
		local GroupNum = args[1]
		assert(type(GroupNum) == "number", "Arg #4 (GroupNum) must be a number")
		
		Data.GroupNum = GroupNum
	elseif Type == 14 then -- Coin
		-- No extra data
	else
		local TypeData = args[1]
		assert(type(TypeData) == "string", "Arg #4 (TypeData) must be a string")
		Data.Data = TypeData
	end
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.LocatorP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Locator)
P3D.LocatorP3DChunk.new = new
function P3D.LocatorP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local pos, dataLen
	chunk.Name, chunk.Type, dataLen, pos = string_unpack("<s1II", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	chunk.Position = {}
	if chunk.Type == 0 then -- Event
		chunk.Event = string_unpack("<I", chunk.ValueStr, pos)
		if dataLen == 2 then
			chunk.Parameter = string_unpack("<I", chunk.ValueStr, pos + 4)
		end
	elseif chunk.Type == 1 then -- Script
		chunk.Key = string_unpack("<z", chunk.ValueStr, pos)
	elseif chunk.Type == 2 then -- Generic
		-- No extra data
	elseif chunk.Type == 3 then -- Car Start
		if dataLen == 1 then
			chunk.Rotation = string_unpack("<f", chunk.ValueStr, pos)
		elseif dataLen == 2 then
			chunk.Rotation, chunk.ParkedCar = string_unpack("<fI", chunk.ValueStr, pos)
		else
			chunk.Rotation, chunk.ParkedCar, chunk.FreeCar = string_unpack("<fIz", chunk.ValueStr, pos)
		end
	elseif chunk.Type == 4 then -- Spline
		-- No extra data
	elseif chunk.Type == 5 then -- Dynamic Zone
		chunk.DynaLoadData = string_unpack("<z", chunk.ValueStr, pos)
	elseif chunk.Type == 6 then -- Occlusion
		if dataLen ~= 0 then
			chunk.Occlusions = string_unpack("<I", chunk.ValueStr, pos)
		end
	elseif chunk.Type == 7 then -- Interior Entrance
		chunk.InteriorName = string_unpack("<z", chunk.ValueStr, pos)
		chunk.Right = {}
		chunk.Up = {}
		chunk.Front = {}
		chunk.Right.X, chunk.Right.Y, chunk.Right.Z, chunk.Up.X, chunk.Up.Y, chunk.Up.Z, chunk.Front.X, chunk.Front.Y, chunk.Front.Z = string_unpack("<fffffffff", chunk.ValueStr, pos + #chunk.InteriorName + 4 - (#chunk.InteriorName & 3))
	elseif chunk.Type == 8 then -- Directional
		chunk.Right = {}
		chunk.Up = {}
		chunk.Front = {}
		chunk.Right.X, chunk.Right.Y, chunk.Right.Z, chunk.Up.X, chunk.Up.Y, chunk.Up.Z, chunk.Front.X, chunk.Front.Y, chunk.Front.Z = string_unpack("<fffffffff", chunk.ValueStr, pos)
	elseif chunk.Type == 9 then -- Action
		local pos = pos
		chunk.ObjectName = string_unpack("<z", chunk.ValueStr, pos)
		pos = pos + #chunk.ObjectName + 4 - (#chunk.ObjectName & 3)
		chunk.JointName = string_unpack("<z", chunk.ValueStr, pos)
		pos = pos + #chunk.JointName + 4 - (#chunk.JointName & 3)
		chunk.ActionName = string_unpack("<z", chunk.ValueStr, pos)
		pos = pos + #chunk.ActionName + 4 - (#chunk.ActionName & 3)
		chunk.ButtonInput, chunk.ShouldTransform = string_unpack("II", chunk.ValueStr, pos)
	elseif chunk.Type == 10 then -- FOV
		chunk.FOV, chunk.Type, chunk.Rate = string_unpack("<fff", chunk.ValueStr, pos)
	elseif chunk.Type == 11 then -- Breakable Camera
		-- No extra data
	elseif chunk.Type == 12 then -- Static Camera
		chunk.TargetPosition = {}
		if dataLen >= 9 then
			chunk.TargetPosition.X, chunk.TargetPosition.Y, chunk.TargetPosition.Z, chunk.FOV, chunk.TargetLag, chunk.FollowPlayer, chunk.TransitionTargetRate, chunk.Flags, chunk.CutInOut, chunk.Data = string_unpack("<fffffIfIII", chunk.ValueStr, pos)
		elseif dataLen >= 8 then
			chunk.TargetPosition.X, chunk.TargetPosition.Y, chunk.TargetPosition.Z, chunk.FOV, chunk.TargetLag, chunk.FollowPlayer, chunk.TransitionTargetRate, chunk.Flags = string_unpack("<fffffIfI", chunk.ValueStr, pos)
		elseif dataLen >= 7 then
			chunk.TargetPosition.X, chunk.TargetPosition.Y, chunk.TargetPosition.Z, chunk.FOV, chunk.TargetLag, chunk.FollowPlayer, chunk.TransitionTargetRate = string_unpack("<fffffIf", chunk.ValueStr, pos)
		else
			chunk.TargetPosition.X, chunk.TargetPosition.Y, chunk.TargetPosition.Z, chunk.FOV, chunk.TargetLag, chunk.FollowPlayer = string_unpack("<fffffI", chunk.ValueStr, pos)
		end
	elseif chunk.Type == 13 then -- Ped Group
		chunk.GroupNum = string_unpack("<I", chunk.ValueStr, pos)
	elseif chunk.Type == 14 then -- Coin
		-- No extra data
	else
		chunk.Data = string_unpack("<c" ..dataLen * 4, chunk.ValueStr, pos)
	end
	pos = pos + dataLen * 4
	chunk.Position.X, chunk.Position.Y, chunk.Position.Z = string_unpack("fff", chunk.ValueStr, pos)
	
	return chunk
end

function P3D.LocatorP3DChunk:getTriggerCount()
	local triggerCount = 0
	for i=1,#self.Chunks do
		if self.Chunks[i].Identifier == P3D.Identifiers.Trigger_Volume then
			triggerCount = triggerCount + 1
		end
	end
	return triggerCount
end

function P3D.LocatorP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	
	local headerLen = 12 + #Name + 1 + 4 + 12 + 4
	local data
	if self.Type == 0 then -- Event
		if self.Parameter then
			data = string_pack("<III", 2, self.Event, self.Parameter)
		else
			data = string_pack("<II", 1, self.Event)
		end
	elseif self.Type == 1 then -- Script
		local len = #self.Key
		len = len + 4 - (len & 3)
		data = string_pack("<Ic" .. len, len / 4, self.Key)
	elseif self.Type == 2 then -- Generic
		data = string_pack("<I", 0)
	elseif self.Type == 3 then -- Car Start
		if self.FreeCar then
			local len = #self.FreeCar
			len = len + 4 - (len & 3)
			data = string_pack("<IfIc" .. len, 2 + len / 4, self.Rotation, self.ParkedCar, self.FreeCar)
		elseif self.ParkedCar then
			data = string_pack("<IfI", 2, self.Rotation, self.ParkedCar)
		else
			data = string_pack("<If", 1, self.Rotation)
		end
	elseif self.Type == 4 then -- Spline
		data = string_pack("<I", 0)
	elseif self.Type == 5 then -- Dynamic Zone
		local len = #self.DynaLoadData
		len = len + 4 - (len & 3)
		data = string_pack("<Ic" .. len, len / 4, self.DynaLoadData)
	elseif self.Type == 6 then -- Occlusion
		if self.Occlusions then
			data = string_pack("<II", 1, self.Occlusions)
		else
			data = string_pack("<I", 0)
		end
	elseif self.Type == 7 then -- Interior Entrance
		local len = #self.InteriorName
		len = len + 4 - (len & 3)
		data = string_pack("<Ic" .. len .. "fffffffff", 9 + len / 4, self.InteriorName, self.Right.X, self.Right.Y, self.Right.Z, self.Up.X, self.Up.Y, self.Up.Z, self.Front.X, self.Front.Y, self.Front.Z)
	elseif self.Type == 8 then -- Directional
		data = string_pack("<Ifffffffff", 9, self.Right.X, self.Right.Y, self.Right.Z, self.Up.X, self.Up.Y, self.Up.Z, self.Front.X, self.Front.Y, self.Front.Z)
	elseif self.Type == 9 then -- Action
		local objectNameLen = #self.ObjectName
		objectNameLen = objectNameLen + 4 - (objectNameLen & 3)
		local jointNameLen = #self.JointName
		jointNameLen = jointNameLen + 4 - (jointNameLen & 3)
		local actionNameLen = #self.ActionName
		actionNameLen = actionNameLen + 4 - (actionNameLen & 3)
		data = string_pack("<Ic" .. objectNameLen .. "c" .. jointNameLen .. "c" .. actionNameLen .. "II", objectNameLen / 4 + jointNameLen / 4 + actionNameLen / 4 + 2, self.ObjectName, self.JointName, self.ActionName, self.ButtonInput, self.ShouldTransform)
	elseif self.Type == 10 then -- FOV
		data = string_pack("<Ifff", 3, self.FOV, self.Time, self.Rate)
	elseif self.Type == 11 then -- Breakable Camera
		data = string_pack("<I", 0)
	elseif self.Type == 12 then -- Static Camera
		if self.CutInOut and self.Data then
			data = string_pack("<IfffffIfIII", 10, self.TargetPosition.X, self.TargetPosition.Y, self.TargetPosition.Z, self.FOV, self.TargetLag, self.FollowPlayer, self.TransitionTargetRate, self.Flags, self.CutInOut, self.Data)
		elseif self.Flags then
			data = string_pack("<IfffffIfI", 8, self.TargetPosition.X, self.TargetPosition.Y, self.TargetPosition.Z, self.FOV, self.TargetLag, self.FollowPlayer, self.TransitionTargetRate, self.Flags)
		elseif self.TransitionTargetRate then
			data = string_pack("<IfffffIf", 7, self.TargetPosition.X, self.TargetPosition.Y, self.TargetPosition.Z, self.FOV, self.TargetLag, self.FollowPlayer, self.TransitionTargetRate)
		else
			data = string_pack("<IfffffI", 6, self.TargetPosition.X, self.TargetPosition.Y, self.TargetPosition.Z, self.FOV, self.TargetLag, self.FollowPlayer)
		end
	elseif self.Type == 13 then -- Ped Group
		data = string_pack("<II", 1, self.GroupNum)
	elseif self.Type == 14 then -- Coin
		data = string_pack("<I", 0)
	else
		local dataLen = #self.Data
		data = string_pack("<Ic" .. dataLen, dataLen / 4, self.Data)
	end
	headerLen = headerLen + #data
	return string_pack("<IIIs1Ic" .. #data .. "fffI", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Type, data, self.Position.X, self.Position.Y, self.Position.Z, self:getTriggerCount()) .. chunkData
end