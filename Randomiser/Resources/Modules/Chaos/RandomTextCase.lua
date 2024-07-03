local math_random = math.random

local RandomTextCase = Module("Random Text Case", "RandomTextCase", 2)

RandomTextCase:AddP3DHandler("art/frontend/scrooby/resource/txtbible/srr2.p3d", function(Path, P3DFile)
	local FrontendTextBible = P3DFile:GetChunk(P3D.Identifiers.Frontend_Text_Bible)
	if not FrontendTextBible then
		return false
	end
	
	for FrontendLanguage in FrontendTextBible:GetChunks(P3D.Identifiers.Frontend_Language) do
		local Buffer = FrontendLanguage.Buffer
		for i=1,#Buffer do
			local c = Buffer[i]
			if c ~= 0 then
				local case = math_random(2)
				if case == 1 then
					if c >= 65 and c <= 90 then
						Buffer[i] = c + 32
					end
				else
					if c >= 97 and c <= 122 then
						Buffer[i] = c - 32
					end
				end
			end
		end
	end
	
	return true
end)

return RandomTextCase