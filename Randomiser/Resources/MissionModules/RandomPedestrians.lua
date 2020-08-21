local args = {...}
local tbl = args[1]
if Settings.RandomPedestrians then
	local sort = 5
	local Level = {}
	if not tbl.Level[sort] then
		tbl.Level[sort] = Level
	else
		Level = tbl.Level[sort]
	end
	
	local function Level_RandomPedestrians(LoadFile, InitFile, Level, Path)
		local TmpPedPool = {table.unpack(RandomPedPool)}
		local groups = {}
		for group in InitFile:gmatch("CreatePedGroup%s*%(%s*(%d)%s*%);") do
			table.insert(groups, group)
		end
		local ret = ""
		LevelPedestrians = {}
		for i = 1, #groups do
			local group = groups[i]
			DebugPrint("Randomising group " .. group)
			ret = ret .. "CreatePedGroup( " .. group .. " );\r\n"
			if Settings.UseDebugSettings and Exists("/GameData/RandomiserSettings/Pedestrians.txt", true, false) then
				local contents = ReadFile("/GameData/RandomiserSettings/Pedestrians.txt")
				if contents:len() > 0 then
					for line in contents:gmatch("[^\r\n]+") do
						local pipe = line:find("|", 1, true)
						local pedName = pipe and line:sub(0, pipe - 1) or line
						local count = pipe and tonumber(line:sub(pipe + 1)) or 1
						ret = ret .. "AddPed(\"" .. pedName .. "\", " .. count .. ");\r\n"
						if pedName:len() > 6 then
							pedName = pedName:sub(1, 6)
						end
						LevelPedestrians[#LevelPedestrians + 1] = pedName .. "_m"
					end
				end
			end
			if #LevelPedestrians == 0 then
				for i = 1, 7 do
					local pedName = GetRandomFromTbl(TmpPedPool, true)
					if not TmpPedPool or #TmpPedPool == 0 then
						TmpPedPool = {table.unpack(RandomPedPool)}
					end
					ret = ret .. "AddPed(\"" .. pedName .. "\", 1);\r\n"
					if pedName:len() > 6 then
						pedName = pedName:sub(1, 6)
					end
					LevelPedestrians[#LevelPedestrians + 1] = pedName .. "_m"
				end
			end
			ret = ret .. "ClosePedGroup( );"
		end
		InitFile = InitFile:gsub("CreatePedGroup%s*%(%s*(%d)%s*%);(.*)ClosePedGroup%s*%(%s*%);", function(group, current)
			return ret
		end)
		LevelCharacters = {}
		for npc in InitFile:gmatch("AddAmbientCharacter%s*%(%s*\"([^\n]-)\"") do
			LevelCharacters[#LevelCharacters + 1] = npc
		end
		DebugPrint("Random pedestrians for level -> " .. table.concat(LevelPedestrians, ", "))
		return LoadFile, InitFile
	end
	
	if Settings.IsSeeded then
		Seed.AddSpoiler("-- RandomPedestrians --")
		Seed.RandomPedestrians = Seed.CacheFullLevel(Level_RandomPedestrians)
		Level.RandomPedestrians = Seed.ReturnFullLevel(Seed.RandomPedestrians)
	else
		Level.RandomPedestrians = Level_RandomPedestrians
	end
end