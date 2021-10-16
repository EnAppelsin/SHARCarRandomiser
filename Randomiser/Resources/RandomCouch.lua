if Settings.RandomCouch then
	local PedN = math.random(#RandomCharP3DPool)
	local Ped = RandomCharP3DPool[PedN]

	local Path = "/GameData/" .. GetPath();
	local Original = ReadFile(Path)
	local ReplacePath = Ped
	local Replace = ReadFile(ReplacePath)
	local GlobalPath = "/GameData/art/chars/global.p3d"
	local Global = ReadFile(GlobalPath)
	
	local OriginalP3D = P3D.P3DChunk:new{Raw = Original}
	local ReplaceP3D = P3D.P3DChunk:new{Raw = Replace}
	local GlobalP3D = P3D.P3DChunk:new{Raw = Global}
	
	local Motion_Root_Label = P3D.MakeP3DString("Motion_Root")
	
	local SkeletonChunk = OriginalP3D:GetChunkAtIndex(OriginalP3D:GetChunkIndex(P3D.Identifiers.Skeleton))
	local AnimChunk = OriginalP3D:GetChunkAtIndex(OriginalP3D:GetChunkIndex(P3D.Identifiers.Animation))
	local ScenegraphChunk = OriginalP3D:GetChunkAtIndex(OriginalP3D:GetChunkIndex(P3D.Identifiers.Scenegraph))
	local OldFrameControllerChunk = OriginalP3D:GetChunkAtIndex(OriginalP3D:GetChunkIndex(P3D.Identifiers.Old_Frame_Controller))
	local MultiControllerChunk = OriginalP3D:GetChunkAtIndex(OriginalP3D:GetChunkIndex(P3D.Identifiers.Multi_Controller))
	
	for idx in GlobalP3D:GetChunkIndexes(P3D.Identifiers.Texture) do
		ReplaceP3D:AddChunk(GlobalP3D:GetChunkAtIndex(idx), 1)
	end
	
	local addedAnim = false
	local addedOldFrameController = false
	local addedMultiController = false
	for idx, id in ReplaceP3D:GetChunkIndexes() do
		if id == P3D.Identifiers.Animation then
			ReplaceP3D:SetChunkAtIndex(idx, AnimChunk)
			addedAnim = true
		elseif id == P3D.Identifiers.Old_Frame_Controller then
			ReplaceP3D:SetChunkAtIndex(idx, OldFrameControllerChunk)
			addedOldFrameController = true
		elseif id == P3D.Identifiers.Multi_Controller then
			ReplaceP3D:SetChunkAtIndex(idx, MultiControllerChunk)
			ReplaceP3D:AddChunk(ScenegraphChunk, idx)
			addedMultiController = true
		elseif id == P3D.Identifiers.Shader then
			local ShaderChunk = P3D.ShaderP3DChunk:new{Raw = ReplaceP3D:GetChunkAtIndex(idx)}
			if P3D.CleanP3DString(ShaderChunk.Name) == "eyeball_m" then
				local tex = P3D.CleanP3DString(ShaderChunk:GetTextureParameter("TEX"))
				if tex and tex:sub(-2) == ".0" then
					ShaderChunk:SetTextureParameter("TEX", P3D.MakeP3DString(tex:sub(1, -3) .. ".3"))
					ReplaceP3D:SetChunkAtIndex(idx, ShaderChunk:Output())
				end
			end
			if not addedAnim then
				ReplaceP3D:AddChunk(AnimChunk, idx + 1)
				addedAnim = true
			end
		elseif id == P3D.Identifiers.Skeleton then
			local SkeletonChunk = P3D.SkeletonP3DChunk:new{Raw = ReplaceP3D:GetChunkAtIndex(idx)}
			SkeletonChunk.Name = Motion_Root_Label
			local SkeletonJointChunk = P3D.SkeletonJointP3DChunk:new{Raw = SkeletonChunk:GetChunkAtIndex(1)}
			SkeletonJointChunk.Name = SkeletonChunk.Name
			SkeletonChunk:SetChunkAtIndex(1, SkeletonJointChunk:Output())
			ReplaceP3D:SetChunkAtIndex(idx, SkeletonChunk:Output())
		elseif id == P3D.Identifiers.Composite_Drawable then
			local CompDrawChunk = P3D.CompositeDrawableP3DChunk:new{Raw = ReplaceP3D:GetChunkAtIndex(idx)}
			CompDrawChunk.Name = Motion_Root_Label
			CompDrawChunk.SkeletonName = CompDrawChunk.Name
			ReplaceP3D:SetChunkAtIndex(idx, CompDrawChunk:Output())
		elseif id == P3D.Identifiers.Skin then
			local SkinChunk = P3D.SkinP3DChunk:new{Raw = ReplaceP3D:GetChunkAtIndex(idx)}
			SkinChunk.SkeletonName = Motion_Root_Label
			ReplaceP3D:SetChunkAtIndex(idx, SkinChunk:Output())
		end
	end
	if not addedOldFrameController then
		if addedMultiController then
			ReplaceP3D:AddChunk(OldFrameControllerChunk, ReplaceP3D:GetChunkCount() - 1)
		else
			ReplaceP3D:AddChunk(OldFrameControllerChunk)
		end
	end
	if not addedMultiController then
		ReplaceP3D:AddChunk(ScenegraphChunk)
		ReplaceP3D:AddChunk(MultiControllerChunk)
	end
	
	if math.random(1, 20) == 1 then
		for idx, id in ReplaceP3D:GetChunkIndexes() do
			if id == P3D.Identifiers.Animation or id == P3D.Identifiers.Animation_Group then
				ReplaceP3D:RemoveChunkAtIndex(idx)
			elseif id == P3D.Identifiers.Multi_Controller then
				local MultiControllerChunk = P3D.MultiControllerP3DChunk:new{Raw = ReplaceP3D:GetChunkAtIndex(idx)}
				local MultiControllerTracksChunk = P3D.MultiControllerTracksP3DChunk:new{Raw = MultiControllerChunk:GetChunkAtIndex(1)}
				for i=#MultiControllerTracksChunk.Tracks,1,-1 do
					MultiControllerTracksChunk.Tracks[i] = nil
				end
				MultiControllerChunk:SetChunkAtIndex(1, MultiControllerTracksChunk:Output())
				ReplaceP3D:SetChunkAtIndex(idx, MultiControllerChunk:Output())
			end
		end
	end
	DebugPrint ("Couch modified with model from " .. ReplacePath)
    Output(ReplaceP3D:Output())
end