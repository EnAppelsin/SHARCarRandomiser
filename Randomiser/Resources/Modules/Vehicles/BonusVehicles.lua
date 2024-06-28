local math_random = math.random
local string_sub = string.sub

local RandomBonusVehicles = Module("Random Bonus Vehicles", "RandomBonusVehicles", 1)

local BonusVehicleP3D
local BonusVehicleCON

local function ReplaceCar(Path, P3DFile)
	RandomBonusVehicles.Handlers.P3D[3] = nil
	
	local ReplaceP3D = P3D.P3DFile(BonusVehicleP3D)
	
	return P3DUtils.ReplaceCar(P3DFile, ReplaceP3D)
end

local function ReplaceCon(Path, CON)
	RandomBonusVehicles.Handlers.CON = {}
	
	local ReplaceCON = MFKLexer.Lexer:Parse(ReadFile(BonusVehicleCON))
	CON.Functions = ReplaceCON.Functions
	return true
end

local function FindBonusVehicle(Path, P3DFile)
	for chunk in P3DFile:GetChunks(P3D.Identifiers.Locator) do
		if chunk.Type == 3 and chunk.FreeCar then
			local BonusVehicleIndex = math_random(CarCount)
			BonusVehicleP3D = CarP3DFiles[BonusVehicleIndex]
			BonusVehicleCON = "/GameData/scripts/cars/" .. CarNames[BonusVehicleIndex] .. ".con"
			
			while not Exists(BonusVehicleCON, true, false) do
				BonusVehicleIndex = math_random(CarCount)
				BonusVehicleP3D = CarP3DFiles[BonusVehicleIndex]
				BonusVehicleCON = "/GameData/scripts/cars/" .. CarNames[BonusVehicleIndex] .. ".con"
			end
			
			print("Replacing bonus vehicle \"" .. chunk.FreeCar .. "\" with: " .. BonusVehicleP3D)
			
			RandomBonusVehicles:AddP3DHandler("art\\cars\\" .. chunk.FreeCar .. ".p3d", ReplaceCar)
			RandomBonusVehicles:AddCONHandler("scripts\\cars\\" .. chunk.FreeCar .. ".con", ReplaceCon)
			return false
		end
	end
	return false
end

RandomBonusVehicles:AddP3DHandler("art/l?r*.p3d", FindBonusVehicle)
RandomBonusVehicles:AddP3DHandler("art/l?z*.p3d", FindBonusVehicle)

return RandomBonusVehicles