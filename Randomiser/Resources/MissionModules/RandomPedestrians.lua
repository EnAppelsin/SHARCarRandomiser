local args = {...}
local tbl = args[1]
if Settings.RandomPedestrians then
	function tbl.Level.RandomPedestrians(LoadFile, InitFile, Level, Path)
		local Peds = ""
		local TmpPedPool = {table.unpack(RandomPedPool)}
		local groups = {}
		for group in InitFile:gmatch("CreatePedGroup%s*%(%s*(%d)%s*%);") do
			table.insert(groups, group)
		end
		local ret = ""
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
			end
			ret = ret .. "ClosePedGroup( );"
		end
		InitFile = InitFile:gsub("CreatePedGroup%s*%(%s*(%d)%s*%);(.*)ClosePedGroup%s*%(%s*%);", function(group, current)
			return ret
		end)
		LevelCharacters = {}
		for npc in InitFile:gmatch("AddAmbientCharacter%s*%(%s*\"([^\n]-)\"") do
			table.insert(LevelCharacters, npc)
		end
		DebugPrint("Random pedestrians for level -> " .. Peds)
		return LoadFile, InitFile
	end
end