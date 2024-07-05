local math_random = math.random
local string_sub = string.sub
local table_remove = table.remove
local table_unpack = table.unpack

local RandomPedestrians = Module("Random Pedestrians", "RandomPedestrians")

local AmbientCharacters

local function ReplaceCharacter(Path, P3DFile)
	local ReplaceP3D = P3D.P3DFile(AmbientCharacters[Path])
	
	print("Handling ambient character: " .. Path)
	
	return P3DUtils.ReplaceCharacter(P3DFile, ReplaceP3D)
end

RandomPedestrians:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	RandomPedestrians.Handlers.P3D = {}
	AmbientCharacters = {}
	
	local pedPool = {table_unpack(CharNames)}
	
	for Function, Index in LevelInit:GetFunctions(nil, true) do
		local name = Function.Name:lower()
		if name == "addped" then
			LevelInit:RemoveFunction(Index)
		elseif name == "createpedgroup" then
			for j=1,7 do
				local randomPedIndex = math_random(#pedPool)
				local randomPed = pedPool[randomPedIndex]
				table_remove(pedPool, randomPedIndex)
				if #pedPool == 0 then
					pedPool = {table_unpack(CharNames)}
				end
				
				LevelInit:InsertFunction(Index + 1, "AddPed", {randomPed, 1})
			end
		elseif name == "addambientcharacter" then
			local char = Function.Arguments[1]
			if #char > 6 then
				char = string_sub(char, 1, 6)
			end
			local path = "art\\chars\\" .. char .. "_m.p3d"
			AmbientCharacters[path] = CharP3DFiles[math_random(CharCount)]
			print("Replacing ambient character \"" .. char .. "\" with: " .. AmbientCharacters[path])
			RandomPedestrians:AddP3DHandler(path, ReplaceCharacter)
		end
	end
	
	return true
end)

return RandomPedestrians