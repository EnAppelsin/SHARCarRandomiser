local Path = "/GameData/" .. GetPath()

if Settings.RandomDialogue and (RandomDialoguePoolN > 0 or RCFDialoguePoolN > 0) then
	if RandomDialoguePoolN > 0 and RCFDialoguePoolN > 0 then
		if math.random(2) == 1 then
			local RedirectPath = RandomDialoguePool[math.random(RandomDialoguePoolN)]

			DebugPrint("Redirecting " .. Path .. " to " .. RedirectPath)

			Redirect(RedirectPath)
		else
			local DataEntry = GetRandomFromTbl(RCFDialoguePool)
			
			DebugPrint("Redirecting to RSD at " .. DataEntry.Position .. " in " .. DataEntry.Path)
			
			if Settings.SuperRandomDialogue then
				local msMinLength = Settings.SuperRandomDialogueMinLength
				local msMaxLength = math.max(msMinLength + 0.1, Settings.SuperRandomDialogueMaxLength)
				local msRange = math.log(msMaxLength) - msMinLength
				local msLength = math.exp(math.random() * msRange + msMinLength) * 1000
				local blockCount = math.ceil(msLength / 1.2)
				--local blockCount = (DataEntry.Size - 2048) / 20
				--blockCount = blockCount + math.random(0, 750)
				local data = {}
				data[1] = ReadFileOffset(DataEntry.Path, DataEntry.Position + 1, 2048)
				
				local i = 0
				while i < blockCount do
					local blocks = math.random(Settings.SuperRandomDialogueMinBlockLength, Settings.SuperRandomDialogueMaxBlockLength)
					DataEntry = GetRandomFromTbl(RCFDialoguePool)
					local offset = 20 * math.random(0, 10)
					data[#data + 1] = ReadFileOffset(DataEntry.Path, DataEntry.Position + 1 + 2048 + offset, math.min(20*blocks, DataEntry.Size - 2048 - offset))
					i = i + blocks
				end
				
				Output(table.concat(data))
			else
				DebugPrint("Redirecting to RSD at " .. DataEntry.Position .. " in " .. DataEntry.Path)
				Output(ReadFileOffset(DataEntry.Path, DataEntry.Position + 1, DataEntry.Size))
			end
		end
	elseif RandomDialoguePoolN > 0 then
		local RedirectPath = RandomDialoguePool[math.random(RandomDialoguePoolN)]

		DebugPrint("Redirecting " .. Path .. " to " .. RedirectPath)

		Redirect(RedirectPath)
	elseif RCFDialoguePoolN > 0 then
		local DataEntry = GetRandomFromTbl(RCFDialoguePool)
		
		if Settings.SuperRandomDialogue then
			local msMinLength = Settings.SuperRandomDialogueMinLength
			local msMaxLength = math.max(msMinLength + 0.1, Settings.SuperRandomDialogueMaxLength)
			local msRange = math.log(msMaxLength) - msMinLength
			local msLength = math.exp(math.random() * msRange + msMinLength) * 1000
			local blockCount = math.ceil(msLength / 1.2)
			--local blockCount = (DataEntry.Size - 2048) / 20
			--blockCount = blockCount + math.random(0, 750)
			local data = {}
			data[1] = ReadFileOffset(DataEntry.Path, DataEntry.Position + 1, 2048)
			
			local i = 0
			while i < blockCount do
				local blocks = math.random(Settings.SuperRandomDialogueMinBlockLength, Settings.SuperRandomDialogueMaxBlockLength)
				DataEntry = GetRandomFromTbl(RCFDialoguePool)
				local offset = 20 * math.random(0, 10)
				data[#data + 1] = ReadFileOffset(DataEntry.Path, DataEntry.Position + 1 + 2048 + offset, math.min(20*blocks, DataEntry.Size - 2048 - offset))
				i = i + blocks
			end
			
			Output(table.concat(data))
		else
			DebugPrint("Redirecting to RSD at " .. DataEntry.Position .. " in " .. DataEntry.Path)
			Output(ReadFileOffset(DataEntry.Path, DataEntry.Position + 1, DataEntry.Size))
		end
	end
elseif Settings.RandomMissions and Path:match("L%d") then
	if Exists(Path, true, false) then
		--File exists, leave it
		return
	else
		for i = 1, 7 do
			local tmp = Path:gsub("L(%d)", "L%1M" .. i)
			if Exists(tmp, true, false) then
				DebugPrint("Redirecting " .. Path .. " to " .. tmp)
				Redirect(tmp)
				return
			else
				local tmp = Path:gsub("L(%d)", "L%1R" .. i)
				if Exists(tmp, true, false) then
					DebugPrint("Redirecting " .. Path .. " to " .. tmp)
					Redirect(tmp)
					return
				else
					local tmp = Path:gsub("L(%d)", "L%1B" .. i)
					if Exists(tmp, true, false) then
						DebugPrint("Redirecting " .. Path .. " to " .. tmp)
						Redirect(tmp)
						return	
					end
				end
			end
		end
	end
	if IsModEnabled("RandomiserDialogue") then
		local RedirectPath = Path:gsub("/GameData/", "/GameData/RandomDialogue/")
		if Exists(RedirectPath, true, false) then
			DebugPrint("Redirecting " .. Path .. " to " .. RedirectPath)
			Redirect(RedirectPath)
		else
			for i = 1, 7 do
				local tmp = RedirectPath:gsub("L(%d)", "L%1M" .. i)
				if Exists(tmp, true, false) then
					DebugPrint("Redirecting " .. Path .. " to " .. tmp)
					Redirect(tmp)
					return
				else
					local tmp = RedirectPath:gsub("L(%d)", "L%1R" .. i)
					if Exists(tmp, true, false) then
						DebugPrint("Redirecting " .. Path .. " to " .. tmp)
						Redirect(tmp)
						return
					else
						local tmp = RedirectPath:gsub("L(%d)", "L%1B" .. i)
						if Exists(tmp, true, false) then
							DebugPrint("Redirecting " .. Path .. " to " .. tmp)
							Redirect(tmp)
							return
						end
					end
				end
			end
			DebugPrint("Redirecting " .. Path .. " to empty.rsd")
			Redirect(Paths.Resources .. "empty.rsd")
		end
	else
		DebugPrint("Redirecting " .. Path .. " to empty.rsd")
		Redirect(Paths.Resources .. "empty.rsd")
	end
end