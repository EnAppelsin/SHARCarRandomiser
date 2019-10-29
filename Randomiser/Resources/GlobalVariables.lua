TEXTURE_CHUNK = "\000\144\001\000"
SHADER_CHUNK = "\000\016\001\000"
ANIMATION_CHUNK = "\000\016\018\000"
ANIMATION_GROUP_CHUNK = "\002\016\018\000"
SKIN_CHUNK = "\001\000\001\000"
SKELETON_CHUNK = "\000\069\000\000"
MESH_CHUNK = "\000\000\001\000"
COMP_DRAW_CHUNK = "\018\069\000\000"
COMP_DRAW_SKIN_LIST_SUBCHUNK = "\019\069\000\000"
COMP_DRAW_PROP_LIST_SUBCHUNK = "\020\069\000\000"
COMP_DRAW_SKIN_SUBCHUNK = "\021\069\000\000"
OLD_FRAME_CONTROLLER_CHUNK = "\000\018\018\000"
SPRITE_CHUNK = "\005\144\001\000"
IMAGE_CHUNK = "\001\144\001\000"
IMAGE_DATA_CHUNK = "\002\144\001\000"
CAR_CAMERA_DATA_CHUNK = "\000\001\000\003"
MOTION_ROOT_LABEL = "Motion_Root\000"
TEXT_BIBLE_CHUNK = "\x0D\x80\x01\x00"
LANGUAGE_CHUNK = "\x0E\x80\x01\x00"
COLLISION_OBJECT_CHUNK = "\000\000\001\007"
PHYSICS_OBJECT_CHUNK = "\000\016\001\007"
LOCATOR_CHUNK = "\005\000\000\003"
WALL_COLLISION_CONTAINER_CHUNK = "\007\000\240\003"
STATIC_MESH_COLLISION_CHUNK = "\001\000\240\003"
STATIC_WORLD_MESH_CHUNK = "\000\000\240\003"
OLD_PRIMITIVE_GROUP_CHUNK = "\002\000\001\000"
COLOUR_LIST_CHUNK = "\008\000\001\000"


ModVersion = GetModVersion()

OrigChar = nil
RandomChar = nil
RandomCar = nil
RandomCarName = nil
LastLevel = nil
LastLevelMV = nil
RandomChase = nil
RemovedTrafficCars = {}
TrafficCars = {}
MissionVehicles = {}
LevelCharacters = {}
BonusCharacters = {}
MissionCharacters = {}

-- Count number of random cars
RandomCarPoolN = #RandomCarPool
RandomPedPoolN = #RandomPedPool
RandomDialoguePoolN = 0

cartunespt = ReadFile(Paths.Resources .. "car_tune.spt"):gsub("\r\n", "\n"):gsub("\r", "\n"):gsub("\n", "\r\n")
carsoundspt = ReadFile(Paths.Resources .. "carsound.spt"):gsub("\r\n", "\n"):gsub("\r", "\n"):gsub("\n", "\r\n")
dialogspt = ReadFile(Paths.Resources .. "dialog.spt"):gsub("\r\n", "\n"):gsub("\r", "\n"):gsub("\n", "\r\n")

