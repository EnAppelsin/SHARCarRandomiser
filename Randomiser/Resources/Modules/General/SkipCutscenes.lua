local SkipCutscenes = Module("Skip Cutscenes", "SkipCutscenes")

local function RemoveFMVs(LevelNumber, MissionNumber, MissionLoad, MissionInit)
	local changed = MissionInit:SetAll("addobjective", 1, "timer", "fmv")
	if changed then
		local functions = MissionInit.Functions
		for i=1,#functions do
			local func = functions[i]
			if func.Name:lower() == "setfmvinfo" then
				func.Name = "SetDurationTime"
				func.Arguments[1] = 1
			end
		end
		return true
	end
end

SkipCutscenes:AddSundayDriveHandler(RemoveFMVs)
SkipCutscenes:AddMissionHandler(RemoveFMVs)

return SkipCutscenes