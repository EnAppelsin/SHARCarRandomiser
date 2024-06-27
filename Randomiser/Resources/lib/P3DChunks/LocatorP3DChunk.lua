--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.LocatorP3DChunk == nil, "Chunk type already loaded.")

local string_format = string.format
local string_gsub = string.gsub
local string_pack = string.pack
local string_rep = string.rep
local string_reverse = string.reverse
local string_unpack = string.unpack

local table_concat = table.concat
local table_unpack = table.unpack

local assert = assert
local tostring = tostring
local type = type

local function new(self, Name, Position, Type, ...)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Position) == "table", "Arg #2 (Position) must be a table")
	assert(type(Type) == "number", "Arg #3 (Type) must be a number")
	local args = {...}
	
	local Data = {
		Endian = "<",
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
		
		Data.Occlusions = Occlusions
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

local function ReadLocationDataString(Endian, str, pos)
	if Endian == "<" then
		local output = string_unpack("<z", str, pos)
		return output, pos + #output + 4 - (#output & 3)
	end
	
	local output = {}
	
	local part
	while true do
		part, pos = string_unpack(">c4", str, pos)
		part = string_gsub(part, "(.)(.)(.)(.)", "%4%3%2%1")
		output[#output + 1] = part
		if part:sub(-1) == "\0" then
			break
		end
	end
	
	return P3D.CleanP3DString(table_concat(output)), pos
end

P3D.LocatorP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Locator)
P3D.LocatorP3DChunk.new = new
P3D.LocatorP3DChunk.Types = {
	Event = 0,
	Script = 1,
	Generic = 2,
	CarStart = 3,
	Spline = 4,
	DynamicZone = 5,
	Occlusion = 6,
	InteriorEntrance = 7,
	Directional = 8,
	Action = 9,
	FOV = 10,
	BreakableCamera = 11,
	StaticCamera = 12,
	PedGroup = 13,
	Coin = 14,
}
P3D.LocatorP3DChunk.Events = {
	Flag = 0,
	CameraCut = 1,
	CheckPoint = 2,
	Base = 3,
	Death = 4,
	InteriorExit = 5,
	Bouncepad = 6,
	AmbientSoundCity = 7,
	AmbientSoundSeaside = 8,
	AmbientSoundSuburbs = 9,
	AmbientSoundForest = 10,
	AmbientKwikEMartRooftop = 11,
	AmbientSoundFarm = 12,
	AmbientSoundBarn = 13,
	AmbientSoundPowerplantExterior = 14,
	AmbientSoundPowerplantInterior = 15,
	AmbientSoundRiver = 16,
	AmbientSoundCityBusiness = 17,
	AmbientSoundConstruction = 18,
	AmbientSoundStadium = 19,
	AmbientSoundStadiumTunnel = 20,
	AmbientSoundExpressway = 21,
	AmbientSoundSlum = 22,
	AmbientSoundRailyard = 23,
	AmbientSoundHospital = 24,
	AmbientSoundLightCity = 25,
	AmbientSoundShipyard = 26,
	AmbientSoundQuay = 27,
	AmbientSoundLighthouse = 28,
	AmbientSoundCountryHighway = 29,
	AmbientSoundKrustylu = 30,
	AmbientSoundDam = 31,
	AmbientSoundForestHighway = 32,
	AmbientSoundRetainingWallTunnel = 33,
	AmbientSoundKrustyluExterior = 34,
	AmbientSoundDuffExterior = 35,
	AmbientSoundDuffInterior = 36,
	AmbientSoundStoneCutterTunnel = 37,
	AmbientSoundStoneCutterHall = 38,
	AmbientSoundSewers = 39,
	AmbientSoundBurnsTunnel = 40,
	AmbientSoundPPRoom1 = 41,
	AmbientSoundPPRoom2 = 42,
	AmbientSoundPPRoom3 = 43,
	AmbientSoundPPTunnel1 = 44,
	AmbientSoundPPTunnel2 = 45,
	AmbientSoundMansionInterior = 46,
	ParkedBirds = 47,
	WhackyGravity = 48,
	FarPlane = 49,
	AmbientSoundCountryNight = 50,
	AmbientSoundSuburbsNight = 51,
	AmbientSoundForestNight = 52,
	AmbientSoundHalloween1 = 53,
	AmbientSoundHalloween2 = 54,
	AmbientSoundHalloween3 = 55,
	AmbientSoundPlaceholder3 = 56,
	AmbientSoundPlaceholder4 = 57,
	AmbientSoundPlaceholder5 = 58,
	AmbientSoundPlaceholder6 = 59,
	AmbientSoundPlaceholder7 = 60,
	AmbientSoundPlaceholder8 = 61,
	AmbientSoundPlaceholder9 = 62,
	GooDamage = 63,
	CoinZone = 64,
	LightChange = 65,
	Trap = 66,
	AmbientSoundSeasideNight = 67,
	AmbientSoundLighthouseNight = 68,
	AmbientSoundBreweryNight = 69,
	AmbientSoundPlaceholder10 = 70,
	AmbientSoundPlaceholder11 = 71,
	AmbientSoundPlaceholder12 = 72,
	AmbientSoundPlaceholder13 = 73,
	AmbientSoundPlaceholder14 = 74,
	AmbientSoundPlaceholder15 = 75,
	AmbientSoundPlaceholder16 = 76,
	Special = 77,
	OcclusionZone = 78,
	CarDoor = 79,
	ActionButton = 80,
	InteriorEntrance = 81,
	GenericButtonHandlerEvent = 82,
	FountainJump = 83,
	LoadPedModelGroup = 84,
	Gag = 85,
}
function P3D.LocatorP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	local pos, dataLen
	chunk.Name, chunk.Type, dataLen, pos = string_unpack(Endian .. "s1II", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	chunk.Position = {}
	if chunk.Type == 0 then -- Event
		chunk.Event = string_unpack(Endian .. "I", chunk.ValueStr, pos)
		if dataLen == 2 then
			chunk.Parameter = string_unpack(Endian .. "I", chunk.ValueStr, pos + 4)
		end
	elseif chunk.Type == 1 then -- Script
		chunk.Key = ReadLocationDataString(Endian, chunk.ValueStr, pos)
	elseif chunk.Type == 2 then -- Generic
		-- No extra data
	elseif chunk.Type == 3 then -- Car Start
		if dataLen == 1 then
			chunk.Rotation = string_unpack(Endian .. "f", chunk.ValueStr, pos)
		elseif dataLen == 2 then
			chunk.Rotation, chunk.ParkedCar = string_unpack(Endian .. "fI", chunk.ValueStr, pos)
		else
			local pos = pos
			chunk.Rotation, chunk.ParkedCar, pos = string_unpack(Endian .. "fI", chunk.ValueStr, pos)
			chunk.FreeCar = ReadLocationDataString(Endian, chunk.ValueStr, pos)
		end
	elseif chunk.Type == 4 then -- Spline
		-- No extra data
	elseif chunk.Type == 5 then -- Dynamic Zone
		chunk.DynaLoadData = ReadLocationDataString(Endian, chunk.ValueStr, pos)
	elseif chunk.Type == 6 then -- Occlusion
		if dataLen ~= 0 then
			chunk.Occlusions = string_unpack(Endian .. "I", chunk.ValueStr, pos)
		end
	elseif chunk.Type == 7 then -- Interior Entrance
		chunk.InteriorName = ReadLocationDataString(Endian, chunk.ValueStr, pos)
		chunk.Right = {}
		chunk.Up = {}
		chunk.Front = {}
		chunk.Right.X, chunk.Right.Y, chunk.Right.Z, chunk.Up.X, chunk.Up.Y, chunk.Up.Z, chunk.Front.X, chunk.Front.Y, chunk.Front.Z = string_unpack(Endian .. "fffffffff", chunk.ValueStr, pos + #chunk.InteriorName + 4 - (#chunk.InteriorName & 3))
	elseif chunk.Type == 8 then -- Directional
		chunk.Right = {}
		chunk.Up = {}
		chunk.Front = {}
		chunk.Right.X, chunk.Right.Y, chunk.Right.Z, chunk.Up.X, chunk.Up.Y, chunk.Up.Z, chunk.Front.X, chunk.Front.Y, chunk.Front.Z = string_unpack(Endian .. "fffffffff", chunk.ValueStr, pos)
	elseif chunk.Type == 9 then -- Action
		local pos = pos
		chunk.ObjectName, pos = ReadLocationDataString(Endian, chunk.ValueStr, pos)
		chunk.JointName, pos = ReadLocationDataString(Endian, chunk.ValueStr, pos)
		chunk.ActionName, pos = ReadLocationDataString(Endian, chunk.ValueStr, pos)
		chunk.ButtonInput, chunk.ShouldTransform = string_unpack(Endian .. "II", chunk.ValueStr, pos)
	elseif chunk.Type == 10 then -- FOV
		chunk.FOV, chunk.Type, chunk.Rate = string_unpack(Endian .. "fff", chunk.ValueStr, pos)
	elseif chunk.Type == 11 then -- Breakable Camera
		-- No extra data
	elseif chunk.Type == 12 then -- Static Camera
		chunk.TargetPosition = {}
		if dataLen >= 9 then
			chunk.TargetPosition.X, chunk.TargetPosition.Y, chunk.TargetPosition.Z, chunk.FOV, chunk.TargetLag, chunk.FollowPlayer, chunk.TransitionTargetRate, chunk.Flags, chunk.CutInOut, chunk.Data = string_unpack(Endian .. "fffffIfIII", chunk.ValueStr, pos)
		elseif dataLen >= 8 then
			chunk.TargetPosition.X, chunk.TargetPosition.Y, chunk.TargetPosition.Z, chunk.FOV, chunk.TargetLag, chunk.FollowPlayer, chunk.TransitionTargetRate, chunk.Flags = string_unpack(Endian .. "fffffIfI", chunk.ValueStr, pos)
		elseif dataLen >= 7 then
			chunk.TargetPosition.X, chunk.TargetPosition.Y, chunk.TargetPosition.Z, chunk.FOV, chunk.TargetLag, chunk.FollowPlayer, chunk.TransitionTargetRate = string_unpack(Endian .. "fffffIf", chunk.ValueStr, pos)
		else
			chunk.TargetPosition.X, chunk.TargetPosition.Y, chunk.TargetPosition.Z, chunk.FOV, chunk.TargetLag, chunk.FollowPlayer = string_unpack(Endian .. "fffffI", chunk.ValueStr, pos)
		end
	elseif chunk.Type == 13 then -- Ped Group
		chunk.GroupNum = string_unpack(Endian .. "I", chunk.ValueStr, pos)
	elseif chunk.Type == 14 then -- Coin
		-- No extra data
	else
		chunk.Data = string_unpack(Endian .. "c" ..dataLen * 4, chunk.ValueStr, pos)
		if Endian == ">" then
			chunk.Data = string_gsub(chunk.Data, "(.)(.)(.)(.)", "%4%3%2%1")
		end
	end
	pos = pos + dataLen * 4
	chunk.Position.X, chunk.Position.Y, chunk.Position.Z = string_unpack(Endian .. "fff", chunk.ValueStr, pos)
	
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

local function MakeLocationDataString(str, Endian)
	if str == nil then return nil end
	local diff = #str & 3
	str = str .. string_rep("\0", 4 - diff)
	
	if Endian == ">" then
		str = string_gsub(str, "(.)(.)(.)(.)", "%4%3%2%1")
	end
	
	return str, #str
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
			data = string_pack(self.Endian .. "III", 2, self.Event, self.Parameter)
		else
			data = string_pack(self.Endian .. "II", 1, self.Event)
		end
	elseif self.Type == 1 then -- Script
		local Key, len = MakeLocationDataString(self.Key, self.Endian)
		data = string_pack(self.Endian .. "Ic" .. len, len / 4, Key)
	elseif self.Type == 2 then -- Generic
		data = string_pack(self.Endian .. "I", 0)
	elseif self.Type == 3 then -- Car Start
		if self.FreeCar then
			local FreeCar, len = MakeLocationDataString(self.FreeCar, self.Endian)
			data = string_pack(self.Endian .. "IfIc" .. len, 2 + len / 4, self.Rotation, self.ParkedCar, FreeCar)
		elseif self.ParkedCar then
			data = string_pack(self.Endian .. "IfI", 2, self.Rotation, self.ParkedCar)
		else
			data = string_pack(self.Endian .. "If", 1, self.Rotation)
		end
	elseif self.Type == 4 then -- Spline
		data = string_pack(self.Endian .. "I", 0)
	elseif self.Type == 5 then -- Dynamic Zone
		local DynaLoadData, len = MakeLocationDataString(self.DynaLoadData, self.Endian)
		data = string_pack(self.Endian .. "Ic" .. len, len / 4, DynaLoadData)
	elseif self.Type == 6 then -- Occlusion
		if self.Occlusions then
			data = string_pack(self.Endian .. "II", 1, self.Occlusions)
		else
			data = string_pack(self.Endian .. "I", 0)
		end
	elseif self.Type == 7 then -- Interior Entrance
		local InteriorName, len = MakeLocationDataString(self.InteriorName, self.Endian)
		data = string_pack(self.Endian .. "Ic" .. len .. "fffffffff", 9 + len / 4, InteriorName, self.Right.X, self.Right.Y, self.Right.Z, self.Up.X, self.Up.Y, self.Up.Z, self.Front.X, self.Front.Y, self.Front.Z)
	elseif self.Type == 8 then -- Directional
		data = string_pack(self.Endian .. "Ifffffffff", 9, self.Right.X, self.Right.Y, self.Right.Z, self.Up.X, self.Up.Y, self.Up.Z, self.Front.X, self.Front.Y, self.Front.Z)
	elseif self.Type == 9 then -- Action
		local ObjectName, objectNameLen = MakeLocationDataString(self.ObjectName, self.Endian)
		local JointName, jointNameLen = MakeLocationDataString(self.JointName, self.Endian)
		local ActionName, actionNameLen = MakeLocationDataString(self.ActionName, self.Endian)
		data = string_pack(self.Endian .. "Ic" .. objectNameLen .. "c" .. jointNameLen .. "c" .. actionNameLen .. "II", objectNameLen / 4 + jointNameLen / 4 + actionNameLen / 4 + 2, ObjectName, JointName, ActionName, self.ButtonInput, self.ShouldTransform)
	elseif self.Type == 10 then -- FOV
		data = string_pack(self.Endian .. "Ifff", 3, self.FOV, self.Time, self.Rate)
	elseif self.Type == 11 then -- Breakable Camera
		data = string_pack(self.Endian .. "I", 0)
	elseif self.Type == 12 then -- Static Camera
		if self.CutInOut and self.Data then
			data = string_pack(self.Endian .. "IfffffIfIII", 10, self.TargetPosition.X, self.TargetPosition.Y, self.TargetPosition.Z, self.FOV, self.TargetLag, self.FollowPlayer, self.TransitionTargetRate, self.Flags, self.CutInOut, self.Data)
		elseif self.Flags then
			data = string_pack(self.Endian .. "IfffffIfI", 8, self.TargetPosition.X, self.TargetPosition.Y, self.TargetPosition.Z, self.FOV, self.TargetLag, self.FollowPlayer, self.TransitionTargetRate, self.Flags)
		elseif self.TransitionTargetRate then
			data = string_pack(self.Endian .. "IfffffIf", 7, self.TargetPosition.X, self.TargetPosition.Y, self.TargetPosition.Z, self.FOV, self.TargetLag, self.FollowPlayer, self.TransitionTargetRate)
		else
			data = string_pack(self.Endian .. "IfffffI", 6, self.TargetPosition.X, self.TargetPosition.Y, self.TargetPosition.Z, self.FOV, self.TargetLag, self.FollowPlayer)
		end
	elseif self.Type == 13 then -- Ped Group
		data = string_pack(self.Endian .. "II", 1, self.GroupNum)
	elseif self.Type == 14 then -- Coin
		data = string_pack(self.Endian .. "I", 0)
	else
		local Data, len = MakeLocationDataString(self.Data, self.Endian)
		data = string_pack(self.Endian .. "Ic" .. len, len / 4, Data)
	end
	
	headerLen = headerLen + #data
	return string_pack(self.Endian .. "IIIs1Ic" .. #data .. "fffI", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Type, data, self.Position.X, self.Position.Y, self.Position.Z, self:getTriggerCount()) .. chunkData
end