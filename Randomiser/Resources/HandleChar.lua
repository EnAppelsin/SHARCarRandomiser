local Path = "/GameData/" .. GetPath();

if Settings.RandomCharacter and OrigChar and RandomChar and string.match(Path, OrigChar .. "%.cho") and (not Settings.RandomAnims)then
	local NewFile = ReadFile(Path);
	NewFile = string.gsub(NewFile, "skeleton%s\"" .. OrigChar .. "\"", "skeleton \"" .. RandomChar .. "\"")
	Output(NewFile)
end


--Random Animations
function string.split(str,knife)
	local t,index = {},1
	for i = 1,#str do
		if str:sub(i,i) == knife then
			table.insert(t,str:sub(index,i))
			index = i
		elseif i == #str then
			table.insert(t,str:sub(index,i))
		end
	end
	for k,v in pairs(t) do t[k] = v:gsub(knife,"") end
	return t,#t
end

if Settings.RandomAnims then
	local CharName, l = string.split("/GameData/" .. GetPath(),"/")
	CharName = CharName[l]:gsub(".cho","")

	anims = {
		{"surf_in surf_cycle surf_out", "surfing"},
		{"get_into_car_close_door get_into_car_close_door get_out_of_car_open_door_high get_out_of_car_open_door get_out_of_car get_into_car_close_door get_into_car_close_door get_into_car_close_door get_into_car get_into_car_open_door get_into_car_close_door get_out_of_car" ..
				"get_out_of_car_open_door get_out_of_car_close_door get_into_car_close_door_high " ..
				"get_into_car_open_door_high get_into_car_high get_out_of_car_close_door_high " ..
				"get_out_of_car_open_door_high get_out_of_car_high","entering and leaving vehicle passanger"},
		{"jump_idle_take_off","jump take off" },
		{"jump_idle_in_air", "jump"},
		{"jump_idle_land", "jump landing"},
		{"jump_dash_in_air", "double jump"},
		{"stomp_antic stomp_in_air stomp_land", "ground pound"},
		{"jump_kick","jump kick"},
		{"victory_small","small celebration"},
		{"victory_large", "big celebration" },
		{"loco_dash", "dash" },
		{"loco_run", "run" },
		{"loco_walk", "walk" },
		{"loco_idle_rest", "rest" },
		{"break", "kick" },
		{"hit_switch" ,"hit switch" },
		{"hit_switch_quick" ,"hit switch quickly" },
		{"jump_dash_in_air", "jump dash in air" },
		{"break","break" },
		{"dialogue_thinking", "thinking"},
		{"dialogue_hands_on_hips", "hand on hip"},
		{"dialogue_shaking_fist", "shaking fist" },
		{"dialogue_scratch_head", "scrath head" },
		{"dialogue_yes", "dialogue yes" },
		{"dialogue_no", "dialogue no" },
		{"dialogue_cross_arms", "cross arms" },
		{"dialogue_open_arm_hand_gesture", "open arm gesture" },
		{"dialogue_hands_in_air", "hands in air" },
		{"dialogue_shake_hand_in_air", "hand in air" },
		{"get_into_car_driver get_into_car_open_door_driver get_into_car_close_door_driver " ..
			"get_out_of_car_driver get_out_of_car_open_door_driver get_out_of_car_close_door_driver " ..
			"get_into_car_close_door_high_driver get_into_car_open_door_high_driver get_into_car_high_driver " ..
			"get_out_of_car_close_door_high_driver get_out_of_car_open_door_high_driver hom_get_out_of_car_open_door_high_driver " ..
			"get_out_of_car_high_driver","entering and leaving vehicle driver" },
		{"flail", "flail" },
		{"get_up", "get up" }
	}

	file = ChoreoFile
	if  Path:sub(21,21) ~= "n" then
		file = ReadFile("/GameData/art/chars/choreo.cho")
		if Settings.RandomCharacter and OrigChar and RandomChar and string.match(Path, OrigChar .. "%.cho") then
			file = file:gsub("CHARACTER_NAME",RandomChar)
		else
			file = file:gsub("CHARACTER_NAME",CharName)
		end
		for i = 1, #anims do
			code = ({"hom_","brt_","lsa_","mrg_","apu_"})[math.random(1,5)]
			if string.find(anims[i][1], " ") then
				moreanims = string.split(anims[i][1]," ")
				for j = 1, #moreanims do
					print(moreanims[j])
					file = file:gsub("\""..moreanims[j]:upper().."\"", "\""..code..moreanims[j].."\"")
				end
			else 
				file = file:gsub("\""..anims[i][1]:upper().."\"", "\""..code..anims[i][1].."\"")
			end
		end
	else
		file = ReadFile(Path)
	end
	
	Output(file)
end