local math_random = math.random
local string_gsub = string.gsub
local string_match = string.match
local table_concat = table.concat
local tonumber = tonumber

local RandomMissionOrder = Module("Random Mission Order", "RandomMissionOrder", 3)

local MissionOrder = {}

if Settings[RandomMissionOrder.Setting] then
	for level=1,7 do
		MissionOrder[level] = {1, 2, 3, 4, 5, 6, 7}
		ShuffleTable(MissionOrder[level])
	end
	print("Random mission order:")
	for level=1,7 do
		print("", "Level " .. level .. ":", table_concat(MissionOrder[level], ", "))
	end
end

RandomMissionOrder:AddP3DHandler("art/frontend/scrooby/resource/txtbible/srr2.p3d", function(Path, P3DFile)
	local FrontendTextBible = P3DFile:GetChunk(P3D.Identifiers.Frontend_Text_Bible)
	if not FrontendTextBible then
		return false
	end
	
	for FrontendLanguage in FrontendTextBible:GetChunks(P3D.Identifiers.Frontend_Language) do
		for level=1,7 do
			local MissionTitles = {}
			for mission=1,7 do
				MissionTitles[mission] = FrontendLanguage:GetValueFromName("MISSION_TITLE_L" .. level .. "_M" .. mission)
			end
			
			for mission=1,7 do
				FrontendLanguage:SetValue("MISSION_TITLE_L" .. level .. "_M" .. mission, MissionTitles[MissionOrder[level][mission]])
			end
		end
	end
	
	return true
end)

RandomMissionOrder:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	local functions = LevelLoad.Functions
	for i=1,#functions do
		local func = functions[i]
		if func.Name:lower() == "addmission" then
			local MissionNumber = tonumber(string_match(func.Arguments[1], "m(%d)"))
			if MissionOrder[LevelNumber][MissionNumber] then
				func.Arguments[1] = "m" .. MissionOrder[LevelNumber][MissionNumber]
			end
		end
	end
	
	return true
end)

RandomMissionOrder:AddSPTHandler("sound/scripts/dialog*.spt", function(Path, SPT)
	for daSoundResourceData in SPT:GetClasses("daSoundResourceData") do
		if string_match(daSoundResourceData.Name, "L(%d)M%d$") then
			daSoundResourceData.Name = string_gsub(daSoundResourceData.Name, "L(%d)M%d$", "L%1")
			for AddFilename in daSoundResourceData:GetMethods(nil, "AddFilename") do
				local oldFilename = AddFilename.Parameters[1]
				local newFilename = string_gsub(oldFilename, "L(%d)M%d%.([^.]+)$", "L%1.%2")
				RandomMissionOrder:AddGenericHandler(newFilename, function(Path, Contents)
					print("Redirecting \"" .. Path .. "\" to: " .. oldFilename)
					return true, ReadFile(GetGamePath(oldFilename))
				end)
				AddFilename.Parameters[1] = newFilename
			end
		end
	end
	
	return true
end)

return RandomMissionOrder