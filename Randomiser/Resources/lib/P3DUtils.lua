P3DUtils = {}

local print = print
local string_format = string.format

function P3DUtils.ReplaceCharacter(P3DFile)
	local OrigCompositeDrawable = P3DFile:GetChunk(P3D.Identifiers.Composite_Drawable)
	if not OrigCompositeDrawable then
		print("Failed to find composite drawable in original character")
		return false
	end
	local OrigSkeleton = P3DFile:GetChunk(P3D.Identifiers.Skeleton)
	if not OrigSkeleton then
		print("Failed to find skeleton in original character")
		return false
	end
	local OrigMultiController = P3DFile:GetChunk(P3D.Identifiers.Multi_Controller)
	if not OrigMultiController then
		print("Failed to find multi controller in original character")
		return false
	end
	
	local ReplacePed = CharP3DFiles[math.random(CharCount)]
	print(string_format("Replacing \"%s\" with: %s", OrigCompositeDrawable.Name, ReplacePed))
	
	local ReplaceP3D = P3D.P3DFile(ReplacePed)
	
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
	if not MultiController then
		print("Failed to find multi controller in replace character")
		return false
	end
	
	CompositeDrawable.Name = OrigCompositeDrawable.Name
	CompositeDrawable.SkeletonName = OrigCompositeDrawable.SkeletonName
	
	Skeleton.Name = OrigSkeleton.Name
	
	MultiController.Name = OrigMultiController.Name
	
	for chunk in ReplaceP3D:GetChunks(P3D.Identifiers.Skin) do
		chunk.SkeletonName = Skeleton.Name
	end
	
	P3DFile.Chunks = ReplaceP3D.Chunks
	return true
end