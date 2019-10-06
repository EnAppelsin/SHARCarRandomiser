local Path = "/GameData/" .. GetPath()

if Path:match("L%d_music") then
    if Settings.RandomMusic and Settings.RandomMusicCues then
		DebugPrint("Replacing " .. Path .. " with random_all.rms")
        Redirect(ModPath .. "/Resources/random_all.rms")
    elseif Settings.RandomMusic  then
		DebugPrint("Replacing " .. Path .. " with random_music.rms")
        Redirect(ModPath .. "/Resources/random_music.rms")
    elseif Settings.RandomMusicCues then
		DebugPrint("Replacing " .. Path .. " with random_cues.rms")
        Redirect(ModPath .. "/Resources/random_cues.rms")
    end
end