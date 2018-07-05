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
    
    Original = ReplaceCharacterSkinSkel(Original, Replace)
   
    Output(Original)
end
