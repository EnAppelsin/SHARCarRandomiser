P3DUtils = {}

local assert = assert
local print = print
local math_random = math.random
local string_format = string.format
local string_match = string.match
local type = type

function P3DUtils.ReplaceCharacter(OrigP3D, ReplaceP3D)
	assert(type(OrigP3D) == "table", "OrigP3D (Arg #1) must be a table.")
	assert(type(ReplaceP3D) == "table", "Replace (Arg #2) must be a table.")
	
	local OrigCompositeDrawable = OrigP3D:GetChunk(P3D.Identifiers.Composite_Drawable)
	if not OrigCompositeDrawable then
		print("Failed to find composite drawable in original character")
		return false
	end
	local OrigSkeleton = OrigP3D:GetChunk(P3D.Identifiers.Skeleton)
	if not OrigSkeleton then
		print("Failed to find skeleton in original character")
		return false
	end
	
	local CompositeDrawable = ReplaceP3D:GetChunk(P3D.Identifiers.Composite_Drawable)
	if not CompositeDrawable then
		print("Failed to find composite drawable in replace character")
		return false
	end
	local Skeleton = ReplaceP3D:GetChunk(P3D.Identifiers.Skeleton)
	if not Skeleton then
		print("Failed to find skeleton in replace character")
		return false
	end
	local MultiController = ReplaceP3D:GetChunk(P3D.Identifiers.Multi_Controller)
	if MultiController then
		MultiController.Name = OrigCompositeDrawable.Name:sub(1, -3)
	end
	
	CompositeDrawable.Name = OrigCompositeDrawable.Name
	CompositeDrawable.SkeletonName = OrigCompositeDrawable.SkeletonName
	
	Skeleton.Name = OrigSkeleton.Name
	
	for chunk in ReplaceP3D:GetChunks(P3D.Identifiers.Skin) do
		chunk.SkeletonName = Skeleton.Name
	end
	
	OrigP3D.Chunks = ReplaceP3D.Chunks
	return true
end

