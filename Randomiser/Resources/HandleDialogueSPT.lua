if Settings.RandomMissions then
	Output(ReadFile("/GameData/" .. GetPath()):gsub("L(%d)M%d", "L%1"))
end