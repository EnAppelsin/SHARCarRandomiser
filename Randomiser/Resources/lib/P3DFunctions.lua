if P3D == nil then Alert("P3D Functions loaded with no P3D table present.") end
local P3D = P3D

--Miscellaneous
function GetCompositeDrawableName(P3DFile)
	local Chunk = P3D.P3DChunk:new{Raw = P3DFile}
	for idx in Chunk:GetChunkIndexes(P3D.Identifiers.Composite_Drawable) do
		return P3D.GetString(Chunk.Chunks[idx], 13)
	end
	return nil
end
--End Miscellaneous

--Brightness
local min = math.min
local max = math.max
local floor = math.floor
local function BrightenRGB(r, g, b, Amount, Percentage)
	if Percentage then
		b = min(255, max(0, floor(b * Amount)))
		g = min(255, max(0, floor(g * Amount)))
		r = min(255, max(0, floor(r * Amount)))
	else
		b = min(255, max(0, b + Amount))
		g = min(255, max(0, g + Amount))
		r = min(255, max(0, r + Amount))
	end
	return r, g, b
end

local LensFlare = IsHackLoaded("LensFlare")
local ROOT_CHUNKS = {P3D.Identifiers.Static_Entity, P3D.Identifiers.Inst_Stat_Phys, P3D.Identifiers.Dyna_Phys, P3D.Identifiers.Breakable_Object, P3D.Identifiers.World_Sphere, P3D.Identifiers.Inst_Stat_Entity}
function BrightenModel(Original, Amount, Percentage)
	local RootChunk = P3D.P3DChunk:new{Raw = Original}
	local modified = false
	for RootIdx, RootID in RootChunk:GetChunkIndexes(nil) do
		if ExistsInTbl(ROOT_CHUNKS, RootID) then
			RootChunk:SetChunkAtIndex(RootIdx, BrightenModelProcessRoot(RootChunk:GetChunkAtIndex(RootIdx), Amount, Percentage))
			modified = true
		elseif RootID == P3D.Identifiers.Mesh then
			RootChunk:SetChunkAtIndex(RootIdx, BrightenModelProcessMesh(RootChunk:GetChunkAtIndex(RootIdx), Amount, Percentage))
			modified = true
		elseif RootID == P3D.Identifiers.Old_Billboard_Quad_Group then
			RootChunk:SetChunkAtIndex(RootIdx, BrightenModelProcessOldBillboardQuadGroup(RootChunk:GetChunkAtIndex(RootIdx), Amount, Percentage))
			modified = true
		elseif RootID == P3D.Identifiers.Old_Billboard_Quad then
			RootChunk:SetChunkAtIndex(RootIdx, BrightenModelProcessOldBillboardQuad(RootChunk:GetChunkAtIndex(RootIdx), Amount, Percentage))
			modified = true
		elseif RootID == P3D.Identifiers.Anim_Dyna_Phys then
			local AnimDynaPhysChunk = P3D.AnimDynaPhysP3DChunk:new{Raw = RootChunk:GetChunkAtIndex(RootIdx)}
			for idx in AnimDynaPhysChunk:GetChunkIndexes(P3D.Identifiers.Anim_Obj_Wrapper) do
				local AnimObjWrapperChunk = P3D.AnimObjWrapperP3DChunk:new{Raw = AnimDynaPhysChunk:GetChunkAtIndex(idx)}
				for idx2 in AnimObjWrapperChunk:GetChunkIndexes(P3D.Identifiers.Mesh) do
					AnimObjWrapperChunk:SetChunkAtIndex(idx2, BrightenModelProcessMesh(AnimObjWrapperChunk:GetChunkAtIndex(idx2), Amount, Percentage))
				end
				for idx2 in AnimObjWrapperChunk:GetChunkIndexes(P3D.Identifiers.Old_Billboard_Quad_Group) do
					AnimObjWrapperChunk:SetChunkAtIndex(idx2, BrightenModelProcessOldBillboardQuadGroup(AnimObjWrapperChunk:GetChunkAtIndex(idx2), Amount, Percentage))
				end
			end
			RootChunk:SetChunkAtIndex(RootIdx, AnimDynaPhysChunk:Output())
			modified = true
		elseif RootID == P3D.Identifiers.Light then
			local LightChunk = P3D.LightP3DChunk:new{Raw = RootChunk:GetChunkAtIndex(RootIdx)}
			local R, G, B = BrightenRGB(LightChunk.Colour.R, LightChunk.Colour.G, LightChunk.Colour.B, Amount, Percentage)
			LightChunk.Colour.R = R
			LightChunk.Colour.G = G
			LightChunk.Colour.B = B
			RootChunk:SetChunkAtIndex(RootIdx, LightChunk:Output())
			modified = true
		end
	end
	return RootChunk:Output(), modified
