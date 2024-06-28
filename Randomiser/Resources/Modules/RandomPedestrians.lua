local math_random = math.random
local string_sub = string.sub
local table_remove = table.remove
local table_unpack = table.unpack

local RandomPedestrians = Module("Random Pedestrians")

local function ReplaceCharacter(Path, P3DFile)
	return P3DUtils.ReplaceCharacter(P3DFile)
end

RandomPedestrians:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	RandomPedestrians.Handlers.P3D = {}
	
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
				local randomPed = pedPool[randomPedIndex]:sub(1,-3)
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
			RandomPedestrians:AddP3DHandler("art/chars/" .. char .. "_m.p3d", ReplaceCharacter)
		end
	end
	
	return true
end)

return RandomPedestrians