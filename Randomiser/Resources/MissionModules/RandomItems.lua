local args = {...}
local tbl = args[1]
if Settings.RandomItems then
	RandomItemPool = {}
	RandomItemPool["bonestorm"] = "art\\missions\\level01\\bonebox"
	RandomItemPool["coolr"] = "art\\missions\\level01\\coolr"
	RandomItemPool["flanpic"] = "art\\missions\\level01\\flanpic"
	RandomItemPool["h_soda"] = "art\\missions\\level01\\h_soda"
	RandomItemPool["i_soda"] = "art\\missions\\level01\\i_soda"
	RandomItemPool["icebuck"] = "art\\missions\\level01\\ibucket"
	RandomItemPool["inhaler"] = "art\\missions\\level01\\inhaler"
	RandomItemPool["lwnchair"] = "art\\missions\\level01\\lwnchair"
	RandomItemPool["mower"] = "art\\missions\\level01\\mower"
	RandomItemPool["poster_t"] = "art\\missions\\level01\\poster_t"
	RandomItemPool["scien"] = "art\\missions\\level01\\scien"
	RandomItemPool["tomat"] = "art\\missions\\level01\\tomat"
	RandomItemPool["tux"] = "art\\missions\\level01\\tux"
	RandomItemPool["blend"] = "art\\missions\\level02\\blend"
	RandomItemPool["bloodbag"] = "art\\missions\\level02\\bloodbag"
	RandomItemPool["firewrks"] = "art\\missions\\level02\\firewrks"
	RandomItemPool["i_bldbag"] = "art\\missions\\level02\\i_bldbag"
	RandomItemPool["i_firewk"] = "art\\missions\\level02\\i_firewk"
	RandomItemPool["monkey"] = "art\\missions\\level02\\monkey"
	RandomItemPool["radio"] = "art\\missions\\level02\\radio"
	RandomItemPool["roadkill"] = "art\\missions\\level02\\roadkill"
	RandomItemPool["s_dish"] = "art\\missions\\level02\\satellite"
	RandomItemPool["cream"] = "art\\missions\\level03\\cream"
	RandomItemPool["diaper"] = "art\\missions\\level03\\diaper"
	RandomItemPool["fish"] = "art\\missions\\level03\\fish"
	RandomItemPool["h_soda"] = "art\\missions\\level03\\h_soda"
	RandomItemPool["is_comic"] = "art\\missions\\level03\\is_comic"
	RandomItemPool["jeans"] = "art\\missions\\level03\\jeans"
	RandomItemPool["kmeal"] = "art\\missions\\level03\\kmeal"
	RandomItemPool["laundry"] = "art\\missions\\level03\\laundry"
	RandomItemPool["molemanr"] = "art\\missions\\level03\\molemanr"
	RandomItemPool["rhat"] = "art\\missions\\level03\\rhat"
	RandomItemPool["cola"] = "art\\missions\\level04\\cola"
	RandomItemPool["cpill"] = "art\\missions\\level04\\cpill"
	RandomItemPool["donut"] = "art\\missions\\level04\\donut"
	RandomItemPool["i_cpill"] = "art\\missions\\level04\\i_cpill"
	RandomItemPool["ketchup"] = "art\\missions\\level04\\ketchup"
	RandomItemPool["pills"] = "art\\missions\\level04\\pills"
	RandomItemPool["r_choco"] = "art\\missions\\level04\\r_choco"
	RandomItemPool["r_dent"] = "art\\missions\\level04\\r_dent"
	RandomItemPool["r_diaper"] = "art\\missions\\level04\\r_diaper"
	RandomItemPool["r_onions"] = "art\\missions\\level04\\r_onions"
	RandomItemPool["r_tomb"] = "art\\missions\\level04\\r_tomb"
	RandomItemPool["folder"] = "art\\missions\\level05\\folder"
	RandomItemPool["i_folder"] = "art\\missions\\level05\\i_folder"
	RandomItemPool["key"] = "art\\missions\\level05\\key"
	RandomItemPool["litter"] = "art\\missions\\level05\\litter"
	RandomItemPool["laserbox_crate"] = "art\\missions\\level06\\laserbox"
	RandomItemPool["lasergun"] = "art\\missions\\level06\\lasergun"
	RandomItemPool["lasrstnd"] = "art\\missions\\level06\\lasrstnd"
	RandomItemPool["s_boy1"] = "art\\missions\\level06\\s_boy1"
	RandomItemPool["s_boy2"] = "art\\missions\\level06\\s_boy2"
	RandomItemPool["s_girl1"] = "art\\missions\\level06\\s_girl1"
	RandomItemPool["s_girl2"] = "art\\missions\\level06\\s_girl2"
	RandomItemPool["map"] = "art\\missions\\level07\\map"
	RandomItemPool["medkit"] = "art\\missions\\level07\\medkit"
	RandomItemPool["record"] = "art\\missions\\level07\\record"
	RandomItemPool["saw"] = "art\\missions\\level07\\saw"
	RandomItemPool["sockg"] = "art\\missions\\level07\\sockg"
	RandomItemPool["tooth"] = "art\\missions\\level07\\tooth"
	RandomItemPool["wplanks"] = "art\\missions\\level07\\wplanks"
	
	RandomItemPool["finish_line"] = "art\\missions\\generic\\fline"
	RandomItemPool["nitro"] = "art\\missions\\generic\\nitro"
	RandomItemPool["wrench"] = ""
	RandomItemPool["carsphere"] = ""
	RandomItemPool["triggersphere"] = ""
	RandomItemPool["arrow_destroy"] = ""
	RandomItemPool["exclamation"] = ""
	RandomItemPool["dollar"] = ""
	RandomItemPool["arrow_race"] = ""
	RandomItemPool["checkered"] = ""
	RandomItemPool["checkeredfinish"] = ""
	RandomItemPool["arrow_evade"] = ""
	RandomItemPool["arrow_chase"] = ""
	RandomItemPool["mission_col"] = ""
	RandomItemPool["arrow"] = ""
	RandomItemPool["dice"] = ""
	RandomItemPool["shirtdollar"] = ""
	RandomItemPool["phone_icon"] = ""
	RandomItemPool["card_idle"] = ""
	RandomItemPool["beecamera"] = ""
	RandomItemPool["huskA"] = ""

	local sort = 5
	Level = {}
	Mission = {}
	if not tbl.Level[sort] then
		tbl.Level[sort] = Level
	else
		Level = tbl.Level[sort]
	end
	if not tbl.Mission[sort] then
		tbl.Mission[sort] = Mission
	else
		Mission = tbl.Mission[sort]
	end
	
	function GetTmpTable()
		local tmp = CloneKVTable(RandomItemPool)
		if Settings.RandomItemsIncludeCars then
			if Settings.RandomMissionVehicles and MissionVehicles then
				for k,v in pairs(MissionVehicles) do
					for k2,v2 in pairs(v) do
						tmp[v2] = ""
					end
				end
			end
			if Settings.RandomPlayerVehicles and RandomCarName then
				tmp[RandomCarName] = ""
			end
			if Settings.RandomChase and RandomChase then
				tmp[RandomChase] = ""
			end
			if Settings.RandomTraffic and TrafficCars then
				for i=1,#TrafficCars do
					tmp[TrafficCars[i]] = ""
				end
			end
		end
		if Settings.RandomItemsIncludeChars then
			for i=1,#RandomPedPool do
				tmp[RandomPedPool[i] .. "_h"] = "art\\chars\\" .. RandomPedPool[i]:sub(1, 6) .. "_m"
			end
		end
		return tmp
	end
	
	function Level.RandomItems(LoadFile, InitFile, Level, Path)
		local TmpItemPool = CloneKVTable(RandomItemPool)
		InitFile = InitFile:gsub("AddNPCCharacterBonusMission%s*%(%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"", function(npc, skeleton, location, mission, drawable)
			local newDrawable, newDrawablePath = GetRandomFromKVTbl(TmpItemPool, true)
			if newDrawablePath and newDrawablePath:len() > 0 and not LoadFile:match(newDrawablePath) then
				LoadFile = LoadFile .. "\r\nLoadP3DFile(\"" .. newDrawablePath .. ".p3d\");"
			end
			return "AddNPCCharacterBonusMission(\"" .. npc .. "\",\"" .. skeleton .. "\",\"" .. location .. "\",\"" .. mission .. "\",\"" .. newDrawable .. "\""
		end)
		return LoadFile, InitFile
	end
	
	function Mission.RandomItems(LoadFile, InitFile, Level, Mission, Path)
		local items = {}
		local randomisedPaths = {}
		local TmpItemPool = GetTmpTable()
		InitFile = InitFile:gsub("AddCollectible%s*%(%s*\"([^\n]-)\"%s*,%s*\"([^\n]-)\"", function(locator, itemName)
			local origPath = RandomItemPool[itemName]
			if origPath and not itemName:match("finish_line") then
				if CountTable(TmpItemPool) == 0 then
					TmpItemPool = GetTmpTable()
				end
				local randName, randPath = GetRandomFromKVTbl(TmpItemPool, true)
				if string.len(randPath) > 0 then
					if not ExistsInTbl(items, randPath, false) then
						table.insert(items, randPath)
					end
				end
				if string.len(origPath) > 0 then
					if not ExistsInTbl(randomisedPaths, origPath, false) then
						table.insert(randomisedPaths, origPath)
					end				
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
			if origPath	then
				if CountTable(TmpItemPool) == 0 then
					TmpItemPool = GetTmpTable()
				end
				local randName, randPath = GetRandomFromKVTbl(TmpItemPool, true)
				if string.len(randPath) > 0 then
					if not ExistsInTbl(items, randPath, false) then
						table.insert(items, randPath)
					end
				end
				if string.len(origPath) > 0 then
					if not ExistsInTbl(randomisedPaths, origPath, false) then
						table.insert(randomisedPaths, origPath)
					end				
				end
				DebugPrint("Randomising item \"" .. itemName .. "\" to \"" .. randName .. "\".")
				return "SetDestination(\"" .. locator .. "\",\"" .. randName .. "\""
			else
				DebugPrint("Not randomising item \"" .. itemName .. "\".", 2)
				return "SetDestination(\"" .. locator .. "\",\"" .. itemName .. "\""
			end
		end)
		
		LoadFile = LoadFile:gsub("LoadP3DFile%s*%(%s*\"art\\missions([^\n]-)%.p3d\"%s*%);", function(orig)
			if not ExistsInTbl(randomisedPaths, "art\\missions" .. orig) or orig:match("generic\\fline") then
				DebugPrint("Not replacing item load: " .. orig .. ".", 2)
				return "LoadP3DFile(\"art\\missions" .. orig .. ".p3d\");"
			elseif #items == 0 then
				DebugPrint("Removing item load: " .. orig .. ".")
				return ""
			else
				local item = items[1]
				table.remove(items, 1)
				DebugPrint("Replacing item load \"" .. orig .. "\" with \"" .. item .. "\".")
				return "LoadP3DFile(\"" .. item .. ".p3d\");"
			end
		end)
		for i=1,#items do
			LoadFile = LoadFile .. "\r\nLoadP3DFile(\"" .. items[i] .. ".p3d\");"
		end
		return LoadFile, InitFile
	end
end