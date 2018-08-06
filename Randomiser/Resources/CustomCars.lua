local function addCar(tbl, carName, carTune)
	local add = not ExistsInTbl(tbl, carName, false)
	if add then
		if carTune then
			cartunespt = cartunespt .. "\r\n" .. carTune
		end
		table.insert(tbl, carName)
		table.insert(CustomCarPool, carName)
		table.insert(RandomCarPoolPlayer, carName)
		table.insert(RandomCarPoolTraffic, carName)
		table.insert(RandomCarPoolMission, carName)
		table.insert(RandomCarPoolChase, carName)
		return true
	else
		return false
	end
end

if IsModEnabled("RandomiserCars") then
	if Exists("/GameData/CustomCars", false, true) then
		local loadedCars = {}
		local loadedSounds = {"snake_car", "bookb", "marge_car", "carhom", "krust_car", "bbman", "lisa_car", "famil", "bart_car", "scorp", "honor", "hbike", "frink", "comic_car", "lisa_v_car", "smith", "mrplo", "fone", "cletus_car", "apu_car", "plowk", "wiggum_car", "otto", "moe", "skinn", "homer_car", "zombi", "burns", "willi", "gramp", "gramR", "atv_car", "knigh_v_car", "mono_v_car", "oblit_v_car", "hype_v_car", "dune_v_car", "rocke_v_car", "cArmor_car", "cCellA_v", "cCellB_v", "cCellC_v", "cCellD_v", "cSedan_car", "cCola_car", "cCube_v", "cCurator_car", "cDonut_car", "cDuff_car", "cHears_car", "cKlimo_car", "cLimo_car", "cMilk_v", "cNerd_car", "cNonupV", "cPolice_car", "cVan_car", "huskaV", "compactA_car", "minivanA_v", "pickupA_car", "sedanA_v", "sedanB_v", "sportsA_car", "sportsB_car", "SUVB_car", "SUVA_car", "taxiA_car", "coffin_v", "ship_v", "hallo_v", "witchcar_v", "ambul_car", "burnsarm_car", "fishtruck", "garbage_car", "icecream_car", "istruck_v", "nuctruck_v", "pizza_car", "schoolbus", "votetruck_v", "glastruc_v", "cfirecar_v", "cBone_v", "brick_car", "snake_car", "bookb", "marge_car", "carhom", "krust_car", "bbman", "lisa_car", "famil", "bart_car", "scorp", "honor", "hbike", "frink", "comic_car", "lisa_v_car", "smith", "mrplo", "fone", "cletus_car", "apu_car", "plowk", "wiggum_car", "otto", "moe", "skinn", "homer_car", "zombi", "burns", "willi", "gramp", "gramR", "atv_car", "knigh_v_car", "mono_v_car", "oblit_v_car", "hype_v_car", "blank", "rocke_v_car", "cArmor_car", "cCellA_v", "cCellB_v", "cCellC_v", "cCellD_v", "cSedan_car", "cCola_car", "cCube_v", "cCurator_car", "cDonut_car", "cDuff_car", "cHears_car", "cKlimo_car", "cLimo_car", "cMilk_v", "cNerd_car", "cNonupV", "cPolice_car", "cVan_car", "compactA_car", "minivanA_v", "pickupA_car", "sedanA_v", "sedanB_v", "sportsA_car", "sportsB_car", "SUVB_car", "SUVA_car", "taxiA_car", "coffin_v", "ship_v", "hallo_v", "witchcar_v", "ambul_car", "burnsarm_car", "fishtruck", "garbage_car", "icecream_car", "istruck_v", "nuctruck_v", "pizza_car", "schoolbus", "votetruck_v", "glastruc_v", "cfirecar_v", "cBone_v", "brick_car", "fire", "snake_horn", "bookb_horn", "marge_horn", "carhom_horn", "krust_horn", "bbman_horn", "lisa_horn", "famil_horn", "bart_horn", "scorp_horn", "honor_horn", "frink_horn", "comic_horn", "smith_horn", "mrplo_horn", "fone_horn", "cletus_horn", "apu_horn", "plowk_horn", "siren", "otto_horn", "moe_horn", "skinn_horn", "homer_horn", "zombi_horn", "burns_horn", "willi_horn", "gramp_horn", "gramR_horn", "atv_horn", "knigh_horn", "mono_horn", "oblit_horn", "hype_v_horn", "dune_horn", "rocke_horn", "cArmor_car_horn", "cCellA_horn", "cCellB_horn", "cCellC_horn", "cCellD_horn", "cCola_horn", "cCube_v_horn", "cCurator_horn", "cDonut_horn", "cDuff_horn", "cKlimo_horn", "cLimo_horn", "cMilk_horn", "cNerd_horn", "cNonupV_horn", "cVan_horn", "huskaV_horn", "compactA_horn", "minivanA_horn", "pickupA_horn", "sedanA_v_horn", "sedanB_v_horn", "sportsA_horn", "sportsB_horn", "SUVB_horn", "horn", "ship_v_horn", "hallo_v_horn", "witchcar_v_horn", "ambul_car_horn", "burnsarm_horn", "fishtruck_horn", "garbage_horn", "icecream_horn", "nuctruck_v_horn", "schoolbus_horn", "votetruc_horn", "cfirecar_overlay", "brick_car_horn", "rocket", "generator", "cCellA_overlay", "cCellB_overlay", "cCellC_overlay", "cCellD_overlay", "cVan_overlay", "ship_overlay", "ice_cream_truck", "i_and_s_truck", "nuctruck_glow", "pizza_car_overlay", "vote_quimby"}
		for carname in cartunespt:gmatch("create carSoundParameters named (.-)\r\n") do
			table.insert(loadedCars, carname)
		end
		for carsound in carsoundspt:gmatch("create daSoundResourceData named (.-)\r\n") do
			if not ExistsInTbl(loadedSounds, carsound, false) then
				table.insert(loadedSounds, carsound)
			end
		end

		local customCarDirs = {}
		GetDirs(customCarDirs, "/GameData/CustomCars/")
		DebugPrint("Custom Cars: Found " .. #customCarDirs .. " custom car directories. Loading sounds.")
		
		for i = #customCarDirs, 1, -1 do
			local customCarName = customCarDirs[i]
			local customCarDir = "/GameData/CustomCars/" .. customCarName .. "/"
			DebugPrint("Custom Cars: Checking " .. customCarName)
			if not Exists(customCarDir .. customCarName .. ".p3d", true, false) then
				DebugPrint("Could not load Custom Car " .. customCarName .. " due to missing P3D model.")
				table.remove(customCarDirs, i)
			elseif not Exists(customCarDir .. customCarName .. ".con", true, false) then
				DebugPrint("Could not load Custom Car " .. customCarName .. " due to missing CON settings.")
				table.remove(customCarDirs, i)
			elseif not Exists(customCarDir .. "car_tune.spt", true, false) then
				DebugPrint("Could not load Custom Car " .. customCarName .. " due to missing car_tune.spt.")
				table.remove(customCarDirs, i)
			else
				if Exists(customCarDir .. "carsound.spt", true, false) then
					local customCarSoundSpt = ReadFile(customCarDir .. "carsound.spt"):gsub("\r\n", "\n"):gsub("\r", "\n"):gsub("\n", "\r\n")
					for carsound, carsounddata in customCarSoundSpt:gmatch("create daSoundResourceData named (.-)\r\n{\r\n(.-)}") do
						DebugPrint("Found sound named " .. carsound)
						if not ExistsInTbl(loadedSounds, carsound, false) then
							local fileName = carsounddata:match("AddFilename%s*%(%s*\"(.-)\"")
							if fileName then
								if Exists(customCarDir .. fileName, true, false) then
									table.insert(loadedSounds, carsound)
									CustomCarSounds[fileName] = customCarDir .. fileName
									carsoundspt = carsoundspt .. "\r\ncreate daSoundResourceData named " .. carsound .. "\r\n{\r\n" .. carsounddata .. "}"
									DebugPrint("Loaded custom car sound " .. carsound)
								else
									DebugPrint("Not loaded custom sound " .. carsound .. " from " .. customCarName .. " due to missing sound file")
								end
							else
								DebugPrint("Not loaded custom sound " .. carsound .. " from " .. customCarName .. " due to missing file name")
							end
						else
							DebugPrint("Not loaded custom sound " .. carsound .. " from " .. customCarName .. " due to conflict")
						end
					end
				else
					DebugPrint("No carsound.spt found for Custom Car " .. customCarName .. ".")
				end
			end
		end
		
		DebugPrint("Custom Cars: Loading cars.")
		
		for i = 1, #customCarDirs do
			local customCarName = customCarDirs[i]
			local customCarDir = "/GameData/CustomCars/" .. customCarName .. "/"
			
			local customCarTuneSpt = ReadFile(customCarDir .. "car_tune.spt"):gsub("\r\n", "\n"):gsub("\r", "\n"):gsub("\n", "\r\n")
			if not customCarTuneSpt == customCarTuneSpt:match("create carSoundParameters named " .. customCarName .. "\r\n{.-}") then
				DebugPrint("Could not load Custom Car " .. customCarName .. " due to invalid car_tune.spt.")
			else
				local add = true
				for engineClip in customCarTuneSpt:gmatch("SetEngineClipName%s*%(%s*\"(.-)\"") do
					if not ExistsInTbl(loadedSounds, engineClip, false) then
						add = false
						DebugPrint("Missing sound file " .. engineClip)
						break
					end
				end
				if add then
					for engineIdleClip in customCarTuneSpt:gmatch("SetEngineIdleClipName%s*%(%s*\"(.-)\"") do
						if not ExistsInTbl(loadedSounds, engineIdleClip, false) then
							add = false
							DebugPrint("Missing sound file " .. engineIdleClip)
							break
						end
					end
					if add then
						for damagedEngineClip in customCarTuneSpt:gmatch("SetDamagedEngineClipName%s*%(%s*\"(.-)\"") do
							if not ExistsInTbl(loadedSounds, damagedEngineClip, false) then
								add = false
								DebugPrint("Missing sound file " .. damagedEngineClip)
								break
							end
						end
						if add then
							for hornClip in customCarTuneSpt:gmatch("SetHornClipName%s*%(%s*\"(.-)\"") do
								if not ExistsInTbl(loadedSounds, hornClip, false) then
									add = false
									DebugPrint("Missing sound file " .. hornClip)
									break
								end
							end
							if add then
								for overlay in customCarTuneSpt:gmatch("SetOverlayClipName%s*%(%s*\"(.-)\"") do
									if not ExistsInTbl(loadedSounds, overlay, false) then
										add = false
										DebugPrint("Missing sound file " .. overlay)
										break
									end
								end
								if add then
									if addCar(loadedCars, customCarName, customCarTuneSpt) then
										DebugPrint("Added Custom Car " .. customCarName)
									else
										DebugPrint("Could not add Custom Car " .. customCarName .. " due to conflicts with existing cars.")
									end
								else
									DebugPrint("Could not load Custom Car " .. customCarName .. " due to missing overlay sound file.")
								end
							else
								DebugPrint("Could not load Custom Car " .. customCarName .. " due to missing horn clip sound file.")
							end
						else
							DebugPrint("Could not load Custom Car " .. customCarName .. " due to missing damaged engine clip sound file.")
						end
					else
						DebugPrint("Could not load Custom Car " .. customCarName .. " due to missing engine idle clip sound file.")
					end
				else
					DebugPrint("Could not load Custom Car " .. customCarName .. " due to missing engine clip sound file.")
				end
			end
		end
	else
		if not Confirm("You have Custom Cars enabled without the RandomiserCars folder. Custom Cars will not work without this.\n\nTo continue loading the game press OK, to close press Cancel.") then
			os.exit()
		end
		SettingCustomCars = false
	end
else
	if not Confirm("You have Custom Cars enabled without the RandomiserCars framework. Custom Cars will not work without this.\n\nTo continue loading the game press OK, to close press Cancel.") then
		os.exit()
	end
	SettingCustomCars = false
end