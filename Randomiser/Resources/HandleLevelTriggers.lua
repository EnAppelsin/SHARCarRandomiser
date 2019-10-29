local Path = "/GameData/" .. GetPath()
local level = tonumber(Path:match("level0(%d)"))
if Settings.RandomLevelMissions and level ~= 7 then
	local file = ReadFile(Path)
	local newLevel = GetLevel(level)
	local newFile = ReadFile("/GameData/art/missions/level0" .. newLevel .. "/level.p3d")
	renamedLocators = {}
	for pos, length in FindSubchunks(newFile, LOCATOR_CHUNK) do
		local s = newFile:sub(pos, pos + length - 1)
		local name, _ = GetP3DString(s, 13)
		local diff = 0
		name = FixP3DString(name)
		s, diff = SetP3DString(s, 13, MakeP3DString("L" .. newLevel .. name))
		s = AddP3DInt4(s, 5, diff)
		s = AddP3DInt4(s, 9, diff)
		file = file .. s
		renamedLocators[name] = "L" .. newLevel .. name
	end
	file = SetP3DInt4(file, 9, file:len())
	Output(file)
end