local CarRenameChunks = {
	[P3D.Identifiers.Multi_Controller] = true,
	[P3D.Identifiers.Physics_Object] = true,
	[P3D.Identifiers.Collision_Object] = true,
	[P3D.Identifiers.Collision_Object] = true,
}
local RemoveAllWheels = {
	["frink_v"] = true,
	["honor_v"] = true,
	["hbike_v"] = true,
	["witchcar"] = true,
	["ship"] = true,
	["mono_v"] = true,
}
local RemoveFrontWheels = {
	["rocke_v"] = true,
}
local AllWheelJoints = {
	["w0"] = true,
	["w1"] = true,
	["w2"] = true,
	["w3"] = true,
}
local FrontWheelJoints = {
	["w2"] = true,
	["w3"] = true,
}
local RearWheelJoints = {
	["w0"] = true,
	["w1"] = true,
}
function P3DUtils.ReplaceCar(OrigP3D, ReplaceP3D)
	assert(type(OrigP3D) == "table", "OrigP3D (Arg #1) must be a table.")
	assert(type(ReplaceP3D) == "table", "Replace (Arg #2) must be a table.")
	
	local OrigCompositeDrawable = OrigP3D:GetChunk(P3D.Identifiers.Composite_Drawable)
	if not OrigCompositeDrawable then
		print("Failed to find composite drawable in original car")
		return false
	end
	local OrigName = OrigCompositeDrawable.Name
	
	local FollowCameraData = OrigP3D:GetChunk(P3D.Identifiers.Follow_Camera_Data)
	local CamIndex = FollowCameraData and FollowCameraData.Index % 512 or 96
	if CamIndex > 256 then
		CamIndex = CamIndex - 256
	end
	
	local CompositeDrawable = ReplaceP3D:GetChunk(P3D.Identifiers.Composite_Drawable)
	if not CompositeDrawable then
		print("Failed to find composite drawable in replace car")
		return false
	end
	local ReplaceName = CompositeDrawable.Name
	CompositeDrawable.Name = OrigName
	
	local Skeleton = ReplaceP3D:GetChunk(P3D.Identifiers.Skeleton, false, CompositeDrawable.SkeletonName)
	if not Skeleton then
		print("Failed to find skeleton in replace car")
		return false
	end
	
	local CompositeDrawablePropList = CompositeDrawable:GetChunk(P3D.Identifiers.Composite_Drawable_Prop_List)
	if not CompositeDrawablePropList then
		print("Failed to find composite drawable prop list in replace car")
		return false
	end
	
	for chunk in ReplaceP3D:GetChunks() do
		if CarRenameChunks[chunk.Identifier] then
			if string_match(chunk.Name, "BV$") then
				chunk.Name = OrigName .. "BV"
			else
				chunk.Name = OrigName
			end
		elseif chunk.Identifier == P3D.Identifiers.Follow_Camera_Data then
			chunk.Index = chunk.Index % 512 > 256 and (CamIndex + 256) or CamIndex
		elseif chunk.Identifier == P3D.Identifiers.Old_Frame_Controller and chunk.HierarchyName == ReplaceName then
			chunk.HierarchyName = OrigName
		end
	end
	
	local changedJointsN = 0
	local newJointIndexes = {}
	if RemoveAllWheels[OrigName] then
		if RemoveAllWheels[ReplaceName] then
			-- Huzzah
		elseif RemoveFrontWheels[ReplaceName] then
			-- Orig has no wheels, replace has no front wheels, add rear wheels
			for idx, joint in Skeleton:GetChunksIndexed(P3D.Identifiers.Skeleton_Joint, true) do
				if RearWheelJoints[joint.Name] then
					local newJoint = P3D.SkeletonJointP3DChunk(joint.Name, joint.Parent, joint.DOF, joint.FreeAxis, joint.PrimaryAxis, joint.SecondaryAxis, joint.TwistAxis, joint.RestPose)
					joint.Name = "_" .. joint.Name
					changedJointsN = changedJointsN + 1
					newJointIndexes[idx - 1] = #Skeleton.Chunks
					Skeleton:AddChunk(newJoint)
				end
			end
		else
			-- Orig has no wheels, add all wheels
			for idx, joint in Skeleton:GetChunksIndexed(P3D.Identifiers.Skeleton_Joint, true) do
				if AllWheelJoints[joint.Name] then
					local newJoint = P3D.SkeletonJointP3DChunk(joint.Name, joint.Parent, joint.DOF, joint.FreeAxis, joint.PrimaryAxis, joint.SecondaryAxis, joint.TwistAxis, joint.RestPose)
					joint.Name = "_" .. joint.Name
					changedJointsN = changedJointsN + 1
					newJointIndexes[idx - 1] = #Skeleton.Chunks
					Skeleton:AddChunk(newJoint)
				end
			end
		end
	elseif RemoveFrontWheels[OrigName] then
		if RemoveFrontWheels[ReplaceName] then
			-- Huzzah
		elseif RemoveAllWheels[ReplaceName] then
			-- Orig has no front wheels, replace has no wheels, remove wheels
			P3DUtils.RemoveChunksWithName(CompositeDrawablePropList, { ["wShape0"] = true, ["wShape1"] = true, ["wShape2"] = true, ["wShape3"] = true }, P3D.Identifiers.Composite_Drawable_Prop)
		else
			-- Orig has no front wheels, add front wheels
			for idx, joint in Skeleton:GetChunksIndexed(P3D.Identifiers.Skeleton_Joint, true) do
				if FrontWheelJoints[joint.Name] then
					local newJoint = P3D.SkeletonJointP3DChunk(joint.Name, joint.Parent, joint.DOF, joint.FreeAxis, joint.PrimaryAxis, joint.SecondaryAxis, joint.TwistAxis, joint.RestPose)
					joint.Name = "_" .. joint.Name
					changedJointsN = changedJointsN + 1
					newJointIndexes[idx - 1] = #Skeleton.Chunks
					Skeleton:AddChunk(newJoint)
				end
			end
		end
	else
		if RemoveAllWheels[ReplaceName] then
			-- Orig has all wheels, replace has no wheels, remove wheels
			P3DUtils.RemoveChunksWithName(CompositeDrawablePropList, { ["wShape0"] = true, ["wShape1"] = true, ["wShape2"] = true, ["wShape3"] = true }, P3D.Identifiers.Composite_Drawable_Prop)
		elseif RemoveFrontWheels[ReplaceName] then
			-- Orig has all wheels, replace has no front wheels, remove wheels
			P3DUtils.RemoveChunksWithName(CompositeDrawablePropList, { ["wShape2"] = true, ["wShape3"] = true }, P3D.Identifiers.Composite_Drawable_Prop)
		end
	end
	
	if changedJointsN > 0 then
		for CollisionObject in ReplaceP3D:GetChunks(P3D.Identifiers.Collision_Object) do
			for CollisionVolume in CollisionObject:GetChunks(P3D.Identifiers.Collision_Volume) do
				for SubVolume in CollisionVolume:GetChunks(P3D.Identifiers.Collision_Volume) do
					local newIndex = newJointIndexes[SubVolume.ObjectReferenceIndex]
					if newIndex then
						SubVolume.ObjectReferenceIndex = newIndex
					end
				end
			end
		end
		for OldFrameController in ReplaceP3D:GetChunks(P3D.Identifiers.Old_Frame_Controller) do
			if OldFrameController.HierarchyName == OrigName then
				local Animation = ReplaceP3D:GetChunk(P3D.Identifiers.Animation, false, OldFrameController.AnimationName)
				for AnimationGroupList in Animation:GetChunks(P3D.Identifiers.Animation_Group_List) do
					for AnimationGroup in AnimationGroupList:GetChunks(P3D.Identifiers.Animation_Group) do
						local newIndex = newJointIndexes[AnimationGroup.GroupId]
						if newIndex then
							AnimationGroup.GroupId = newIndex
						end
					end
				end
			end
		end
	end
	
	OrigP3D.Chunks = ReplaceP3D.Chunks
	return true
end

function P3DUtils.RemoveChunksWithName(Parent, RemoveNames, Identifier)
	for idx, chunk in Parent:GetChunksIndexed(Identifier, true) do
		if RemoveNames[chunk.Name] then
			Parent:RemoveChunk(idx)
		end
	end
end