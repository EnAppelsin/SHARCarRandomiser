local math_random = math.random
local string_sub = string.sub

local RandomPlayerCharacter = Module("Random Player Character", "RandomPlayerCharacter", 4)

local PlayerCharacter

local function ReplaceCharacter(Path, P3DFile)
	RandomPlayerCharacter.Handlers.P3D = {}
	
	local ReplaceP3D = P3D.P3DFile(PlayerCharacter)
	
	return P3DUtils.ReplaceCharacter(P3DFile, ReplaceP3D)
end

RandomPlayerCharacter:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	local Function = LevelInit:GetFunction("AddCharacter")
	if Function then
		local char = Function.Arguments[1]
		if #char > 6 then
			char = string_sub(char, 1, 6)
		end
		PlayerCharacter = CharP3DFiles[math_random(CharCount)]
		print("Replacing player character with: " .. PlayerCharacter)
		RandomPlayerCharacter:AddP3DHandler("art\\chars\\" .. char .. "_m.p3d", ReplaceCharacter)
		RandomPlayerCharacter:AddP3DHandler("art\\chars\\" .. string_sub(char, 1, 1) .. "_*_m.p3d", ReplaceCharacter)
	end
	return false
end)

return RandomPlayerCharacter