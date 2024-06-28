local math_random = math.random
local string_sub = string.sub

local RandomMissionCharacters = Module("Random Mission Characters", "RandomMissionCharacters")

local BonusCharacters
local BonusCharactersN

local MissionCharacters

local function ReplaceBonusCharacter(Path, P3DFile)
	local ReplaceP3D = P3D.P3DFile(BonusCharacters[Path])
	
	return P3DUtils.ReplaceCharacter(P3DFile, ReplaceP3D)
end

local function ReplaceMissionCharacter(Path, P3DFile)
	local ReplaceP3D = P3D.P3DFile(MissionCharacters[Path])
	
	return P3DUtils.ReplaceCharacter(P3DFile, ReplaceP3D)
end

RandomMissionCharacters:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	RandomMissionCharacters.Handlers.P3D = {}
	BonusCharacters = {}
	BonusCharactersN = 0
	for i=1,#LevelInit.Functions do
		local func = LevelInit.Functions[i]
		local name = func.Name:lower()
		if name == "addnpccharacterbonusmission" then
			local char = func.Arguments[1]
			if #char > 6 then
				char = string_sub(char, 1, 6)
			end
			BonusCharactersN = BonusCharactersN + 1
			local path = "art\\chars\\" .. char .. "_m.p3d"
			BonusCharacters[path] = CharP3DFiles[math_random(CharCount)]
			print("Replacing bonus mission character \"" .. char .. "\" with: " .. BonusCharacters[path])
			RandomMissionCharacters:AddP3DHandler(path, ReplaceBonusCharacter)
		end
	end
	return false
end)

local function HandleMission(LevelNumber, MissionNumber, MissionLoad, MissionInit)
	local handlers = RandomMissionCharacters.Handlers.P3D
	for i=BonusCharactersN+1,#handlers do
		handlers[i] = nil
	end
	MissionCharacters = {}
	for i=1,#MissionInit.Functions do
		local func = MissionInit.Functions[i]
		local name = func.Name:lower()
		if name == "addnpc" then
			local char = func.Arguments[1]
			if #char > 6 then
				char = string_sub(char, 1, 6)
			end
			local path = "art\\chars\\" .. char .. "_m.p3d"
			MissionCharacters[path] = CharP3DFiles[math_random(CharCount)]
			print("Replacing mission character \"" .. char .. "\" with: " .. MissionCharacters[path])
			RandomMissionCharacters:AddP3DHandler(path, ReplaceMissionCharacter)
		end
	end
	return false
end

RandomMissionCharacters:AddSundayDriveHandler(HandleMission)
RandomMissionCharacters:AddMissionHandler(HandleMission)

return RandomMissionCharacters