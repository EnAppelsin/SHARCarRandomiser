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
		LoadFile = LoadFile:gsub("LoadP3DFile%s*%(%s*\"art\\missions([^\n]-)%.p3d\"", function(orig)
			local origName = nil
			for k,v in pairs(RandomItemPool) do
				if v == orig then
					origName = k
					break
				end
			end
			if origName ~= nil then
				local randName, rand = GetRandomFromKVTbl(RandomItemPool, false)
				DebugPrint("Replacing item " .. orig .. " with " .. rand .. " (" .. randName .. ")")
				InitFile = File:gsub("AddCollectible%s*%(%s*\"([^\n]-)\"%s*,%s*\"" .. origName .. "\"", "AddCollectible(\"%1\",\"" .. randName .. "\"")
				InitFile = File:gsub("SetDestination%s*%(%s*\"([^\n]-)\"%s*,%s*\"" .. origName .. "\"", "SetDestination(\"%1\",\"" .. randName .. "\"")
				return "LoadP3DFile(\"art\\missions" .. rand .. ".p3d\""
			else
				return "LoadP3DFile(\"art\\missions" .. orig .. ".p3d\""
			end
		end)
		return LoadFile, InitFile
	end
end