local Path = GetPath()

-- Handle the couch logic separately (it's quite long)
if Path == "art\\frontend\\scrooby\\resource\\pure3d\\homer.p3d" then
    dofile(ModPath .. "/RandomCouch.lua")
-- TODO: This will randomise chosen model p3d files properly
elseif Path == "art\\chars\\homer_m.p3d" then
    local Original = ReadFile("GameData/" .. Path)
    -- TODO: This is obviously hard coded at the moment
    local ReplacePath = "/GameData/art/chars/franke_m.p3d"
	local Replace = ReadFile(ReplacePath)
    
    -- Load new skeleton
    local SKIndex, SKLength = FindSubchunk(Replace, SKELETON_CHUNK)
    local NewSkel = Replace:sub(SKIndex, SKIndex + SKLength - 1)
    
    -- Load new skin
    local SNIndex, SNLength = FindSubchunk(Replace, SKIN_CHUNK)
    local NewSkin = Replace:sub(SNIndex, SNIndex + SNLength - 1)
    
    -- Find Original Skeleton, Remove it
    SKIndex, SKLength = FindSubchunk(Original, SKELETON_CHUNK)
    local SkelName, SkelNLength = GetP3DString(Original, SKIndex + 12)
    Original = RemoveString(Original, SKIndex, SKIndex + SKLength)
    
    -- Find Original Skin
    SNIndex, SNLength = FindSubchunk(Original, SKIN_CHUNK)
    local SkinName, SkinNLength = GetP3DString(Original, SNIndex + 12)
    
    -- Change names and update lengths
    NewSkel, SkelDelta, OSName = SetP3DString(NewSkel, 13, SkelName)
    NewSkel = AddP3DInt4(NewSkel, 5, SkelDelta)
    NewSkel = AddP3DInt4(NewSkel, 9, SkelDelta)
    NewSkin, SkinDelta, OS2Name = SetP3DString(NewSkin, 13, SkinName)
    local SkelNameIndex = SkinName:len() + 18
    NewSkin, SkinDelta2, OS3Name = SetP3DString(NewSkin, SkelNameIndex, SkelName)
    NewSkin = AddP3DInt4(NewSkin, 5, SkinDelta + SkinDelta2)
    NewSkin = AddP3DInt4(NewSkin, 9, SkinDelta + SkinDelta2)
    
    print(OSName, "->", SkelName, OS2Name, "->", SkinName, OS3Name, "->", SkelName)
    
    -- Add to original model
    Original = Original:sub(1, SNIndex - 1) .. NewSkel .. NewSkin .. Original:sub(SNIndex + SNLength)
    
    -- Update file length
    Original = SetP3DInt4(Original, 9, Original:len())
   
    Output(Original)
end
