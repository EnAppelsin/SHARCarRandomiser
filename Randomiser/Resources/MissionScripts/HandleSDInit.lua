-- Load the file
local Path = "/GameData/" .. GetPath();
local File = ReadFile(Path):gsub("//.-([\r\n])", "%1");

	local level = tonumber(Path:match("level0(%d)"))
	local mission = tonumber(Path:match("m(%d)sdi"))
	DebugPrint("NEW SD INIT: Level " .. level .. ", Mission " .. mission)
	if SettingRandomMissionCharacters then
		MissionCharacters = {}
		for npc in File:gmatch("AddNPC%s*%(%s*\"([^\n]-)\"") do
			table.insert(MissionCharacters, npc)
		end
	end
	if SettingSkipLocks then
		if File:match("locked") then
			File = File:gsub("AddStage%s*%(\"locked\".-%s*%);(.-)CloseStage%s*%(%s*%);%s*AddStage%s*%([^\n]-%s*%);.-CloseStage%s*%(%s*%);", "AddStage();%1CloseStage();", 1);
		end
	end
	if SettingSkipFMVs then
		File = File:gsub("AddObjective%s*%(\"fmv\"%s*%);.-CloseObjective%s*%(%s*%);", "AddObjective(\"timer\");\r\nSetDurationTime(1);\r\nCloseObjective();", 1)
	end
	if SettingRandomDirectives then
		File = File:gsub("SetStageMessageIndex%s*%(%s*[+-]?%d+%s*%)", function()
			return "SetStageMessageIndex(" .. math.random(1, 273) .. ")"
		end)
		File = File:gsub("SetPresentationBitmap%s*%(%s*\"art/frontend/dynaload/images/.-%.p3d\"%s*%)", function()
			return "SetPresentationBitmap(\"art/frontend/dynaload/images/" .. GetRandomFromTbl(PresentationP3DPool, false) .. ".p3d\")"
		end)
		for orig,rand in pairs(iconReplace) do
			File = File:gsub("SetHUDIcon%s*%(%s*\"" .. orig .. "\"%s*%)", "SetHUDIcon(\"" .. rand .. "\")")
		end
	end
	if SettingRandomInteriors then
		File = File:gsub("SetDynaLoadData%s*%(%s*\"([^\n]-)i([^\n]-).p3d@\"", function(data, interior)
			local newInterior = nil
			for k,v in pairs(interiorReplace) do
				if v == interior then
					newInterior = k
					break
				end
			end
			return "SetDynaLoadData(\"" .. data .. "i" .. newInterior .. ".p3d@\""
		end)
	end

Output(File)