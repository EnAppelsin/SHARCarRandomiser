ModName = GetModName()
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
RandomDialoguePoolN = 0
RCFDialoguePoolN = 0

cartunespt = ReadFile("/GameData/sound/scripts/car_tune.spt"):gsub("SetEngineClipName %( \"tt\" %)", "SetEngineClipName ( \"snake_car\" )"):gsub("SetEngineIdleClipName %( \"tt\" %)", "SetEngineIdleClipName ( \"snake_car\" )"):gsub("\r\n    SetOverlayClipName %( \"\" %)", ""):gsub("\r\n    SetOverlayClipName %( \"generator\" %)", "")
carsoundspt = ReadFile("/GameData/sound/scripts/carsound.spt")

--Random Stat Min/Max Variables
if Settings.RandomStats then
	if Settings.SpeedrunMode then
		--TODO: Change to GetSettingDefault if added
		MinMass = 800
		MaxMass = 4000
		MinGas = 3
		MaxGas = 11
		MinSlipGas = 0
		MaxSlipGas = 1
		MinBreakGasScale = 1
		MaxBreakGasScale = 10
		MinSpeed = 110
		MaxSpeed = 200
		MinTurnAngle = 15
		MaxTurnAngle = 35
		MinGrip = 3
		MaxGrip = 35
		MinSteering = 90
		MaxSteering = 100
		MinSlipSteering = 20
		MaxSlipSteering = 40
		MinHP = 0
		MaxHP = 10
	else
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
end

if Settings.RandomCarScale then
	-- Random Car Scale
	MinCarScale = Settings.StatMinScale
	MaxCarScale = Settings.StatMaxScale
	if MaxCarScale < MinCarScale then
		MaxCarScale = MinCarScale
	end
end
