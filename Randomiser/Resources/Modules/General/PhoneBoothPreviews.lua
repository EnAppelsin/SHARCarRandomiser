local table_remove = table.remove

local PhoneBoothPreviews = Module("3D Phone Booth Previews", nil, 1)

PhoneBoothPreviews:AddP3DHandler("art\\frontend\\scrooby\\ingame.p3d", function(Path, P3DFile)
	local FrontendProjectChunk = P3DFile:GetChunk(P3D.Identifiers.Frontend_Project)
	local PhoneboothPageChunk = FrontendProjectChunk:GetChunk(P3D.Identifiers.Frontend_Page, false, "PhoneBooth.pag")

	local ForegroundLayerIndex, ForegroundLayerChunk = PhoneboothPageChunk:GetChunkIndexed(P3D.Identifiers.Frontend_Layer, false, "Foreground")

	PhoneboothPageChunk:AddChunk(P3D.FrontendPure3DResourceP3DChunk("3Dmodel", 1, "pure3d\\_stubs\\dummy.p3d", "dummy", "Pedestal_Camera", "", ""), ForegroundLayerIndex)
	PhoneboothPageChunk:AddChunk(P3D.FrontendPure3DResourceP3DChunk("phonebg", 1, "pure3d\\_stubs\\dummy.p3d", "dummy", "Pedestal_Camera", "", ""), ForegroundLayerIndex + 1)
	PhoneboothPageChunk:AddChunk(P3D.FrontendPure3DResourceP3DChunk("rewardfg", 1, "pure3d\\rewardfg.p3d", "PurchaseScene", "Pedestal_Camera", "", ""), ForegroundLayerIndex + 2)

	local GroupChunk = P3D.FrontendGroupP3DChunk("3DModel", 0, 255)
	ForegroundLayerChunk:AddChunk(GroupChunk)

	GroupChunk:AddChunk(P3D.FrontendPure3DObjectP3DChunk("RewardBG", 1, {X = 29, Y = 145}, {X = 400, Y = 300}, {X = P3D.FrontendPure3DObjectP3DChunk.Justifications.Left, Y = P3D.FrontendPure3DObjectP3DChunk.Justifications.Top}, {A=255,R=255,G=255,B=255}, 0, 0, "phonebg"))
	GroupChunk:AddChunk(P3D.FrontendPure3DObjectP3DChunk("RewardFG", 1, {X = 29, Y = 145}, {X = 400, Y = 300}, {X = P3D.FrontendPure3DObjectP3DChunk.Justifications.Left, Y = P3D.FrontendPure3DObjectP3DChunk.Justifications.Top}, {A=255,R=255,G=255,B=255}, 0, 0, "rewardfg"))
	GroupChunk:AddChunk(P3D.FrontendPure3DObjectP3DChunk("PreviewWindow", 1, {X = 29, Y = 145}, {X = 400, Y = 300}, {X = P3D.FrontendPure3DObjectP3DChunk.Justifications.Left, Y = P3D.FrontendPure3DObjectP3DChunk.Justifications.Top}, {A=255,R=255,G=255,B=255}, 0, 0, "3Dmodel"))

	return true
end)

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
PhoneBoothPreviews:AddP3DHandler("art\\frontend\\dynaload\\cars\\*.p3d", function(Path, P3DFile)
	local FileName = GetFileName(Path)
	local BaseFilePath = "/GameData/art/cars/" .. FileName
	assert(Exists(BaseFilePath, true, false), "Loading a phonebooth preview for a car that doesn't exist. I blame Radical.")
	
	local BaseP3DFile = P3D.P3DFile(BaseFilePath)
	P3DFile.Chunks = BaseP3DFile.Chunks
	
	--
	-- Get Chunks
	--

	local CompositeDrawableChunk = P3DFile:GetChunk(P3D.Identifiers.Composite_Drawable)
	assert(CompositeDrawableChunk, "Could not find Composite Drawable when creating a phonebooth preview.")

	local CompositeDrawablePropListChunk = CompositeDrawableChunk:GetChunk(P3D.Identifiers.Composite_Drawable_Prop_List)
	assert(CompositeDrawablePropListChunk, "Could not find Composite Drawable Prop List when creating a phonebooth preview.")

	--
	-- Remove Dummy Wheel Models (Radical hardcodedly removes these in-game)
	--

	if RemoveAllWheels[FileNameWithoutExtension] then
		P3DUtils.RemoveChunksWithName(CompositeDrawablePropListChunk, { ["wShape0"] = true, ["wShape1"] = true, ["wShape2"] = true, ["wShape3"] = true }, P3D.Identifiers.Composite_Drawable_Prop)
	elseif RemoveFrontWheels[FileNameWithoutExtension] then
		P3DUtils.RemoveChunksWithName(CompositeDrawablePropListChunk, { ["wShape2"] = true, ["wShape3"] = true }, P3D.Identifiers.Composite_Drawable_Prop)
	end

	--
	-- Remove Billboards
	--

	local removedBillboards = {}

	for idx, chunk in P3DFile:GetChunksIndexed(P3D.Identifiers.Old_Billboard_Quad_Group, true) do
		removedBillboards[chunk.Name] = true

		P3DFile:RemoveChunk(idx)
	end

	P3DUtils.RemoveChunksWithName(CompositeDrawablePropListChunk, removedBillboards)

	--
	-- Remove Old Frame Controllers
	--

	for idx in P3DFile:GetChunksIndexed(P3D.Identifiers.Old_Frame_Controller, true) do
		P3DFile:RemoveChunk(idx)
	end

	--
	-- Remove Multi Controller Tracks
	--

	local MultiControllerChunk = P3DFile:GetChunk(P3D.Identifiers.Multi_Controller)

	if MultiControllerChunk ~= nil then
		local MultiControllerTracksChunk = MultiControllerChunk:GetChunk(P3D.Identifiers.Multi_Controller_Tracks)

		if MultiControllerTracksChunk then
			local Tracks = MultiControllerTracksChunk.Tracks

			for i = #Tracks, 1, -1 do
				if Tracks[i].Name:sub(1, 4) ~= "PTRN" then
					table_remove(Tracks, i)
				end
			end
		end
	end

	--
	-- Replace Shiny Shaders
	--

	for chunk in P3DFile:GetChunks(P3D.Identifiers.Shader) do
		if chunk.PddiShaderName == "environment" or chunk.PddiShaderName == "spheremap" then
			chunk.PddiShaderName = "simple"
		end
	end
	
	return true
end)

return PhoneBoothPreviews