end
function BrightenModelProcessRoot(Original, Amount, Percentage)
	local RootChunk = P3D.P3DChunk:new{Raw = Original}
	for idx in RootChunk:GetChunkIndexes(P3D.Identifiers.Mesh) do
		RootChunk:SetChunkAtIndex(idx, BrightenModelProcessMesh(RootChunk:GetChunkAtIndex(idx), Amount, Percentage))
	end
	if LensFlare and RootChunk.ChunkType == P3D.Identifiers.World_Sphere then
		for idx in RootChunk:GetChunkIndexes(P3D.Identifiers.Lens_Flare) do
			local LensFlareChunk = P3D.LensFlareP3DChunk:new{Raw = RootChunk:GetChunkAtIndex(idx)}
			for idx2 in LensFlareChunk:GetChunkIndexes(P3D.Identifiers.Old_Billboard_Quad_Group) do
				LensFlareChunk:SetChunkAtIndex(idx2, BrightenModelProcessOldBillboardQuadGroup(LensFlareChunk:GetChunkAtIndex(idx2), Amount, Percentage))
			end
			for idx2 in LensFlareChunk:GetChunkIndexes(P3D.Identifiers.Mesh) do
				LensFlareChunk:SetChunkAtIndex(idx2, BrightenModelProcessMesh(LensFlareChunk:GetChunkAtIndex(idx2), Amount, Percentage))
			end
			RootChunk:SetChunkAtIndex(idx, LensFlareChunk:Output())
		end
	end
	return RootChunk:Output()
end
function BrightenModelProcessMesh(Original, Amount, Percentage)
	local MeshChunk = P3D.MeshP3DChunk:new{Raw = Original}
	for idx in MeshChunk:GetChunkIndexes(P3D.Identifiers.Old_Primitive_Group) do
		local OldPrimitiveGroupChunk = P3D.OldPrimitiveGroupP3DChunk:new{Raw = MeshChunk:GetChunkAtIndex(idx)}
		for idx2 in OldPrimitiveGroupChunk:GetChunkIndexes(P3D.Identifiers.Colour_List) do
			local ColourListChunk = P3D.ColourListP3DChunk:new{Raw = OldPrimitiveGroupChunk:GetChunkAtIndex(idx2)}
			for i=1,#ColourListChunk.Colours do
				local col = ColourListChunk.Colours[i]
				col.R, col.G, col.B = BrightenRGB(col.R, col.G, col.B, Amount, Percentage)
			end
			OldPrimitiveGroupChunk:SetChunkAtIndex(idx2, ColourListChunk:Output())
		end
		MeshChunk:SetChunkAtIndex(idx, OldPrimitiveGroupChunk:Output())
	end
	return MeshChunk:Output()
end
function BrightenModelProcessOldBillboardQuadGroup(Original, Amount, Percentage)
	local OldBillboardQuadGroupChunk = P3D.OldBillboardQuadGroupP3DChunk:new{Raw = Original}
	for idx in OldBillboardQuadGroupChunk:GetChunkIndexes(P3D.Identifiers.Old_Billboard_Quad) do
		OldBillboardQuadGroupChunk:SetChunkAtIndex(idx, BrightenModelProcessOldBillboardQuad(OldBillboardQuadGroupChunk:GetChunkAtIndex(idx), Amount, Percentage))
	end
	return OldBillboardQuadGroupChunk:Output()
