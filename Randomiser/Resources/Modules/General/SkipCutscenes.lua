local SkipCutscenes = Module("Skip Cutscenes", "SkipCutscenes")

local function RemoveFMVs(LevelNumber, MissionNumber, MissionLoad, MissionInit)
	local changed = MissionInit:SetAll("addobjective", 1, "timer", "fmv")
	if changed then
		for Function in MissionInit:GetFunctions("SetFMVInfo") do
			Function.Name = "SetDurationTime"
			Function.Arguments[1] = 0
		end
		return true
	end
end

SkipCutscenes:AddSundayDriveHandler(RemoveFMVs)
SkipCutscenes:AddMissionHandler(RemoveFMVs)

return SkipCutscenes