local Path = "/GameData/" .. GetPath()

if Settings.RandomLevelMissions then
	if Path:match("l1") then
		local file = ReadFile(Path:gsub("level01", "level04"):gsub("l1_", "l4_"))
		file = file:gsub("l4", "l1")
		Output(file)
	end
end