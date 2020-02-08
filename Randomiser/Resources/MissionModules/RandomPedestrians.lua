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
	
	function Level.RandomPedestrians(LoadFile, InitFile, Level, Path)
		local Peds = ""
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
			for i = 1, 7 do
				local pedName = GetRandomFromTbl(TmpPedPool, true)
				if not TmpPedPool or #TmpPedPool == 0 then
					TmpPedPool = {table.unpack(RandomPedPool)}
				end
				Peds = Peds .. pedName .. ", "
				ret = ret .. "AddPed(\"" .. pedName .. "\", 1);\r\n"
				if pedName:len() > 6 then
					pedName = pedName:sub(1, 6)
				end
				LevelPedestrians[#LevelPedestrians + 1] = pedName .. "_m"
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
		DebugPrint("Random pedestrians for level -> " .. Peds)
		return LoadFile, InitFile
	end
end