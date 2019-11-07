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
