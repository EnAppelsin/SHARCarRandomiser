-- Override GetPath to fix slashes for us
OriginalGetPath = GetPath
GetPath = function ()
    return FixSlashes(OriginalGetPath(), false, true)
end

function trim(s)
   local n = s:find"%S"
   return n and s:match(".*%S", n) or ""
end

function ShuffleTbl(tbl)
	local tblN = #tbl
	local j
	
	for i = tblN, 1, -1 do
		j = math.random(i)
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
end

function GetRandomFromTbl(tbl, rmv)
	if rmv == nil then
		rmv = false
	end
    local i = math.random(#tbl)
    local result = tbl[i]
    if rmv then
        table.remove(tbl, i)
    end
    return result
end

function GetRandomFromKVTbl(tbl, rmv)
	if rmv == nil then
		rmv = false
	end
	local keyset = {}
	for k in pairs(tbl) do
		table.insert(keyset, k)
	end
    local k = keyset[math.random(#keyset)]
	local v = tbl[k]
    if rmv then
        tbl[k] = nil
    end
    return k, v
end

function ExistsInTbl(tbl, needle, caseSensitive)
	if tbl == nil then
		return false
	end
	if caseSensitive == nil then
		caseSensitive = true
	end
	if not caseSensitive then
		needle = needle:lower()
	end
	for i = 1, #tbl do
		local haystack = tbl[i]
		if not caseSensitive then
			haystack = haystack:lower()
		end
		if haystack == needle then
			return true
		end
	end
	return false
end

function CloneKVTable(tbl)
	local clone = {}
	for k,v in pairs(tbl) do
		clone[k] = v
	end
	return clone
end

function CountTable(tbl)
	local count = 0
	for _ in pairs(tbl) do
		count = count + 1
	end
	return count
end

function findLast(haystack, needle)
	local i=haystack:match(".*"..needle.."()")
	if i==nil then return nil else return i-1 end
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function endsWith(String,End)
   return End=='' or string.sub(String:lower(),-string.len(End))==End:lower()
end

function GetFiles(tbl, dir, extensions, count, topLevelOnly)
    if count == nil then
        count = 1
    end
	if dir:sub(-1) ~= "/" then dir = dir .. "/" end
	DirectoryGetEntries(dir, function(name, directory)
		if directory then
			if not topLevelOnly then
				if name:sub(-1) ~= "/" then name = name .. "/" end
				GetFiles(tbl, dir .. name, extensions, count)			
			end
		else
			for i = 1, #extensions do
				local extension = extensions[i]
				if GetFileExtension(name) == extension then
					for i = 1, count do
						table.insert(tbl, dir .. name)
					end
					break
				end
			end
		end
		return true
	end)
	-- Deterministic GetFiles for seeding (case insensitive in case the cases are messed up somehow)
	table.sort(tbl, function (a, b) return a:upper() < b:upper() end)	
end

function GetDirs(tbl, dir)
	DirectoryGetEntries(dir, function(name, directory)
		if directory then
			table.insert(tbl, name)
		end
		return true
	end)
end


local std_bs = { [0] =
   'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
   'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
   'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
   'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/',
}

local std_bsi = {}
for i=0,#std_bs do
	std_bsi[string.byte(std_bs[i])] = i
end

function base64(s, bs)
	if bs == nil then
		bs = std_bs
	end
   local byte, rep = string.byte, string.rep
   local pad = 2 - ((#s-1) % 3)
   s = (s..rep('\0', pad)):gsub("...", function(cs)
	  local a, b, c = byte(cs, 1, 3)
	  return bs[a>>2] .. bs[(a&3)<<4|b>>4] .. bs[(b&15)<<2|c>>6] .. bs[c&63]
   end)
   return s:sub(1, #s-pad) .. rep('=', pad)
end

function base64dec(s, bs, bsi)
	if bs == nil then
		bs = std_bs
		bsi = std_bsi
	end
	if bsi == nil then
		bsi = {}
		for i=0,#bs do
		bsi[string.byte(bs[i])] = i
		end
	end
	s = s:gsub("[^A" .. table.concat(bs) .. "=]", "")
	local p = ''
	if s:sub(#s) == '=' then
		if s:sub(#s - 1) == '=' then
			p = 'AA'
		else
			p = 'A'
		end
		s = s:sub(1, #s - #p) .. p
	end
	s = s:gsub("....", function(cs)
		local a, b, c, d = string.byte(cs, 1, 4)
		local n = (bsi[a] << 18) + (bsi[b] << 12) + (bsi[c] << 6) + bsi[d]
		return string.char((n >> 16) & 255, (n >> 8) & 255, n & 255)
	end)
	return s:sub(1, #s - #p)
end

function DebugPrint(msg, level)
	if level == nil then
		level = 0
	end
	if Settings.DebugLevel < level then
		return false
	end
	print(ModName, ModVersion, msg)
	return true
end