end
function BrightenModelProcessOldBillboardQuad(Original, Amount, Percentage)
	local OldBillboardQuadChunk = P3D.OldBillboardQuadP3DChunk:new{Raw = Original}
	local R, G, B = BrightenRGB(OldBillboardQuadChunk.Colour.R, OldBillboardQuadChunk.Colour.G, OldBillboardQuadChunk.Colour.B, Amount, Percentage)
	OldBillboardQuadChunk.Colour.R = R
	OldBillboardQuadChunk.Colour.G = G
	OldBillboardQuadChunk.Colour.B = B
	return OldBillboardQuadChunk:Output()
end

function SetModelRGB(Original, A, R, G, B)
	local RootChunk = P3D.P3DChunk:new{Raw = Original}
	local modified = false
	for RootIdx, RootID in RootChunk:GetChunkIndexes(nil) do
		if ExistsInTbl(ROOT_CHUNKS, RootID) then
			RootChunk:SetChunkAtIndex(RootIdx, SetModelRGBProcessRoot(RootChunk:GetChunkAtIndex(RootIdx), A, R, G, B))
			modified = true
		elseif RootID == P3D.Identifiers.Mesh then
			RootChunk:SetChunkAtIndex(RootIdx, SetModelRGBProcessMesh(RootChunk:GetChunkAtIndex(RootIdx), A, R, G, B))
			modified = true
		elseif RootID == P3D.Identifiers.Old_Billboard_Quad_Group then
			RootChunk:SetChunkAtIndex(RootIdx, SetModelRGBProcessOldBillboardQuadGroup(RootChunk:GetChunkAtIndex(RootIdx), A, R, G, B))
			modified = true
		elseif RootID == P3D.Identifiers.Old_Billboard_Quad then
			RootChunk:SetChunkAtIndex(RootIdx, SetModelRGBProcessOldBillboardQuad(RootChunk:GetChunkAtIndex(RootIdx), A, R, G, B))
			modified = true
		elseif RootID == P3D.Identifiers.Anim_Dyna_Phys then
			local AnimDynaPhysChunk = P3D.AnimDynaPhysP3DChunk:new{Raw = RootChunk:GetChunkAtIndex(RootIdx)}
			for idx in AnimDynaPhysChunk:GetChunkIndexes(P3D.Identifiers.Anim_Obj_Wrapper) do
				local AnimObjWrapperChunk = AnimObjWrapperP3DChunk:new{Raw = AnimDynaPhysChunk:GetChunkAtIndex(idx)}
				for idx2 in AnimObjWrapperChunk:GetChunkIndexes(P3D.Identifiers.Mesh) do
					AnimObjWrapperChunk:SetChunkAtIndex(idx2, SetModelRGBProcessMesh(AnimObjWrapperChunk:GetChunkAtIndex(idx2), A, R, G, B))
				end
				for idx2 in AnimObjWrapperChunk:GetChunkIndexes(P3D.Identifiers.Old_Billboard_Quad_Group) do
					AnimObjWrapperChunk:SetChunkAtIndex(idx2, SetModelRGBProcessOldBillboardQuadGroup(AnimObjWrapperChunk:GetChunkAtIndex(idx2), A, R, G, B))
				end
			end
			RootChunk:SetChunkAtIndex(RootIdx, AnimDynaPhysChunk:Output())
			modified = true
		elseif RootID == P3D.Identifiers.Light then
			local LightChunk = P3D.LightP3DChunk:new{Raw = RootChunk:GetChunkAtIndex(RootIdx)}
			LightChunk.Colour.A = A
			LightChunk.Colour.R = R
			LightChunk.Colour.G = G
			LightChunk.Colour.B = B
			RootChunk:SetChunkAtIndex(RootIdx, LightChunk:Output())
			modified = true
		end
	end
	return RootChunk:Output(), modified