--[[SettingRandomCouch = GetSetting("RandomCouch")
SettingRandomMusic = GetSetting("RandomMusic")
SettingRandomMusicCues = GetSetting("RandomMusicCues")
SettingRandomDialogue = GetSetting("RandomDialogue")
SettingRandomCharacter = GetSetting("RandomCharacter")
SettingRandomMissionCharacters = GetSetting("RandomMissionCharacters")
SettingRandomPlayerVehicles = GetSetting("RandomPlayerVehicles")
SettingSaveChoice = GetSetting("SaveChoice")
SettingRandomCarScale = GetSetting("RandomCarScale")
SettingRandomCarSounds = GetSetting("RandomCarSounds")
SettingCustomCars = GetSetting("CustomCars")
SettingRandomPedestrians = GetSetting("RandomPedestrians")
SettingRandomTraffic = GetSetting("RandomTraffic")
SettingRandomChase = GetSetting("RandomChase")
SettingRandomChaseAmount = GetSetting("RandomChaseAmount")
SettingRandomChaseStats = GetSetting("RandomChaseStats")
SettingRandomMissionVehicles = GetSetting("RandomMissionVehicles")
SettingRandomMissionVehiclesStats = GetSetting("RandomMissionVehiclesStats")
SettingDifferentCellouts = GetSetting("DifferentCellouts")
SettingSaveChoiceMV = GetSetting("SaveChoiceMV")
SettingRandomStats = GetSetting("RandomStats")
SettingSkipLocks = GetSetting("SkipLocks")
SettingSkipFMVs = GetSetting("SkipFMVs")
SettingBoostHP = GetSetting("BoostHP")
SettingDebugLevel = GetSetting("DebugLevel")

--Chaos settings
SettingRandomInteriors = GetSetting("RandomInteriors")
SettingRandomDirectives = GetSetting("RandomDirectives")
SettingRandomMissions = GetSetting("RandomMissions")
SettingRandomItems = GetSetting("RandomItems")]]--

--Random Stat Min/Max Variables
if Settings.RandomStats then
--Mass Variables
	MinMass = Settings.StatMinMass
	MaxMass = Settings.StatMaxMass
	if MaxMass < MinMass then
		MaxMass = MinMass
	end
--Gas Scale Variables
	MinGas = Settings.StatMinGas
	MaxGas = Settings.StatMaxGas
	if MaxGas < MinGas then
		MaxGas = MinGas
	end
--Slip Gas Scale Variables
	MinSlipGas = Settings.StatMinSlipGasScale
	MaxSlipGas = Settings.StatMaxSlipGasScale
	if MaxSlipGas < MinSlipGas then
		MaxSlipGas = MinSlipGas
	end
-- Break Gas Scale Variables
	MinBreakGasScale = Settings.StatMinBreakGasScale
	MaxBreakGasScale = Settings.StatMaxBreakGasScale
	if MaxBreakGasScale < MinBreakGasScale then
		MaxBreakGasScale = MinBreakGasScale
	end
-- Top Speed Variables
	MinSpeed = Settings.StatMinSpeed
	MaxSpeed = Settings.StatMaxSpeed
	if MaxSpeed < MinSpeed then
		MaxSpeed = MinSpeed
	end
-- Wheel Turn Angle
	MinTurnAngle = Settings.StatMinAngle
	MaxTurnAngle = Settings.StatMaxAngle
	if MaxTurnAngle < MinTurnAngle then
		MaxTurnAngle = MinTurnAngle
	end
-- Wheel Grip Variables
	MinGrip = Settings.StatMinGrip
	MaxGrip = Settings.StatMaxGrip
	if MaxGrip < MinGrip then
		MaxGrip = MinGrip
	end
-- Steering Variables
	MinSteering = Settings.StatMinSteering
	MaxSteering = Settings.StatMaxSteering
	if MaxSteering < MinSteering then
		MaxSteering = MinSteering
	end
-- SlipSteering Variables
	MinSlipSteering = Settings.StatMinSlipSteering
	MaxSlipSteering = Settings.StatMaxSlipSteering
	if MaxSlipSteering < MinSlipSteering then
		MaxSlipSteering = MinSlipSteering
	end
-- HP Variables
	MinHP = Settings.StatMinHP
	MaxHP = Settings.StatMaxHP
	if MaxHP < MinHP then
		MaxHP = MinHP
	end
end

if Settings.RandomCarScale then
	-- Random Car Scale
	MinCarScale = Settings.StatMinScale
	MaxCarScale = Settings.StatMaxScale
	if MaxCarScale < MinCarScale then
		MaxCarScale = MinCarScale
	end
end
