local Path = "/GameData/" .. GetPath();

if SettingRandomMusic and SettingRandomMusicCues then
	Redirect(ModPath .. "/Resources/random_all.rms")
elseif SettingRandomMusic  then
	Redirect(ModPath .. "/Resources/random_music.rms")
elseif SettingRandomMusicCues then
	Redirect(ModPath .. "/Resources/random_cues.rms")
end