end
function SetModelRGBProcessRoot(Original, A, R, G, B)
	local RootChunk = P3D.P3DChunk:new{Raw = Original}
	for idx in RootChunk:GetChunkIndexes(P3D.Identifiers.Mesh) do
		RootChunk:SetChunkAtIndex(idx, SetModelRGBProcessMesh(RootChunk:GetChunkAtIndex(idx), A, R, G, B))
	end
	if LensFlare and RootChunk.ChunkType == P3D.Identifiers.World_Sphere then
		for idx in RootChunk:GetChunkIndexes(P3D.Identifiers.Lens_Flare) do
			local LensFlareChunk = P3D.LensFlareP3DChunk:new{Raw = RootChunk:GetChunkAtIndex(idx)}
			for idx2 in LensFlareChunk:GetChunkIndexes(P3D.Identifiers.Old_Billboard_Quad_Group) do
				LensFlareChunk:SetChunkAtIndex(idx2, SetModelRGBProcessOldBillboardQuadGroup(LensFlareChunk:GetChunkAtIndex(idx2), A, R, G, B))
			end
			for idx2 in LensFlareChunk:GetChunkIndexes(P3D.Identifiers.Mesh) do
				LensFlareChunk:SetChunkAtIndex(idx2, SetModelRGBProcessMesh(LensFlareChunk:GetChunkAtIndex(idx2), A, R, G, B))
			end
			RootChunk:SetChunkAtIndex(idx, LensFlareChunk:Output())
		end
	end
	return RootChunk:Output()
end
function SetModelRGBProcessMesh(Original, A, R, G, B)
	local MeshChunk = P3D.MeshP3DChunk:new{Raw = Original}
	for idx in MeshChunk:GetChunkIndexes(P3D.Identifiers.Old_Primitive_Group) do
		local OldPrimitiveGroupChunk = OldPrimitiveGroupP3DChunk:new{Raw = MeshChunk:GetChunkAtIndex(idx)}
		for idx2 in OldPrimitiveGroupChunk:GetChunkIndexes(P3D.Identifiers.Colour_List) do
			local ColourListChunk = P3D.ColourListP3DChunk:new{Raw = OldPrimitiveGroupChunk:GetChunkAtIndex(idx2)}
			for i=1,#ColourListChunk.Colours do
				ColourListChunk.Colours[i].A = A
				ColourListChunk.Colours[i].R = R
				ColourListChunk.Colours[i].G = G
				ColourListChunk.Colours[i].B = B
			end
			OldPrimitiveGroupChunk:SetChunkAtIndex(idx2, ColourListChunk:Output())
		end
		MeshChunk:SetChunkAtIndex(idx, OldPrimitiveGroupChunk:Output())
	end
	return MeshChunk:Output()
end
function SetModelRGBProcessOldBillboardQuadGroup(Original, A, R, G, B)
	local OldBillboardQuadGroupChunk = P3D.OldBillboardQuadGroupP3DChunk:new{Raw = Original}
	for idx in OldBillboardQuadGroupChunk:GetChunkIndexes(P3D.Identifiers.Old_Billboard_Quad) do
		OldBillboardQuadGroupChunk:SetChunkAtIndex(idx, SetModelRGBProcessOldBillboardQuad(OldBillboardQuadGroupChunk:GetChunkAtIndex(idx), A, R, G, B))
	end
	return OldBillboardQuadGroupChunk:Output()
end
function SetModelRGBProcessOldBillboardQuad(Original, A, R, G, B)
	local OldBillboardQuadChunk = P3D.OldBillboardQuadP3DChunk:new{Raw = Original}
	OldBillboardQuadChunk.Colour.A = A
	OldBillboardQuadChunk.Colour.R = R
	OldBillboardQuadChunk.Colour.G = G
	OldBillboardQuadChunk.Colour.B = B
	return OldBillboardQuadChunk:Output()
