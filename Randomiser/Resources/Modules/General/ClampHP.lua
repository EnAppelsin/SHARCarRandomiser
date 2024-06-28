local ClampHP = Module("Clamp HP", "ClampHP", 1000)

local MinimumHP = Settings.MinimumHP
local MaximumHP = Settings.MaximumHP

ClampHP:AddCONHandler("*.con", function(Path, CON)
	local functions = CON.functions
	
	for i=#functions,1,-1 do
		local func = functions[i]
		if func.Name:lower() == "sethitpoints" then
			local hp = tonumber(func.Arguments[1])
			if hp < MinimumHP then
				print("Increasing HP to " .. MinimumHP .. " for: " .. Path)
				func.Arguments[1] = MinimumHP
				return true
			end
			if hp > MaximumHP then
				print("Decreasing HP to " .. MaximumHP .. " for: " .. Path)
				func.Arguments[1] = MaximumHP
				return true
			end
			return false
		end
	end
	
	if 2 < MinimumHP then
		print("Increasing HP to " .. MinimumHP .. " for: " .. Path)
		CON:AddFunction("SetHitPoints", MinimumHP)
		return true
	end
	
	if 2 > MaximumHP then
		print("Decreasing HP to " .. MaximumHP .. " for: " .. Path)
		CON:AddFunction("SetHitPoints", MaximumHP)
		return true
	end
	
	return false
end)

return ClampHP