local string_sub = string.sub

local RandomMissionCharacters = Module("Random Mission Characters", "RandomMissionCharacters")

local BonusCharacters

local function ReplaceCharacter(Path, P3DFile)
	return P3DUtils.ReplaceCharacter(P3DFile)
end

RandomMissionCharacters:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	RandomMissionCharacters.Handlers.P3D = {}
	BonusCharacters = 0
	for i=1,#LevelInit.Functions do
		local func = LevelInit.Functions[i]
		local name = func.Name:lower()
		if name == "addnpccharacterbonusmission" then
			local char = func.Arguments[1]
			if #char > 6 then
				char = string_sub(char, 1, 6)
			end
			RandomMissionCharacters:AddP3DHandler("art/chars/" .. char .. "_m.p3d", ReplaceCharacter)
			BonusCharacters = BonusCharacters + 1
		end
	end
	return false
end)

local function HandleMission(LevelNumber, MissionNumber, MissionLoad, MissionInit)
	local handlers = RandomMissionCharacters.Handlers.P3D
	for i=BonusCharacters+1,#handlers do
		handlers[i] = nil
	end
	for i=1,#MissionInit.Functions do
		local func = MissionInit.Functions[i]
		local name = func.Name:lower()
		if name == "addnpc" then
			local char = func.Arguments[1]
			if #char > 6 then
				char = string_sub(char, 1, 6)
			end
			RandomMissionCharacters:AddP3DHandler("art/chars/" .. char .. "_m.p3d", ReplaceCharacter)
		end
	end
	return false
end

RandomMissionCharacters:AddSundayDriveHandler(HandleMission)
RandomMissionCharacters:AddMissionHandler(HandleMission)

return RandomMissionCharacters