end
--End brightness

--Characters
local SkinSkelCopy = {[P3D.Identifiers.Skin] = true, [P3D.Identifiers.Texture] = true, [P3D.Identifiers.Shader] = true, [P3D.Identifiers.Mesh] = true, [P3D.Identifiers.Animation] = true, [P3D.Identifiers.Old_Frame_Controller] = true, [P3D.Identifiers.Particle_System_Factory] = true, [P3D.Identifiers.Particle_System_2] = true}
local SkinSkelRename = {[P3D.Identifiers.Skeleton] = true, [P3D.Identifiers.Multi_Controller] = true, [P3D.Identifiers.Composite_Drawable] = true}

function ReplaceCharacterSkinSkel(Original, Replace)
	local OriginalP3D = P3D.P3DChunk:new{Raw = Original}
	local ReplaceP3D = P3D.P3DChunk:new{Raw = Replace}
	local Renames = {}
	local HasMulti = false
	for idx, id in OriginalP3D:GetChunkIndexes() do
		if SkinSkelRename[id] then
			Renames[id] = P3D.GetString(OriginalP3D.Chunks[idx], 13)
			OriginalP3D:RemoveChunkAtIndex(idx)
			if id == P3D.Identifiers.Multi_Controller then HasMulti = true end
		elseif SkinSkelCopy[id] then
			OriginalP3D:RemoveChunkAtIndex(idx)
		end
	end
	if not HasMulti then Renames[P3D.Identifiers.Multi_Controller] = Renames[P3D.Identifiers.Skeleton] end
	for idx, id in ReplaceP3D:GetChunkIndexes() do
		if id == P3D.Identifiers.Skin then
			local SkinChunk = P3D.SkinP3DChunk:new{Raw = ReplaceP3D:GetChunkAtIndex(idx)}
			SkinChunk.SkeletonName = Renames[P3D.Identifiers.Skeleton]
			OriginalP3D:AddChunk(SkinChunk:Output(), 1)
		elseif SkinSkelCopy[id] then
			local chunk = ReplaceP3D:GetChunkAtIndex(idx)
			OriginalP3D:AddChunk(chunk, 1)
		elseif id == P3D.Identifiers.Composite_Drawable then
			local CompDrawChunk = P3D.CompositeDrawableP3DChunk:new{Raw = ReplaceP3D:GetChunkAtIndex(idx)}
			CompDrawChunk.Name = Renames[id]
			CompDrawChunk.SkeletonName = Renames[P3D.Identifiers.Skeleton]
			OriginalP3D:AddChunk(CompDrawChunk:Output(), 1)
		elseif SkinSkelRename[id] then
			local Chunk = P3D.P3DChunk:new{Raw = ReplaceP3D:GetChunkAtIndex(idx)}
			Chunk:SetName(Renames[id])
			OriginalP3D:AddChunk(Chunk:Output(), 1)
		end
	end
	return OriginalP3D:Output()
end
--End Characters

--Cars
function SetCarCameraIndex(CarModel, Index)
	local CarP3D = P3D.P3DChunk:new{Raw = CarModel}
	for idx in CarP3D:GetChunkIndexes(P3D.Identifiers.Follow_Camera_Data) do
		local FollowCameraDataChunk = P3D.FollowCameraDataP3DChunk:new{Raw = CarP3D:GetChunkAtIndex(idx)}
		if FollowCameraDataChunk.Index % 512 > 256 then
			FollowCameraDataChunk.Index = Index + 256
		else
			FollowCameraDataChunk.Index = Index
		end
		CarP3D:SetChunkAtIndex(idx, FollowCameraDataChunk:Output())
	end
	return CarP3D:Output()
end

