local Path = GetPath()
local FileName = RemoveFileExtension(GetFileName(Path))

if Exists("/GameData/" .. Path, true, false) then
	if Settings.RandomCharacter and OrigChar and (Path:match("art/chars/" .. OrigChar .. "_m%.p3d") or Path:match("art/chars/" .. OrigChar:sub(1,1) .. "_.-_m%.p3d")) then
		local Original = ReadFile("/GameData/" .. Path)
		local ReplacePath = GetRandomFromTbl(RandomCharP3DPool, false)
		if Settings.UseDebugSettings and Exists("/GameData/RandomiserSettings/PlayerCharacter.txt", true, false) then
			local staticName = ReadFile("/GameData/RandomiserSettings/PlayerCharacter.txt")
			if staticName:len() > 0 then
				ReplacePath = staticName
			end
		end
		local Replace = ReadFile(ReplacePath)
		
		DebugPrint("Replacing \"" .. Path .. "\" with \"" .. ReplacePath .. "\"")
		Original = ReplaceCharacterSkinSkel(Original, Replace)
		
		Output(Original)
	else
		local updated = false
		if Settings.RandomMissionCharacters then
			if MissionCharacters and updated ~= true then
				for i = 1, #MissionCharacters do
					local model = MissionCharacters[i]
					if model:len() > 6 then
						model = model:sub(1, 6)
					end
					if Path:match("art/chars/" .. model .. "_m%.p3d") then
						local Original = ReadFile("/GameData/" .. Path)
						local ReplacePath = GetRandomFromTbl(RandomCharP3DPool, false)
						if Settings.UseDebugSettings and Exists("/GameData/RandomiserSettings/MissionCharacter.txt", true, false) then
							local staticName = ReadFile("/GameData/RandomiserSettings/MissionCharacter.txt")
							if staticName:len() > 0 then
								ReplacePath = staticName
							end
						end
						local Replace = ReadFile(ReplacePath)
						
						DebugPrint("Replacing \"" .. Path .. "\" with \"" .. ReplacePath .. "\"")
						Original = ReplaceCharacterSkinSkel(Original, Replace)
						
						Output(Original)
						updated = true
						break
					end
				end
			end
			if BonusCharacters and updated ~= true then
				for i = 1, #BonusCharacters do
					local model = BonusCharacters[i]
					if model:len() > 6 then
						model = model:sub(1, 6)
					end
					if Path:match("art/chars/" .. model .. "_m%.p3d") then
						local Original = ReadFile("/GameData/" .. Path)
						local ReplacePath = GetRandomFromTbl(RandomCharP3DPool, false)
						if Settings.UseDebugSettings and Exists("/GameData/RandomiserSettings/MissionCharacter.txt", true, false) then
							local staticName = ReadFile("/GameData/RandomiserSettings/MissionCharacter.txt")
							if staticName:len() > 0 then
								ReplacePath = staticName
							end
						end
						local Replace = ReadFile(ReplacePath)
						
						DebugPrint("Replacing \"" .. Path .. "\" with \"" .. ReplacePath .. "\"")
						Original = ReplaceCharacterSkinSkel(Original, Replace)
						
						Output(Original)
						updated = true
						break
					end
				end
			end
		end
		if Settings.RandomPedestrians then
			if LevelPedestrians and updated ~= true then
				for i = 1, #LevelPedestrians do
					local model = LevelPedestrians[i]
					if Path:match("art/chars/" .. model .. "%.p3d") then
						local Original = ReadFile("/GameData/" .. Path)
						local P3DFile = P3D.P3DChunk:new{Raw = Original}
						local Shaders = nil
						for idx, id in P3DFile:GetChunkIndexes(P3D.Identifiers.Shader) do
							local ShaderChunk = P3D.ShaderP3DChunk:new{Raw = P3DFile:GetChunkAtIndex(idx)}
							if P3D.CleanP3DString(ShaderChunk:GetTextureParameter("TEX")) == "char_swatches_lit.bmp" then
								Shaders = Shaders or {}
								Shaders[P3D.CleanP3DString(ShaderChunk.Name)] = true
								ShaderChunk.Name = "new_swatches"
								P3DFile:SetChunkAtIndex(idx, ShaderChunk:Output())
								break
							end
						end
						if Shaders then
							for idx in P3DFile:GetChunkIndexes(P3D.Identifiers.Skin) do
								local SkinChunk = P3D.SkinP3DChunk:new{Raw = P3DFile:GetChunkAtIndex(idx)}
								for opgIdx in SkinChunk:GetChunkIndexes(P3D.Identifiers.Old_Primitive_Group) do
									local opg = P3D.OldPrimitiveGroupP3DChunk:new{Raw = SkinChunk:GetChunkAtIndex(opgIdx)}
									if Shaders[P3D.CleanP3DString(opg.ShaderName)] then
										opg.ShaderName = "new_swatches"
										SkinChunk:SetChunkAtIndex(opgIdx, opg:Output())
									end
								end
								P3DFile:SetChunkAtIndex(idx, SkinChunk:Output())
							end
							Output(P3DFile:Output())
							updated = true						
						end
						break
					end
				end
			end
			if LevelCharacters and updated ~= true then
				for i = 1, #LevelCharacters do
					local model = LevelCharacters[i]
					if model:len() > 6 then
						model = model:sub(1, 6)
					end
					if Path:match("art/chars/" .. model .. "_m%.p3d") then
						local Original = ReadFile("/GameData/" .. Path)
						local ReplacePath = GetRandomFromTbl(RandomCharP3DPool, false)
						if Settings.UseDebugSettings and Exists("/GameData/RandomiserSettings/LevelCharacter.txt", true, false) then
							local staticName = ReadFile("/GameData/RandomiserSettings/LevelCharacter.txt")
							if staticName:len() > 0 then
								ReplacePath = staticName
							end
						end
						local Replace = ReadFile(ReplacePath)
						
						DebugPrint("Replacing \"" .. Path .. "\" with \"" .. ReplacePath .. "\"")
						Original = ReplaceCharacterSkinSkel(Original, Replace)
						
						Output(Original)
						updated = true
						break
					end
				end
			end
		end
	end
elseif Settings.RandomPedestrians and Settings.CustomChars and (ExistsInTbl(LevelPedestrians, FileName) or ExistsInTbl(MissionDrivers, FileName)) and CustomChars[FileName] then
	Output(ReadFile(CustomChars[FileName]))
end
