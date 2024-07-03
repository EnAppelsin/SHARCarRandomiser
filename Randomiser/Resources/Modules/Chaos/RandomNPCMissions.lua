local math_random = math.random
local table_remove = table.remove

local RandomNPCMissions = Module("Random NPC Missions", "RandomNPCMissions")

RandomNPCMissions:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	local functions = LevelInit.Functions
	
	local NPCMissions = {}
	
	for i=1,#functions do
		local func = functions[i]
		if func.Name:lower() == "addnpccharacterbonusmission" then
			NPCMissions[#NPCMissions + 1] = { func.Arguments[4], func.Arguments[5], func.Arguments[7] }
		end
	end
	
	local npcMissionPosMap = {}
	for i=1,#functions do
		local func = functions[i]
		local name = func.Name:lower()
		if name == "addnpccharacterbonusmission" then
			local index = math_random(#NPCMissions)
			local NPCMission = NPCMissions[index]
			table_remove(NPCMissions, index)
			print("Replacing NPC mission \"" .. func.Arguments[4] .. "\" with: " .. NPCMission[1])
			npcMissionPosMap[func.Arguments[4]] = NPCMission[1]
			func.Arguments[4] = NPCMission[1]
			func.Arguments[5] = NPCMission[2]
			func.Arguments[7] = NPCMission[3]
		elseif name == "setbonusmissiondialoguepos" then
			if npcMissionPosMap[func.Arguments[1]] then
				func.Arguments[1] = npcMissionPosMap[func.Arguments[1]]
			end
		elseif name == "setconversationcam" then
			if npcMissionPosMap[func.Arguments[3]] then
				func.Arguments[3] = npcMissionPosMap[func.Arguments[3]]
			end
		elseif name == "setcambestside" then
			if npcMissionPosMap[func.Arguments[2]] then
				func.Arguments[2] = npcMissionPosMap[func.Arguments[2]]
			end
		end
	end
	
	return true
end)

return RandomNPCMissions