-- Load the file
local Path = "/GameData/" .. GetPath();
local File = ReadFile(Path);

-- Only update the randomly spawned car
if RandomCarName and string.match(Path, RandomCarName) then

	if GetSetting("BoostHP") then
		HP = string.match(File, "SetHitPoints%((.-)%);")
		if HP and tonumber(HP) < 0.8 then
			File = string.gsub(File, "SetHitPoints%(.-%);", "SetHitPoints(0.8);", 1)
			print("Boosting HP up from " .. HP .. " to 0.8 for " .. Path)
		end
	end

end

Output(File)
