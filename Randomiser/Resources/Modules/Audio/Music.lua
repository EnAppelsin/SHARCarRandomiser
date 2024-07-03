local RandomMusic = Module("Random Music", "RandomMusic")

-- Ideally this would be done in Lua
-- But fuck me the RMS format is scary
local RMSPaths = {
	Paths.Resources .. "/RMS/random_music.rms",
	Paths.Resources .. "/RMS/random_cues.rms",
	Paths.Resources .. "/RMS/random_all.rms",
}
local RMSPath = RMSPaths[Settings.RandomMusicMode]

RandomMusic:AddGenericHandler("sound/music/l?_music.rms", function(Path, Contents)
	print("Replacing RMS \"" .. Path .. "\" with: " .. RMSPath)
	return true, ReadFile(RMSPath)
end)

return RandomMusic