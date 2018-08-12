local Path = "/GameData/" .. GetPath()
if SettingRandomDialogue and RandomDialoguePoolN > 0 then
	local RedirectPath = RandomDialoguePool[math.random(RandomDialoguePoolN)]

	DebugPrint("Redirecting " .. Path .. " to " .. RedirectPath)

	Redirect(RedirectPath)
elseif SettingRandomMissions then
	if IsModEnabled("RandomiserDialogue") then
		local RedirectPath = Path:gsub("/GameData/", "/GameData/RandomDialogue/")
		if Exists(RedirectPath, true, false) then
			DebugPrint("Redirecting " .. Path .. " to " .. RedirectPath)
			Redirect(RedirectPath)
		else
			DebugPrint("Redirecting " .. Path .. " to empty.rsd")
			Redirect(ModPath .. "/Resources/empty.rsd")
		end
	else
		DebugPrint("Redirecting " .. Path .. " to empty.rsd")
		Redirect(ModPath .. "/Resources/empty.rsd")
	end
end
