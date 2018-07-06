local Path = GetPath()

-- Handle the couch logic separately (it's quite long)
if Path == "art\\frontend\\scrooby\\resource\\pure3d\\homer.p3d" then
	dofile(ModPath .. "/RandomCouch.lua")
elseif SettingRandomCharacter and OrigChar and Path:match("art\\chars\\" .. OrigChar .. "_m%.p3d") then
	local Original = ReadFile("GameData/" .. Path)
	local ReplacePath = "/GameData/art/chars/" .. GetRandomFromTbl(RandomCharP3DPool, false) .. ".p3d"
	local Replace = ReadFile(ReplacePath)
	
    print("Replacing \"" .. Path .. "\" with \"" .. ReplacePath .. "\"")
	Original = ReplaceCharacterSkinSkel(Original, Replace)
	
	Output(Original)
else
	if SettingRandomMissionCharacters and MissionCharacters then
		for i = 1, #MissionCharacters do
			local model = MissionCharacters[i]
			if model:len() > 6 then
				model = model:sub(1, 6)
			end
			if Path:match("art\\chars\\" .. model .. "_m%.p3d") then
				local Original = ReadFile("GameData/" .. Path)
				local ReplacePath = "/GameData/art/chars/" .. GetRandomFromTbl(RandomCharP3DPool, false) .. ".p3d"
				local Replace = ReadFile(ReplacePath)
				
                print("Replacing \"" .. Path .. "\" with \"" .. ReplacePath .. "\"")
				Original = ReplaceCharacterSkinSkel(Original, Replace)
				
				Output(Original)
				break
			end
		end
	end
	if SettingRandomPedestrians and LevelCharacters then
		for i = 1, #LevelCharacters do
			local model = LevelCharacters[i]
			if model:len() > 6 then
				model = model:sub(1, 6)
			end
			if Path:match("art\\chars\\" .. model .. "_m%.p3d") then
				local Original = ReadFile("GameData/" .. Path)
				local ReplacePath = "/GameData/art/chars/" .. GetRandomFromTbl(RandomCharP3DPool, false) .. ".p3d"
				local Replace = ReadFile(ReplacePath)
				
                print("Replacing \"" .. Path .. "\" with \"" .. ReplacePath .. "\"")
				Original = ReplaceCharacterSkinSkel(Original, Replace)
                
				Output(Original)
				break
			end
		end
	end
end