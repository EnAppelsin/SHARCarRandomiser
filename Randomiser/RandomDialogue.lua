local hasFolder = false

DirectoryGetEntries("/GameDir", function(name, directory)
	if directory and name == "RandomDialogue" then
		hasFolder = true
	end
	return true
end)

if hasFolder then
	GetFiles(RandomDialoguePool, "/GameDir/RandomDialogue/", ".rsd", 1)
	RandomDialoguePoolN = #RandomDialoguePool
	print("Loaded " .. RandomDialoguePoolN .. " dialogue files.")
end