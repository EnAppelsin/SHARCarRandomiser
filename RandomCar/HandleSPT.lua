local Path = "/GameData/" .. GetPath();

if GetSetting("RandomCharacter") and string.match(Path, "dialog%.spt") then
	Output(dialogspt)
end

if string.match(Path, "car_tune%.spt") then
	Output(cartunespt)
end