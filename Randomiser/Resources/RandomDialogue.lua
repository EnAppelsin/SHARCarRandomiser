if IsModEnabled("RandomiserDialogue") then
	if Exists("/GameData/RandomDialogue", false, true) then
		local extensions = {".rsd"}
		if IsHackLoaded("OggVorbisSupport") then
			table.insert(extensions, ".ogg")
		end
		if IsHackLoaded("FLACSupport") then
			table.insert(extensions, ".flac")
		end
		GetFiles(RandomDialoguePool, "/GameData/RandomDialogue/", extensions, 1)
		RandomDialoguePoolN = #RandomDialoguePool
		if RandomDialoguePoolN == 0 then
			if not Confirm("RandomiserDialogue was enabled, but no dialogue files were loaded.\n\nTo continue loading the game press OK, to close press Cancel.") then
				os.exit()
			end
		else
			DebugPrint("Loaded " .. RandomDialoguePoolN .. " dialogue files.")
		end
	else
		if not Confirm("RandomiserDialogue was enabled, but no RandomDialogue folder was found.\n\nTo continue loading the game press OK, to close press Cancel.") then
			os.exit()
		end
	end
else
	if not Confirm("You have Random Dialogue enabled without the RandomiserDialogue framework. Random Dialogue will not work without this.\n\nTo continue loading the game press OK, to close press Cancel.") then
		os.exit()
	end
end
