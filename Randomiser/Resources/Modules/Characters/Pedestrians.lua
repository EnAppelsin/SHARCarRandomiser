local math_random = math.random
local string_sub = string.sub
local table_remove = table.remove
local table_unpack = table.unpack

local RandomPedestrians = Module("Random Pedestrians", "RandomPedestrians")

local AmbientCharacters

local function ReplaceCharacter(Path, P3DFile)
	local ReplaceP3D = P3D.P3DFile(AmbientCharacters[Path])
	
	return P3DUtils.ReplaceCharacter(P3DFile, ReplaceP3D)
end

RandomPedestrians:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	RandomPedestrians.Handlers.P3D = {}
	AmbientCharacters = {}
	
	local pedPool = {table_unpack(CharNames)}
	
	local functions = LevelInit.Functions
	for i=#functions,1,-1 do
		local func = functions[i]
		local name = func.Name:lower()
		if name == "addped" then
			table_remove(functions, i)
		elseif name == "createpedgroup" then
			for j=1,7 do
				local randomPedIndex = math_random(#pedPool)
				local randomPed = pedPool[randomPedIndex]
				table_remove(pedPool, randomPedIndex)
				if #pedPool == 0 then
					pedPool = {table_unpack(CharNames)}
				end
				
				LevelInit:InsertFunction(i + 1, "AddPed", {randomPed, 1})
			end
		elseif name == "addambientcharacter" then
			local char = func.Arguments[1]
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