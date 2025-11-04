local FixAudiTT = Module("Fix Audi TT", nil, 1)

FixAudiTT:AddCONHandler("scripts/cars/tt.con", function(Path, CON)
	CON:AddFunction("SetCharactersVisible", 1)
	CON:AddFunction("SetDriver", "none")
	CON:AddFunction("SetHasDoors", 0)
	CON:AddFunction("SetIrisTransition", 1)
	CON:AddFunction("SetShadowAdjustments", {-0.65, -0.45, -0.6, 0.5, -0.6, 0.15, -0.6, 0.7})
	
	return true
end)

FixAudiTT:AddP3DHandler("art/cars/tt.p3d", function(Path, P3DFile)
	local Skeleton = P3DFile:GetChunk(P3D.Identifiers.Skeleton)
	if not Skeleton then
		return false
	end
	
	Skeleton:AddChunk(P3D.SkeletonJointP3DChunk("dl", 0, -1, -1, -1, -1, -1, P3D.Matrix(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, -0.18, -0.0539, 0.0639, 1)))
	Skeleton:AddChunk(P3D.SkeletonJointP3DChunk("pl", 0, -1, -1, -1, -1, -1, P3D.Matrix(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0.55, -0.0539, 0.0639, 1)))
	
	return true
end)

FixAudiTT:AddSPTHandler("sound/scripts/car_tune.spt", function(Path, SPT)
	local changed = false
	
	for carSoundParameters in SPT:GetClasses("carSoundParameters") do
		for method, index in carSoundParameters:GetMethods(true) do
			local name = method.Name
			if name == "SetEngineClipName" or name == "SetEngineIdleClipName" then
				if method.Parameters[1] == "tt" then
					method.Parameters[1] = "apu_car"
					changed = true
				end
			end
		end
	end
	
	return changed
end)

return FixAudiTT