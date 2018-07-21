local Path = "/GameData/" .. GetPath()
if SettingRandomDialogue and RandomDialoguePoolN > 0 then
	local RedirectPath = RandomDialoguePool[math.random(RandomDialoguePoolN)]

	DebugPrint("Redirecting " .. Path .. " to " .. RedirectPath)

	Redirect(RedirectPath)
end
