-- Override GetPath to fix slashes for us
OriginalGetPath = GetPath
GetPath = function ()
    return FixSlashes(OriginalGetPath(), false, true)
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

function GetFiles(tbl, dir, extensions, count)
    if count == nil then
        count = 1
    end
	DirectoryGetEntries(dir, function(name, directory)
		if directory then
			GetFiles(tbl, dir .. name, extensions, count)
		else
			for i = 1, count do
				for i = 1, #extensions do
					local extension = extensions[i]
					if endsWith(name, extension) then
						table.insert(tbl, dir .. (dir:sub(-1) == "/" and "" or "/") .. name)
						break
					end
				end
			end
		end
		return true
	end)
end

function GetDirs(tbl, dir)
	DirectoryGetEntries(dir, function(name, directory)
		if directory then
			table.insert(tbl, name)
		end
		return true
	end)
end


local bs = { [0] =
   'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
   'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
   'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
   'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/',
}

function base64(s)
   local byte, rep = string.byte, string.rep
   local pad = 2 - ((#s-1) % 3)
   s = (s..rep('\0', pad)):gsub("...", function(cs)
	  local a, b, c = byte(cs, 1, 3)
	  return bs[a>>2] .. bs[(a&3)<<4|b>>4] .. bs[(b&15)<<2|c>>6] .. bs[c&63]
   end)
   return s:sub(1, #s-pad) .. rep('=', pad)
end

function DebugPrint(msg, level)
	if level == nil then
		level = 0
	end
	if Settings.DebugLevel < level then
		return false
	end
	local currTime = os.date("*t")
	local currTimeStr = string.format("[%02d-%02d-%02d %02d:%02d:%02d] ", currTime.year, currTime.month, currTime.day, currTime.hour, currTime.min, currTime.sec)
	local prefix = "<Randomiser v" .. ModVersion .. "> "
	print(currTimeStr .. prefix .. msg)
	return true
end
