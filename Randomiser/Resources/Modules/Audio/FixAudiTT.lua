local FixAudiTT = Module("Fix Audi TT", nil, 1)
local TTIndex = 97

FixAudiTT:AddCONHandler("scripts/cars/tt.con", function(Path, CON)
	CON:AddFunction("SetCharactersVisible", 1)
	CON:AddFunction("SetDriver", "none")
	CON:AddFunction("SetHasDoors", 0)
	CON:AddFunction("SetIrisTransition", 1)
	CON:AddFunction("SetShadowAdjustments", {-0.65, -0.45, -0.6, 0.5, -0.6, 0.15, -0.6, 0.7})
	
	return true
end)

FixAudiTT:AddP3DHandler("art/cars/tt.p3d", function(Path, P3DFile)
	local changed = false

	local Skeleton = P3DFile:GetChunk(P3D.Identifiers.Skeleton)
	if Skeleton then
		if Skeleton:GetChunk(P3D.Identifiers.Skeleton_Joint, false, "dl") == nil then
			Skeleton:AddChunk(P3D.SkeletonJointP3DChunk("dl", 0, -1, -1, -1, -1, -1, P3D.Matrix(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, -0.18, -0.0539, 0.0639, 1)))
			changed = true
		end
		if Skeleton:GetChunk(P3D.Identifiers.Skeleton_Joint, false, "pl") == nil then
			Skeleton:AddChunk(P3D.SkeletonJointP3DChunk("pl", 0, -1, -1, -1, -1, -1, P3D.Matrix(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0.55, -0.0539, 0.0639, 1)))
			changed = true
		end
	end
	
	local addCam = true
	for index, chunk in P3DFile:GetChunksIndexed(P3D.Identifiers.Follow_Camera_Data, true) do
		if chunk.Index % 256 == 19 then
			P3DFile:RemoveChunk(index)
			changed = true
		else
			addCam = false
		end
	end
	
	if addCam then
		P3DFile:AddChunk(P3D.FollowCameraDataP3DChunk(TTIndex, 180, 7.4331846, 5.4000015, P3D.Vector3(0, 0.5, 3)), 1)
		P3DFile:AddChunk(P3D.FollowCameraDataP3DChunk(TTIndex + 256, 180, 7.463185, 6.9, P3D.Vector3(0, 0.5, 3)), 2)
		changed = true
	end
	
	return changed
end)

FixAudiTT:AddSPTHandler("sound/scripts/car_tune.spt", function(Path, SPT)
	local ttCarSoundParameters = SPT:GetClass("carSoundParameters", false, "tt")
	if not ttCarSoundParameters then
		return false
	end
	
	local changed = false
	
	local engineClipMethod = ttCarSoundParameters:GetMethod(false, "SetEngineClipName")
	if engineClipMethod and engineClipMethod.Parameters[1] == "tt" then
		changed = true
		engineClipMethod.Parameters[1] = "apu_car"
	end
	
	local engineIdleClipMethod = ttCarSoundParameters:GetMethod(false, "SetEngineIdleClipName")
	if engineIdleClipMethod and engineIdleClipMethod.Parameters[1] == "tt" then
		changed = true
		engineIdleClipMethod.Parameters[1] = "apu_car"
	end
	
	return changed
end)

return FixAudiTT