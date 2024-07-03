local math_random = math.random
local table_remove = table.remove
local table_unpack = table.unpack

local RandomBonusVehicles = Module("Random Bonus Vehicles", "RandomBonusVehicles", 1)

local CarNames = {table_unpack(CarNames)}
local CarP3DFiles = {table_unpack(CarP3DFiles)}
for i=CarCount,1,-1 do
	if not Settings[CarNames[i] .. "Player"] then
		table_remove(CarNames, i)
		table_remove(CarP3DFiles, i)
	end
end
local CarCount = #CarNames

if CarCount < 5 and Settings[RandomBonusVehicles.Setting] then
	Alert("You must have at least 5 vehicle selected for the random player pool.")
	os.exit()
end

local BonusVehicleP3D
local BonusVehicleCON

local function ReplaceCar(Path, P3DFile)
	for i=3,#RandomBonusVehicles.Handlers.P3D do
		RandomBonusVehicles.Handlers.P3D[i] = nil
	end
	
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

RandomBonusVehicles:AddLevelHandler(function()
	for i=3,#RandomBonusVehicles.Handlers.P3D do
		RandomBonusVehicles.Handlers.P3D[i] = nil
	end
	RandomBonusVehicles.Handlers.CON = {}
	
	return false
end)

return RandomBonusVehicles