function ReplaceCar(Original, Replace)
	local cam = nil
	local ReplaceP3D = P3D.P3DChunk:new{Raw = Replace}
	for idx in ReplaceP3D:GetChunkIndexes(P3D.Identifiers.Follow_Camera_Data) do
		local cameraID = P3D.String4ToInt(ReplaceP3D.Chunks[idx], 13)
		if cameraID % 512 <= 256 then
			cam = cameraID
			break
		end
	end
	if not cam then return Original end
	local CompIdx = ReplaceP3D:GetChunkIndex(P3D.Identifiers.Composite_Drawable)
	local NewName = P3D.GetString(ReplaceP3D.Chunks[CompIdx], 13)
	local NewNameBV = P3D.MakeP3DString(P3D.CleanP3DString(NewName) .. "BV")
	local OriginalP3D = P3D.P3DChunk:new{Raw = Original}
	local OldName = nil
	for idx, id in OriginalP3D:GetChunkIndexes() do
		if id == P3D.Identifiers.Follow_Camera_Data then
			local FollowCameraDataChunk = P3D.FollowCameraDataP3DChunk:new{Raw = OriginalP3D:GetChunkAtIndex(idx)}
			if FollowCameraDataChunk.Index % 512 > 256 then
				FollowCameraDataChunk.Index = cam + 256
			else
				FollowCameraDataChunk.Index = cam
			end
			OriginalP3D:SetChunkAtIndex(idx, FollowCameraDataChunk:Output())
		elseif id == P3D.Identifiers.Collision_Object then
			local CollisionObjectChunk = P3D.CollisionObjectP3DChunk:new{Raw = OriginalP3D:GetChunkAtIndex(idx)}
			if P3D.CleanP3DString(CollisionObjectChunk.Name):sub(-2) == "BV" then
				CollisionObjectChunk.Name = NewNameBV
			else
				CollisionObjectChunk.Name = NewName
			end
			OriginalP3D:SetChunkAtIndex(idx, CollisionObjectChunk:Output())
		elseif id == P3D.Identifiers.Physics_Object then
			local PhysicsObjectChunk = P3D.PhysicsObjectP3DChunk:new{Raw = OriginalP3D:GetChunkAtIndex(idx)}
			if P3D.CleanP3DString(PhysicsObjectChunk.Name):sub(-2) == "BV" then
				PhysicsObjectChunk.Name = NewNameBV
			else
				PhysicsObjectChunk.Name = NewName
			end
			OriginalP3D:SetChunkAtIndex(idx, PhysicsObjectChunk:Output())
		elseif id == P3D.Identifiers.Composite_Drawable then
			local CompDrawableChunk = P3D.CompositeDrawableP3DChunk:new{Raw = OriginalP3D:GetChunkAtIndex(idx)}
			OldName = CompDrawableChunk.Name
			CompDrawableChunk.Name = NewName
			OriginalP3D:SetChunkAtIndex(idx, CompDrawableChunk:Output())
		elseif id == P3D.Identifiers.Multi_Controller then
			local MultiControllerChunk = P3D.MultiControllerP3DChunk:new{Raw = OriginalP3D:GetChunkAtIndex(idx)}
			MultiControllerChunk.Name = NewName
			OriginalP3D:SetChunkAtIndex(idx, MultiControllerChunk:Output())
		end
	end
	for idx in OriginalP3D:GetChunkIndexes(P3D.Identifiers.Old_Frame_Controller) do
		local OldFrameControllerChunk = P3D.OldFrameControllerP3DChunk:new{Raw = OriginalP3D:GetChunkAtIndex(idx)}
		if OldFrameControllerChunk.HierarchyName == OldName then
			OldFrameControllerChunk.HierarchyName = NewName
			OriginalP3D:SetChunkAtIndex(idx, OldFrameControllerChunk:Output())
		end
	end
	
	--TODO: Remove wheels from relevant cars (witchcar, hoverbike, etc)
	return OriginalP3D:Output()
end
--End Cars

