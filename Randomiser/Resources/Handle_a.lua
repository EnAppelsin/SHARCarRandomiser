local Path = "/GameData/" .. GetPath()


if  Path:sub(21,21) ~= "n" then
	Path = "/GameData/art/chars/out.p3d"
end

Output(ReadFile(Path))
