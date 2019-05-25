-- Load the file
local Path = "/GameData/" .. GetPath()
local File = nil

if SettingCustomCars then
	local carName = Path:match("[\\/]cars[\\/](.-)%.con")
	for i = 1, #CustomCarPool do
		if CustomCarPool[i]:lower() == carName:lower() then
			File = ReadFile("/GameData/CustomCars/" .. CustomCarPool[i] .. "/" .. CustomCarPool[i] .. ".con")
			break
		end
	end
	if File == nil then
		File = ReadFile(Path)
	end
else
	File = ReadFile(Path)
end

local function randomStats(data)
	local mass = round(math.random() + math.random(MinMass, MaxMass), 2)
	local gasScale = round(math.random() + math.random(MinGas, MaxGas), 2)
	local slipGasScale = round(gasScale + math.random() + math.random(MinSlipGas, MaxSlipGas), 2)
	local breakGasScale = round(math.random() + math.random(MinBreakGasScale, MaxBreakGasScale), 2)
	local topSpeedKmh = round(math.random() + math.random(MinSpeed, MaxSpeed), 2)
	local maxWheelTurnAngle = round(math.random() + math.random(MinTurnAngle, MaxTurnAngle), 2)
	local highSpeedSteeringDrop = round(math.random(), 2)
	local tireGrip = round(math.random() + math.random(MinGrip, MaxGrip), 2)
	local normalSteering = round(math.random() + math.random(MinSteering, MaxSteering), 2)
	local slipSteering = round(math.random() + math.random(MinSlipSteering, MaxSlipSteering), 2)
	local eBrakeEffect = round(math.random() , 2)
	local slipSteeringNoEBreak = round(math.random() + math.random(20, 30), 2)
	local slipEffectNoEBreak = round(math.random(), 2)
	local hitPoints = round(math.random() + math.random(MinHP, MaxHP), 2)
	local burnoutRange = round(math.random() / 2, 2)
	local maxSpeedBurstTime = round(math.random() + math.random(1, 5), 2)
	local donutTorque = round(math.random() + math.random(1, 20), 2)
	
	
	if SettingRandomPlayerVehicles and RandomCarName and Path:match(RandomCarName) then
		-- Takes the stats that were assigned to the player vehicle when the mission is originally loaded.
		if PlayerStats == nil then
			PlayerStats = {}
			PlayerStats["HP"] = hitPoints
			PlayerStats["SlipSteering"] = slipSteering
			PlayerStats["Grip"] = tireGrip
			PlayerStats["TurnAngle"] = maxWheelTurnAngle
			PlayerStats["Speed"] = topSpeedKmh
			PlayerStats["BreakGasScale"] = breakGasScale
			PlayerStats["SlipGas"] = slipGasScale
			PlayerStats["Gas"] = gasScale
		else
		-- Applies the same stats that were assigned in the first instance.
			hitPoints = PlayerStats["HP"]
			slipSteering = PlayerStats["SlipSteering"]
			tireGrip = PlayerStats["Grip"]
			maxWheelTurnAngle = PlayerStats["TurnAngle"]
			topSpeedKmh = PlayerStats["Speed"]
			breakGasScale = PlayerStats["BreakGasScale"]
			slipGasScale = PlayerStats["SlipGas"]
			gasScale = PlayerStats["Gas"]
		end
	end
	
	
	data = string.gsub(data, "SetMass%(.-%);", "SetMass(" .. mass .. ");", 1)
	data = string.gsub(data, "SetGasScale%(.-%);", "SetGasScale(" .. gasScale .. ");", 1)
	data = string.gsub(data, "SetSlipGasScale%(.-%);", "SetSlipGasScale(" .. slipGasScale .. ");", 1)
	data = string.gsub(data, "SetBrakeScale%(.-%);", "SetBrakeScale(" .. breakGasScale .. ");", 1)
	data = string.gsub(data, "SetTopSpeedKmh%(.-%);", "SetTopSpeedKmh(" .. topSpeedKmh .. ");", 1)
	data = string.gsub(data, "SetMaxWheelTurnAngle%(.-%);", "SetMaxWheelTurnAngle(" .. maxWheelTurnAngle .. ");", 1)
	data = string.gsub(data, "SetHighSpeedSteeringDrop%(.-%);", "SetHighSpeedSteeringDrop(" .. highSpeedSteeringDrop .. ");", 1)
	data = string.gsub(data, "SetTireGrip%(.-%);", "SetTireGrip(" .. tireGrip .. ");", 1)
	data = string.gsub(data, "SetNormalSteering%(.-%);", "SetNormalSteering(" .. normalSteering .. ");", 1)
	data = string.gsub(data, "SetSlipSteering%(.-%);", "SetSlipSteering(" .. slipSteering .. ");", 1)
	data = string.gsub(data, "SetEBrakeEffect%(.-%);", "SetEBrakeEffect(" .. eBrakeEffect .. ");", 1)
	data = string.gsub(data, "SetSlipSteeringNoEBrake%(.-%);", "SetSlipSteeringNoEBrake(" .. slipSteeringNoEBreak .. ");", 1)
	data = string.gsub(data, "SetSlipEffectNoEBrake%(.-%);", "SetSlipEffectNoEBrake(" .. slipEffectNoEBreak .. ");", 1)
	data = string.gsub(data, "SetHitPoints%(.-%);", "SetHitPoints(" .. hitPoints .. ");", 1)
	data = string.gsub(data, "SetBurnoutRange%(.-%);", "SetBurnoutRange(" .. burnoutRange .. ");", 1)
	data = string.gsub(data, "SetMaxSpeedBurstTime%(.-%);", "SetMaxSpeedBurstTime(" .. maxSpeedBurstTime .. ");", 1)
	data = string.gsub(data, "SetDonutTorque%(.-%);", "SetDonutTorque(" .. donutTorque .. ");", 1)
	return data 
