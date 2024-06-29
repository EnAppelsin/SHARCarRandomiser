local ClampHP = Module("Clamp HP", "ClampHP", 1000)

local MinimumHP = Settings.MinimumHP
local MaximumHP = Settings.MaximumHP

local DefaultHP = 2 -- Default HP if `SetHitPoints` isn't called

if Settings[ClampHP.Setting] and MaximumHP < MinimumHP then
	Alert("You cannot have \"Maximum HP\" lower than \"Minimum HP\".")
	os.exit()
end

ClampHP:AddCONHandler("*.con", function(Path, CON)
	local functions = CON.Functions
	
	for i=#functions,1,-1 do
		local func = functions[i]
		if func.Name:lower() == "sethitpoints" then
			local hp = func.Arguments[1]
			if hp < MinimumHP then
				print("Increasing HP to " .. MinimumHP .. " from " .. hp .. " for: " .. Path)
				func.Arguments[1] = MinimumHP
				return true
			end
			if hp > MaximumHP then
				print("Decreasing HP to " .. MaximumHP .. " from " .. hp .. " for: " .. Path)
				func.Arguments[1] = MaximumHP
				return true
			end
			return false
		end
	end
	
	if DefaultHP < MinimumHP then
		print("Increasing HP to " .. MinimumHP .. " from " .. DefaultHP .. " for: " .. Path)
		CON:AddFunction("SetHitPoints", MinimumHP)
		return true
	end
	
	if DefaultHP > MaximumHP then
		print("Decreasing HP to " .. MaximumHP .. " from " .. DefaultHP .. " for: " .. Path)
		CON:AddFunction("SetHitPoints", MaximumHP)
		return true
	end
	
	return false
end)

return ClampHP