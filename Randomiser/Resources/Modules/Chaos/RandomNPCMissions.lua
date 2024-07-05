local math_random = math.random
local table_remove = table.remove

local RandomNPCMissions = Module("Random NPC Missions", "RandomNPCMissions")

RandomNPCMissions:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	local NPCMissions = {}
	local NPCMissionsN = 0
	
	for Function in LevelInit:GetFunctions("AddNPCCharacterBonusMission") do
		NPCMissionsN = NPCMissionsN + 1
		NPCMissions[NPCMissionsN] = { Function.Arguments[4], Function.Arguments[5], Function.Arguments[7] }
	end
	
	ShuffleTable(NPCMissions)
	
	local npcMissionPosMap = {}
	for Function in LevelInit:GetFunctions() do
		local name = Function.Name:lower()
		if name == "addnpccharacterbonusmission" then
			local NPCMission = NPCMissions[1]
			table_remove(NPCMissions, 1)
			print("Replacing NPC mission \"" .. Function.Arguments[4] .. "\" with: " .. NPCMission[1])
			npcMissionPosMap[Function.Arguments[4]] = NPCMission[1]
			Function.Arguments[4] = NPCMission[1]
			Function.Arguments[5] = NPCMission[2]
			Function.Arguments[7] = NPCMission[3]
		elseif name == "setbonusmissiondialoguepos" then
			if npcMissionPosMap[Function.Arguments[1]] then
				Function.Arguments[1] = npcMissionPosMap[Function.Arguments[1]]
			end
		elseif name == "setconversationcam" then
			if npcMissionPosMap[Function.Arguments[3]] then
				Function.Arguments[3] = npcMissionPosMap[Function.Arguments[3]]
			end
		elseif name == "setcambestside" then
			if npcMissionPosMap[Function.Arguments[2]] then
				Function.Arguments[2] = npcMissionPosMap[Function.Arguments[2]]
			end
		end
	end
	
	return true
end)

return RandomNPCMissions