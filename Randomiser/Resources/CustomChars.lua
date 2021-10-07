if IsModEnabled("RandomiserChars") then
	if Exists("/GameData/CustomChars", false, true) then
		local CustomCharFiles = {}
		GetFiles(CustomCharFiles, "/GameData/CustomChars/", {".p3d"})
		DebugPrint("Custom Chars: Found " .. #CustomCharFiles .. " custom char files.")
		
		CustomChars = {}
		for i = #CustomCharFiles, 1, -1 do
			local Path = CustomCharFiles[i]
			local Name = RemoveFileExtension(GetFileName(Path))
			if not endsWith(Name, "_m") then
				DebugPrint("Could not load custom char " .. Name .. " due to missing invalid file name. File names must end \"_m\".")
			else
				local CompositeDrawableName = GetCompositeDrawableName(ReadFile(Path))
				if CompositeDrawableName == nil then
					DebugPrint("Could not load custom char " .. Name .. " due to missing Composite Drawable chunk.")
				else
					RandomCharP3DPool[#RandomCharP3DPool + 1] = Path
					RandomPedPool[#RandomPedPool + 1] = P3D.CleanP3DString(CompositeDrawableName):sub(1, -3)
					CustomChars[Name] = Path
					DebugPrint("Loaded custom char " .. Name .. " with Composite Drawable " .. CompositeDrawableName)
				end
			end
		end
		RandomPedPoolN = #RandomPedPool
	else
		if not Confirm("You have Custom Chars enabled without the RandomiserChars folder. Custom Chars will not work without this.\n\nTo continue loading the game press OK, to close press Cancel.") then
			os.exit()
		end
		Settings.CustomChars = false
	end
else
	if not Confirm("You have Custom Chars enabled without the RandomiserChars framework. Custom Chars will not work without this.\n\nTo continue loading the game press OK, to close press Cancel.") then
		os.exit()
	end
	Settings.CustomChars = false
end