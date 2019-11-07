local Path = "/GameData/" .. GetPath()

if Settings.RandomLevelMissions and not Path:match("L7") then
	if Path:match("CustomT") and Path:match("L4") then
		if not Exists("/GameData/art/frontend/scrooby/resource/pure3d/_stubs/dummy.p3d", true, false) then
			Alert("You've got a bad pirate copy and you're missing a file... You should get a better copy.")
		else
			local file = ReadFile("/GameData/art/frontend/scrooby/resource/pure3d/_stubs/dummy.p3d")
			local newFile = ReadFile("/GameData/art/L4_TERRA.p3d")
			for pos, length in FindSubchunks(newFile, LOCATOR_CHUNK) do
				local s = newFile:sub(pos, pos + length - 1)
				local name, _ = GetP3DString(s, 13)
				if FixP3DString(name) == "bartroom" then
					s = s:gsub("l4", "l1")
					file = file .. s
				end
			end
			file = SetP3DInt4(file, 9, file:len())
			Output(file)
		end
	elseif Path:match("l1z4") or Path:match("l1r4b") then
		--Redirect(Path:gsub("l1", "l4"))
		local Original = ReadFile(Path:gsub("l1", "l4"))
		Original = BrightenModel(Original, 80)
		Output(Original)
	else --if Path:match("L1") then
		local level = tonumber(Path:match("%d"))
		local newLevel = GetLevel(level)
		local Original = ReadFile(Path)
		local Replace = ReadFile(Path:gsub("L" .. level, "L" .. newLevel))
		local Adjust = 0
		for position, length in FindSubchunks(Original, LOCATOR_CHUNK) do
			local name, _ = GetP3DString(Original, position + 12 - Adjust)
			if name:sub(1, 6) == "loader" then
				DebugPrint("Removing loader: " .. name, 2)
				Original = RemoveString(Original, position - Adjust, position + length - Adjust)
				Adjust = Adjust + length
			end
		end
		for position, length in FindSubchunks(Replace, LOCATOR_CHUNK) do
			local name, _ = GetP3DString(Replace, position + 12)
			if name:sub(1, 6) == "loader" then
				DebugPrint("Adding loader: " .. name, 2)
				Original = Original .. Replace:sub(position, position + length - 1):gsub("l4", "l1")
			end
		end
		Adjust = 0
		for position, length in FindSubchunks(Original, WALL_COLLISION_CONTAINER_CHUNK) do
			Original = RemoveString(Original, position - Adjust, position + length - Adjust)
			Adjust = Adjust + length
		end
		for position, length in FindSubchunks(Replace, WALL_COLLISION_CONTAINER_CHUNK) do
			Original = Original .. Replace:sub(position, position + length - 1)
		end
		Original = SetP3DInt4(Original, 9, Original:len())
		Output(Original)
	end
end