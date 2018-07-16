local Path = "/GameData/" .. GetPath()

if Path:match("L%d_music") then
    if SettingRandomMusic and SettingRandomMusicCues then
		DebugPrint("Replacing " .. Path .. " with random_all.rms")
        Redirect(ModPath .. "/Resources/random_all.rms")
    elseif SettingRandomMusic  then
		DebugPrint("Replacing " .. Path .. " with random_music.rms")
        Redirect(ModPath .. "/Resources/random_music.rms")
    elseif SettingRandomMusicCues then
		DebugPrint("Replacing " .. Path .. " with random_cues.rms")
        Redirect(ModPath .. "/Resources/random_cues.rms")
    end
end