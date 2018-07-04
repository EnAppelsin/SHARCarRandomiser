TEXTURE_CHUNK = "\000\144\001\000"
SHADER_CHUNK = "\000\016\001\000"
SKIN_CHUNK = "\001\000\001\000"
SKELETON_CHUNK = "\000\069\000\000"
COMP_DRAW_CHUNK = "\018\069\000\000"
COMP_DRAW_SKIN_SUBCHUNK = "\021\069\000\000"
COMP_DRAW_SKIN_LIST_SUBCHUNK = "\019\069\000\000"
MOTION_ROOT_LABEL = "\012Motion_Root\000"

OrigChar = nil
RandomChar = nil
RandomChars = {}
RandomCar = nil
RandomCarName = nil
LastLevel = nil
LastLevelMV = nil
RandomChase = nil
RemovedTrafficCars = {}
TrafficCars = {}
MissionVehicles = {}

dialogspt = nil
conversations = nil
dialogsptend = nil

cartunespt = nil

--Random Stat Min/Max Variables
if GetSetting("RandomStats") then
--Mass Variables
	MinMass = GetSetting("StatMinMass")
	MaxMass = GetSetting("StatMaxMass")
	if MaxMass < MinMass then
		MaxMass = MinMass
	end
--Gas Scale Variables
	MinGas = GetSetting("StatMinGas")
	MaxGas = GetSetting("StatMaxGas")
	if MaxGas < MinGas then
		MaxGass = MinGas
	end
--Slip Gas Scale Variables
	MinSlipGas = GetSetting("StatMinSlipGasScale")
	MaxSlipGas = GetSetting("StatMaxSlipGasScale")
	if MaxSlipGas < MinSlipGas then
		MaxSlipGas = MinSlipGas
	end
-- Break Gas Scale Variables
	MinBreakGasScale = GetSetting("StatMinBreakGasScale")
	MaxBreakGasScale = GetSetting("StatMaxBreakGasScale")
	if MaxBreakGasScale < MinBreakGasScale then
		MaxBreakGasScale = MinBreakGasScale
	end
-- Top Speed Variables
	MinSpeed = GetSetting("StatMinSpeed")
	MaxSpeed = GetSetting("StatMaxSpeed")
	if MaxSpeed < MinSpeed then
		MaxSpeed = MinSpeed
	end
-- Wheel Turn Angle
	MinTurnAngle = GetSetting("StatMinAngle")
	MaxTurnAngle = GetSetting("StatMaxAngle")
	if MaxTurnAngle < MinTurnAngle then
		MaxTurnAngle = MinTurnAngle
	end
-- Wheel Grip Variables
	MinGrip = GetSetting("StatMinGrip")
	MaxGrip = GetSetting("StatMaxGrip")
	if MaxGrip < MinGrip then
		MaxGrip = MinGrip
	end
-- Steering Variables
	MinSteering = GetSetting("StatMinSteering")
	MaxSteering = GetSetting("StatMaxSteering")
	if MaxSteering < MinSteering then
		MaxSteering = MinSteering
	end
-- SlipSteering Variables
	MinSlipSteering = GetSetting("StatMinSlipSteering")
	MaxSlipSteering = GetSetting("StatMaxSlipSteering")
	if MaxSlipSteering < MinSlipSteering then
		MaxSlipSteering = MinSlipSteering
	end
-- HP Variables
	MinHP = GetSetting("StatMinHP")
	MaxHP = GetSetting("StatMaxHP")
	if MaxHP < MinHP then
		MaxHP = MinHP
	end
end
