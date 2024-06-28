local math_random = math.random
local table_remove = table.remove
local table_unpack = table.unpack

local RandomPedenstrians = Module("Random Pedenstrians")

RandomPedenstrians:AddLevelHandler(function(LevelNumber, LevelLoad, LevelInit)
	local pedPool = {table_unpack(CharNames)}
	
	local functions = LevelInit.Functions
	
	for i=#functions,1,-1 do
		local funcName = functions[i].Name:lower()
		if funcName == "addped" then
			table_remove(functions, i)
		elseif funcName == "createpedgroup" then
			for j=1,7 do
				local randomPedIndex = math_random(#pedPool)
				local randomPed = pedPool[randomPedIndex]:sub(1,-3)
				table_remove(pedPool, randomPedIndex)
				if #pedPool == 0 then
					pedPool = {table_unpack(CharNames)}
				end
				
				LevelInit:InsertFunction(i + 1, "AddPed", {randomPed, 1})
			end
		end
	end
	
	return true
end)

return RandomPedenstrians