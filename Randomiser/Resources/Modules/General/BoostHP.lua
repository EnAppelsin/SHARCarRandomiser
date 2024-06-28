local BoostHP = Module("Boost HP", "BoostHP", 1000)

local BoostHPValue = Settings.BoostHPValue

BoostHP:AddCONHandler("*.con", function(Path, CON)
	local functions = CON.functions
	
	for i=#functions,1,-1 do
		local func = functions[i]
		if func.Name:lower() == "sethitpoints" then
			if func.Arguments[1] < BoostHPValue then
				func.Arguments[1] = BoostHPValue
				return true
			end
			return false
		end
	end
	
	if BoostHPValue > 2 then
		CON:AddFunction("SetHitPoints", BoostHPValue)
		
		return true
	end
	
	return false
end)

return BoostHP