local args = {...}
if #args > 0 then
	local tbl = args[1]
	if tbl.Level == nil then
		tbl.Level = {}
	end
	
	if Settings.RandomInteriors then
		interiorNames = {}
		interiorNames["00"] = "SpringfieldElementary"
		interiorNames["01"] = "KwikEMart"
		interiorNames["02"] = "SimpsonsHouse"
		interiorNames["03"] = "dmv"
		interiorNames["04"] = "moe1"
		interiorNames["05"] = "Android"
		interiorNames["06"] = "Observatory"
		interiorNames["07"] = "bartroom"

		l1interiors = {
			"00",
			"01",
			"02",
		}

		l2interiors = {
			"03",
			"04"
		}

		l3interiors = {
			"05",
			"06"
		}

		l4interiors = {
			"00",
			"01",
			"02",
			"07"
		}

		l5interiors = {
			"03",
			"04"
		}

		l6interiors = {
			"05",
			"06"
		}

		l7interiors = {
			"00",
			"01",
			"02",
			"07"
		}

		interiorReplace = {}
		
		function tbl.Level.RandomInteriors(LoadFile, InitFile, Level)
			if Level == 1 then
				DebugPrint("Setting up random interiors for level 1")
				interiorReplace = {}
				local tmpl1interiors = {table.unpack(l1interiors)}
				for i = 1, #l1interiors do
					interiorReplace[l1interiors[i]] = GetRandomFromTbl(tmpl1interiors, true)
				end
			elseif Level == 2 then
				DebugPrint("Setting up random interiors for level 2")
				interiorReplace = {}
				local tmpl2interiors = {table.unpack(l2interiors)}
				for i = 1, #l2interiors do
					interiorReplace[l2interiors[i]] = GetRandomFromTbl(tmpl2interiors, true)
				end
			elseif Level == 3 then
				DebugPrint("Setting up random interiors for level 3")
				interiorReplace = {}
				local tmpl3interiors = {table.unpack(l3interiors)}
				for i = 1, #l3interiors do
					interiorReplace[l3interiors[i]] = GetRandomFromTbl(tmpl3interiors, true)
				end
			elseif Level == 4 then
				DebugPrint("Setting up random interiors for level 4")
				interiorReplace = {}
				local tmpl4interiors = {table.unpack(l4interiors)}
				for i = 1, #l4interiors do
					interiorReplace[l4interiors[i]] = GetRandomFromTbl(tmpl4interiors, true)
				end
			elseif Level == 5 then
				DebugPrint("Setting up random interiors for level 5")
				interiorReplace = {}
				local tmpl5interiors = {table.unpack(l5interiors)}
				for i = 1, #l5interiors do
					interiorReplace[l5interiors[i]] = GetRandomFromTbl(tmpl5interiors, true)
				end
			elseif Level == 6 then
				DebugPrint("Setting up random interiors for level 6")
				interiorReplace = {}
				local tmpl6interiors = {table.unpack(l6interiors)}
				for i = 1, #l6interiors do
					interiorReplace[l6interiors[i]] = GetRandomFromTbl(tmpl6interiors, true)
				end
			elseif Level == 7 then
				DebugPrint("Setting up random interiors for level 7")
				interiorReplace = {}
				local tmpl7interiors = {table.unpack(l7interiors)}
				for i = 1, #l7interiors do
					interiorReplace[l7interiors[i]] = GetRandomFromTbl(tmpl7interiors, true)
				end
			end
			local oldName
			local newName
			for k,v in pairs(interiorReplace) do
				oldName = interiorNames[k]
				newName = interiorNames[v]
				DebugPrint("Replacing " .. oldName .. " with " .. newName .. " for random interiors")
				LoadFile = LoadFile:gsub("GagSetInterior%s*%(%s*\"" .. oldName .. "\"", "GagSetInterior(\"" .. newName .. "\"")
			end
			return LoadFile, InitFile
		end
	end
end