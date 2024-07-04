local math_random = math.random

local RandomText = Module("Random Text", "RandomText", 1)

local RandomTextMode = Settings.RandomTextMode

local ValidCharacters = {}
local ValidCharactersN = 0
-- Add A-Z
for c=65,90 do
	ValidCharactersN = ValidCharactersN + 1
	ValidCharacters[ValidCharactersN] = c
end
-- Add a-z
for c=97,122 do
	ValidCharactersN = ValidCharactersN + 1
	ValidCharacters[ValidCharactersN] = c
end
-- Add 0-9
for c=48,57 do
	ValidCharactersN = ValidCharactersN + 1
	ValidCharacters[ValidCharactersN] = c
end
-- Add symbols
for c = 33, 47 do -- !"#$%&'()*+,-./
	ValidCharactersN = ValidCharactersN + 1
	ValidCharacters[ValidCharactersN] = c
end
for c = 58, 64 do -- :;<=>?@
	ValidCharactersN = ValidCharactersN + 1
	ValidCharacters[ValidCharactersN] = c
end
for c = 91, 96 do -- [\]^_`
	ValidCharactersN = ValidCharactersN + 1
	ValidCharacters[ValidCharactersN] = c
end
for c = 123, 126 do -- {|}~
	ValidCharactersN = ValidCharactersN + 1
	ValidCharacters[ValidCharactersN] = c
end

RandomText:AddP3DHandler("art/frontend/scrooby/resource/txtbible/srr2.p3d", function(Path, P3DFile)
	local FrontendTextBible = P3DFile:GetChunk(P3D.Identifiers.Frontend_Text_Bible)
	if not FrontendTextBible then
		return false
	end
	
	for FrontendLanguage in FrontendTextBible:GetChunks(P3D.Identifiers.Frontend_Language) do
		if RandomTextMode == 1 then -- Shuffle lines
			Utils.ShuffleTable(FrontendLanguage.Offsets)
		elseif RandomTextMode == 2 then -- Fully Random
			local Buffer = FrontendLanguage.Buffer
			for i=1,#Buffer do
				if Buffer[i] ~= 0 then
					Buffer[i] = ValidCharacters[math_random(ValidCharactersN)]
				end
			end
		end
	end
	
	return true
end)

return RandomText