end

-- Fix Audi TT Missing some entries
if string.match(Path, "tt%.con") then
	File = File .. [[SetCharactersVisible(1);
			SetDriver("none");
			SetHasDoors(0);
			SetIrisTransition(1);]]
end

-- Only update the randomly spawned car
if SettingRandomPlayerVehicles and RandomCarName and string.match(Path, RandomCarName) then

	if SettingRandomStats and RandomCarName ~= "huskA" then	
		File = randomStats(File)
	elseif SettingBoostHP then
		HP = string.match(File, "SetHitPoints%((.-)%);")
		if HP and tonumber(HP) < 0.8 then
			File = string.gsub(File, "SetHitPoints%(.-%);", "SetHitPoints(0.8);", 1)
			DebugPrint("Boosting HP up from " .. HP .. " to 0.8 for " .. Path)
		end
	end
end

if SettingRandomMissionVehicles and MissionVehicles then
	for k,v in pairs(MissionVehicles) do
		if string.match(Path, v) then
			if SettingRandomStats then
				File = randomStats(File)
			else
				HP = string.match(File, "SetHitPoints%((.-)%);")
				if HP and tonumber(HP) < 0.6 then
					File = string.gsub(File, "SetHitPoints%(.-%);", "SetHitPoints(0.6);", 1)
					DebugPrint("Boosting HP up from " .. HP .. " to 0.6 for " .. Path)
				end
				if HP and tonumber(HP) > 15 then
					File = string.gsub(File, "SetHitPoints%(.-%);", "SetHitPoints(0.6);", 1)
					DebugPrint("Capping HP from " .. HP .. " to 15 for " .. Path)
				end
			end
		end
	end
end

if SettingRandomStats and SettingRandomTraffic and TrafficCars and #TrafficCars > 0 then
	for i = 1, #TrafficCars do
		if string.match(Path, TrafficCars[i]) then
			File = randomStats(File)
			break
		end
	end
end

if SettingRandomPedestrians then
	local driverName = GetRandomFromTbl(RandomPedPool, false)
		if string.match(File, "SetCharactersVisible%(%s*1%s*%);") then
		File = string.gsub(File, "SetDriver%(%s*\"(.-)\"%s*%);", function(orig)
			if SettingRandomTraffic and TrafficCars and #TrafficCars > 0 then
				for i = 1, #TrafficCars do
					if string.match(Path, TrafficCars[i]) then
						DebugPrint("Setting driver for traffic car " .. TrafficCars[i])
						return "SetDriver(\"" .. driverName .. "\");"
					end
				end
			end
			if orig == "none" then
				return "SetDriver(\"" .. orig .. "\");"
			else
				return "SetDriver(\"" .. driverName .. "\");"
			end
		end)
	end
end

if SettingRandomCarScale and not string.match(Path, "huskA") then
	local mins = math.log(MinCarScale)
	local range = math.log(MaxCarScale) - mins
	local scale = round(math.exp(math.random() * range + mins), 2)
	
	if string.match(File, "SetCharacterScale%(") then
		File = string.gsub(File, "SetCharacterScale%(%s*.-%s*%);", "SetCharacterScale(" .. scale .. ");")
	else
		File = File .. "\r\n\r\nSetCharacterScale(" .. scale .. ");"
	end
end


Output(File)
