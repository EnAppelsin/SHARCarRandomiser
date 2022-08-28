local Module = {}

Module.Setting = nil --"RandomCouch"
Module.Priority = 5

Module.P3DFilters = {
	"art/frontend/scrooby/resource/pure3d/homer.p3d",
	"art/frontend/scrooby/resource/pure3d/homer_?.p3d",
}
function Module.HandleP3D(GamePath, P3DFile)
	local ReplacePed = CharP3DFiles[math.random(CharCount)]
	print("Replacing couch character with: " .. ReplacePed)
	
	local ReplaceP3D = P3D.P3DFile(ReplacePed)
	local GlobalP3D = P3D.P3DFile("/GameData/art/chars/global.p3d")
	
	local SkeletonChunk = P3DFile:GetChunk(P3D.Identifiers.Skeleton)
	local AnimationChunk = P3DFile:GetChunk(P3D.Identifiers.Animation)
	local ScenegraphChunk = P3DFile:GetChunk(P3D.Identifiers.Scenegraph)
	local OldFrameControllerChunk = P3DFile:GetChunk(P3D.Identifiers.Old_Frame_Controller)
	local MultiControllerChunk = P3DFile:GetChunk(P3D.Identifiers.Multi_Controller)
	
	for texture in GlobalP3D:GetChunks(P3D.Identifiers.Texture, true) do
		ReplaceP3D:AddChunk(texture, 1)
	end
	
	local addedAnim = false
	local addedOldFrameController = false
	local addedMultiController = false
	for idx, chunk in ReplaceP3D:GetChunksIndexed(nil, true) do
		local identifier = chunk.Identifier
		if identifier == P3D.Identifiers.Animation then
			ReplaceP3D.Chunks[idx] = AnimationChunk
			addedAnim = true
		elseif identifier == P3D.Identifiers.Old_Frame_Controller then
			ReplaceP3D.Chunks[idx] = OldFrameControllerChunk
			addedOldFrameController = true
		elseif identifier == P3D.Identifiers.Multi_Controller then
			ReplaceP3D.Chunks[idx] = MultiControllerChunk
			ReplaceP3D:AddChunk(ScenegraphChunk, idx)
			addedMultiController = true
		elseif identifier == P3D.Identifiers.Shader then
			if chunk.Name == "eyeball_m" then
				local tex = chunk:GetParameter("TEX")
				if tex and tex.Value:sub(-2) == ".0" then
					tex.Value = tex.Value:sub(1, -3) .. ".3"
				end
			end
			
			if not addedAnim then
				ReplaceP3D:AddChunk(AnimationChunk, idx + 1)
				addedAnim = true
			end
		elseif identifier == P3D.Identifiers.Skeleton then
			chunk.Name = "Motion_Root"
			chunk.Chunks[1].Name = "Motion_Root"
		elseif identifier == P3D.Identifiers.Composite_Drawable then
			chunk.Name = "Motion_Root"
			chunk.SkeletonName = "Motion_Root"
		elseif identifier == P3D.Identifiers.Skin then
			chunk.SkeletonName = "Motion_Root"
		end
	end
	if not addedOldFrameController then
		if addedMultiController then
			ReplaceP3D:AddChunk(OldFrameControllerChunk, #ReplaceP3D.Chunks - 1)
		else
			ReplaceP3D:AddChunk(OldFrameControllerChunk)
		end
	end
	if not addedMultiController then
		ReplaceP3D:AddChunk(ScenegraphChunk)
		ReplaceP3D:AddChunk(MultiControllerChunk)
	end
	
	-- T-Pose Easter Egg
	if math.random(20) == 1 then
		for idx, chunk in ReplaceP3D:GetChunksIndexed(nil, true) do
			local identifier = chunk.Identifier
			if identifier == P3D.Identifiers.Animation or identifier == P3D.Identifiers.Animation_Group then
				ReplaceP3D:RemoveChunk(idx)
			end
		end
		MultiControllerChunk.Tracks = {}
	end
	
	P3DFile.Chunks = ReplaceP3D.Chunks
	return true
end

return Module