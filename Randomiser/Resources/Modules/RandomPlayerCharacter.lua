local string_sub = string.sub

local RandomPlayerCharacter = Module("Random Player Character", "RandomPlayerCharacter", 4)

local function ReplaceCharacter(Path, P3DFile)
	RandomPlayerCharacter.Handlers.P3D = {}
	
	return P3DUtils.ReplaceCharacter(P3DFile)
end

RandomPlayerCharacter:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	for i=1,#LevelInit.Functions do
		local func = LevelInit.Functions[i]
		local name = func.Name:lower()
		if name == "addcharacter" then
			local char = func.Arguments[1]
			if #char > 6 then
				char = string_sub(char, 1, 6)
			end
			RandomPlayerCharacter:AddP3DHandler("art/chars/" .. char .. "_m.p3d", ReplaceCharacter)
			RandomPlayerCharacter:AddP3DHandler("art/chars/" .. string_sub(char, 1, 1) .. "_*_m.p3d", ReplaceCharacter)
			break
		end
	end
	return false
end)

return RandomPlayerCharacter