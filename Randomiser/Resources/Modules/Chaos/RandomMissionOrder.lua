local math_random = math.random
local string_match = string.match
local table_concat = table.concat
local table_remove = table.remove
local tonumber = tonumber

local RandomMissionOrder = Module("Random Mission Order", "RandomMissionOrder")

local MissionOrder = {}

if Settings[RandomMissionOrder.Setting] then
	for level=1,7 do
		MissionOrder[level] = {}
		
		local Missions = {1, 2, 3, 4, 5, 6, 7}
		for mission=1,7 do
			local index = math_random(#Missions)
			MissionOrder[level][mission] = Missions[index]
			table_remove(Missions, index)
		end
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

return RandomMissionOrder