local hasFolder = false

DirectoryGetEntries("/GameDir", function(name, directory)
	if directory and name == "RandomDialogue" then
		hasFolder = true
	end
	return true
end)

if IsModEnabled("RandomiserDialogue") then
	local hasFolder = false

	DirectoryGetEntries("/GameData", function(name, directory)
		if directory and name == "RandomDialogue" then
			hasFolder = true
		end
		return true
	end)
	
	if hasFolder then
		GetFiles(RandomDialoguePool, "/GameData/RandomDialogue/", ".rsd", 1)
		RandomDialoguePoolN = #RandomDialoguePool
		DebugPrint("Loaded " .. RandomDialoguePoolN .. " dialogue files.")
	else
		DebugPrint("RandomiserDialogue was enabled, but no RandomDialogue folder was found.")
	end
end