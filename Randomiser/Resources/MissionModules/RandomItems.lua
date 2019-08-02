local args = {...}
local tbl = args[1]
if Settings.RandomItems then
	RandomItemPool = {}
	RandomItemPool["bonestorm"] = "\\level01\\bonebox"
	RandomItemPool["coolr"] = "\\level01\\coolr"
	RandomItemPool["flanpic"] = "\\level01\\flanpic"
	RandomItemPool["h_soda"] = "\\level01\\h_soda"
	RandomItemPool["i_soda"] = "\\level01\\i_soda"
	RandomItemPool["icebuck"] = "\\level01\\ibucket"
	RandomItemPool["inhaler"] = "\\level01\\inhaler"
	RandomItemPool["lwnchair"] = "\\level01\\lwnchair"
	RandomItemPool["mower"] = "\\level01\\mower"
	RandomItemPool["poster_t"] = "\\level01\\poster_t"
	RandomItemPool["scien"] = "\\level01\\scien"
	RandomItemPool["tomat"] = "\\level01\\tomat"
	RandomItemPool["tux"] = "\\level01\\tux"
	RandomItemPool["blend"] = "\\level02\\blend"
	RandomItemPool["bloodbag"] = "\\level02\\bloodbag"
	RandomItemPool["firewrks"] = "\\level02\\firewrks"
	RandomItemPool["i_bldbag"] = "\\level02\\i_bldbag"
	RandomItemPool["i_firewk"] = "\\level02\\i_firewk"
	RandomItemPool["monkey"] = "\\level02\\monkey"
	RandomItemPool["radio"] = "\\level02\\radio"
	RandomItemPool["roadkill"] = "\\level02\\roadkill"
	RandomItemPool["s_dish"] = "\\level02\\satellite"
	RandomItemPool["cream"] = "\\level03\\cream"
	RandomItemPool["diaper"] = "\\level03\\diaper"
	RandomItemPool["fish"] = "\\level03\\fish"
	RandomItemPool["h_soda"] = "\\level03\\h_soda"
	RandomItemPool["is_comic"] = "\\level03\\is_comic"
	RandomItemPool["jeans"] = "\\level03\\jeans"
	RandomItemPool["kmeal"] = "\\level03\\kmeal"
	RandomItemPool["laundry"] = "\\level03\\laundry"
	RandomItemPool["molemanr"] = "\\level03\\molemanr"
	RandomItemPool["rhat"] = "\\level03\\rhat"
	RandomItemPool["cola"] = "\\level04\\cola"
	RandomItemPool["cpill"] = "\\level04\\cpill"
	RandomItemPool["donut"] = "\\level04\\donut"
	RandomItemPool["i_cpill"] = "\\level04\\i_cpill"
	RandomItemPool["ketchup"] = "\\level04\\ketchup"
	RandomItemPool["pills"] = "\\level04\\pills"
	RandomItemPool["r_choco"] = "\\level04\\r_choco"
	RandomItemPool["r_dent"] = "\\level04\\r_dent"
	RandomItemPool["r_diaper"] = "\\level04\\r_diaper"
	RandomItemPool["r_onions"] = "\\level04\\r_onions"
	RandomItemPool["r_tomb"] = "\\level04\\r_tomb"
	RandomItemPool["folder"] = "\\level05\\folder"
	RandomItemPool["i_folder"] = "\\level05\\i_folder"
	RandomItemPool["key"] = "\\level05\\key"
	RandomItemPool["litter"] = "\\level05\\litter"
	RandomItemPool["laserbox_crate"] = "\\level06\\laserbox"
	RandomItemPool["lasergun"] = "\\level06\\lasergun"
	RandomItemPool["lasrstnd"] = "\\level06\\lasrstnd"
	RandomItemPool["s_boy1"] = "\\level06\\s_boy1"
	RandomItemPool["s_boy2"] = "\\level06\\s_boy2"
	RandomItemPool["s_girl1"] = "\\level06\\s_girl1"
	RandomItemPool["s_girl2"] = "\\level06\\s_girl2"
	RandomItemPool["map"] = "\\level07\\map"
	RandomItemPool["medkit"] = "\\level07\\medkit"
	RandomItemPool["record"] = "\\level07\\record"
	RandomItemPool["saw"] = "\\level07\\saw"
	RandomItemPool["sockg"] = "\\level07\\sockg"
	RandomItemPool["tooth"] = "\\level07\\tooth"
	RandomItemPool["wplanks"] = "\\level07\\wplanks"

	function tbl.Mission.RandomItems(LoadFile, InitFile, Level, Mission)
		local items = {}
		local randomisedPaths = {}
		local TmpItemPool = CloneKVTable(RandomItemPool)
		InitFile = InitFile:gsub("AddCollectible%s*%(%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"", function(locator, itemName)
			local origPath = RandomItemPool[itemName]
			if origPath ~= nil then
				if CountTable(TmpItemPool) == 0 then
					TmpItemPool = CloneKVTable(RandomItemPool)
				end
				local randName, randPath = GetRandomFromKVTbl(TmpItemPool, true)
				if not ExistsInTbl(items, randPath, false) then
					table.insert(items, randPath)
				end
				if not ExistsInTbl(randomisedPaths, origPath, false) then
					table.insert(randomisedPaths, origPath)
				end
				DebugPrint("Randomising item \"" .. itemName .. "\" to \"" .. randName .. "\".")
				return "AddCollectible(\"" .. locator .. "\",\"" .. randName .. "\""
			else
				DebugPrint("Not randomising item \"" .. itemName .. "\".", 2)
				return "AddCollectible(\"" .. locator .. "\",\"" .. itemName .. "\""
			end
		end)
		
		InitFile = InitFile:gsub("SetDestination%s*%(%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"", function(locator, itemName)
			local origPath = RandomItemPool[itemName]
			if origPath ~= nil then
				if CountTable(TmpItemPool) == 0 then
					TmpItemPool = CloneKVTable(RandomItemPool)
				end
				local randName, randPath = GetRandomFromKVTbl(TmpItemPool, true)
				if not ExistsInTbl(items, randPath, false) then
					table.insert(items, randPath)
				end
				if not ExistsInTbl(randomisedPaths, origPath, false) then
					table.insert(randomisedPaths, origPath)
				end
				DebugPrint("Randomising item \"" .. itemName .. "\" to \"" .. randName .. "\".")
				return "SetDestination(\"" .. locator .. "\",\"" .. randName .. "\""
			else
				DebugPrint("Not randomising item \"" .. itemName .. "\".", 2)
				return "SetDestination(\"" .. locator .. "\",\"" .. itemName .. "\""
			end
		end)
		
		LoadFile = LoadFile:gsub("LoadP3DFile%s*%(%s*\"art\\missions([^\n]-)%.p3d\"%s*%);", function(orig)
			if not ExistsInTbl(randomisedPaths, orig) then
				DebugPrint("Not replacing item load: " .. orig .. ".", 2)
				return "LoadP3DFile(\"art\\missions" .. orig .. ".p3d\");"
			elseif #items == 0 then
				DebugPrint("Removing item load: " .. orig .. ".")
				return ""
			else
				local item = items[1]
				table.remove(items, 1)
				DebugPrint("Replacing item load \"" .. orig .. "\" with \"" .. item .. "\".")
				return "LoadP3DFile(\"art\\missions" .. item .. ".p3d\");"
			end
		end)
		for i=1,#items do
			LoadFile = LoadFile .. "\r\nLoadP3DFile(\"art\\missions" .. items[i] .. ".p3d\");"
		end
		return LoadFile, InitFile
	end
end