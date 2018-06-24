local Path = "/GameData/" .. GetPath();

if GetSetting("RandomCharacter") and OrigChar and RandomChar then
	local origShort = nil
	local randomShort = nil

	for k,v in pairs(shortnames) do
		if k == OrigChar then
			origShort = v
		end
		if k == RandomChar then
			randomShort = v
		end
	end

	if origShort and randomShort and string.match(Path, "conversations") and string.match(Path, randomShort .. "_L") then
		local newPath = string.gsub(Path, "/GameData/conversations\\", "/Mods/RandomCar/conversations/")
		local newPath = string.gsub(newPath, "_" .. randomShort .. "_", "_" .. origShort .. "_")
		Output(ReadFile(newPath))
	end
end