--Image
function SetSpriteImage(Original, NewImage, Width, Height)
	local OriginalP3D = P3D.P3DChunk:new{Raw = Original}
	local SpriteIdx = OriginalP3D:GetChunkIndex(P3D.Identifiers.Sprite)
	if not SpriteIdx then return Original end
	local SpriteChunk = P3D.SpriteP3DChunk:new{Raw = OriginalP3D:GetChunkAtIndex(SpriteIdx)}
	for i=SpriteChunk:GetChunkCount(),2,-1 do
		SpriteChunk:RemoveChunkAtIndex(i)
	end
	local ImageChunk = P3D.ImageP3DChunk:new{Raw = SpriteChunk:GetChunkAtIndex(1)}
	ImageChunk.Format = P3D.ImageP3DChunk.Formats.PNG
	if Width and Height then
		SpriteChunk.NativeX = Width
		SpriteChunk.NativeY = Height
		SpriteChunk.ImageWidth = Width
		SpriteChunk.ImageHeight = Height
		ImageChunk.Width = Width
		ImageChunk.Height = Height
	end
	ImageChunk:RemoveChunkAtIndex(1)
	local ImageDataChunk = P3D.ImageDataP3DChunk:create(NewImage)
	ImageChunk:AddChunk(ImageDataChunk:Output())
	SpriteChunk:SetChunkAtIndex(1, ImageChunk:Output())
	OriginalP3D:SetChunkAtIndex(SpriteIdx, SpriteChunk:Output())
	return OriginalP3D:Output()
end
--End Image

--Roads
function GetRoads(RoadPositions, Level)
	if not RoadPositions["L" .. Level] then RoadPositions["L" .. Level] = {} end
	local tbl = RoadPositions["L" .. Level]
	local P3DFile = P3D.P3DChunk:new{Raw = ReadFile("/GameData/art/L" .. Level .. "_TERRA.p3d")}
	local RoadSegments = {}
	for idx in P3DFile:GetChunkIndexes(P3D.Identifiers.Road_Data_Segment) do
		local RoadDataSegmentChunk = P3D.RoadDataSegmentP3DChunk:new{Raw = P3DFile:GetChunkAtIndex(idx)}
		local item = {}
		item.Position = RoadDataSegmentChunk.Position
		item.Position2 = RoadDataSegmentChunk.Position2
		item.Position3 = RoadDataSegmentChunk.Position3
		RoadSegments[RoadDataSegmentChunk.Name] = item
	end
	for idx in P3DFile:GetChunkIndexes(P3D.Identifiers.Road) do
		local RoadChunk = P3D.RoadP3DChunk:new{Raw = P3DFile:GetChunkAtIndex(idx)}
		if RoadChunk.Shortcut == 0 then
			for SegmentIdx in RoadChunk:GetChunkIndexes(P3D.Identifiers.Road_Segment) do
				local RoadSegmentChunk = P3D.RoadSegmentP3DChunk:new{Raw = RoadChunk:GetChunkAtIndex(SegmentIdx)}
				if RoadSegments[RoadSegmentChunk.Name] then
					local RoadSegmentData = RoadSegments[RoadSegmentChunk.Name]
					local Road = {}
					Road.TopLeft = RoadSegmentData.Position
					Road.TopRight = RoadSegmentData.Position2
					Road.BottomLeft = {X = RoadSegmentChunk.Transform.M41, Y = RoadSegmentChunk.Transform.M42, Z = RoadSegmentChunk.Transform.M43}
					Road.BottomRight = RoadSegmentData.Position3
					
					local x1 = Road.BottomRight.X * 0.5
					local y1 = Road.BottomRight.Y * 0.5
					local z1 = Road.BottomRight.Z * 0.5
					
					local x2 = Road.TopLeft.X + (Road.TopRight.X - Road.TopLeft.X) * 0.5
					local y2 = Road.TopLeft.Y + (Road.TopRight.Y - Road.TopLeft.Y) * 0.5
					local z2 = Road.TopLeft.Z + (Road.TopRight.Z - Road.TopLeft.Z) * 0.5
					
					Road.Length = math.sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)
					tbl[#tbl + 1] = Road
				end
			end
		end
	end
end
--End Roads