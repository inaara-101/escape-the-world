--[[
	FormatNumber // Evercyan, March 2022
	My own implementation of the old library I used from my old friend, Empulsion.
	Used to convert a number type to a string with special formatting.
	Number: 123456789
	Commas: 123,456,789
	Suffix: 123.4M
]] 

local Suffixes = {"K", "M", "B", "T", "Qd", "Qn", "Sx", "Sp", "Oc", "N", "D", "Ud", "Dd", "Tdd"}

local function roundToNearest(n: number, to: number)
	return math.round(n / to) * to
end

local function formatNotation(n: number)
	return string.gsub(string.format("%.1e", n), "+", "")
end

local function formatCommas(n: number)
	local str = string.format("%.f", n)
	return #str % 3 == 0 and str:reverse():gsub("(%d%d%d)", "%1,"):reverse():sub(2) or str:reverse():gsub("(%d%d%d)", "%1,"):reverse()
end

local function formatSuffix(n: number)
	local str = string.format("%.f", math.floor(n))
	str = roundToNearest(tonumber(string.sub(str, 1, 12)), 10) .. string.sub(str, 13, #str)
	local size = #str
	
	local cutPoint = (size-1) % 3 + 1
	local before = string.sub(str, 1, cutPoint) -- (123).4K
	
	local after = string.format("%01.f", string.sub(str, cutPoint + 1, cutPoint + 1)) -- 123.(4)K
	local suffix = Suffixes[math.clamp(math.floor((size-1)/3), 1, #Suffixes)] -- 123.4(K)
	
	if not suffix or n > 9.999e44 then
		return formatNotation(n)
	end
	
	return string.format("%s.%s%s", before, after, suffix)
end

--------------------------------------------------------------------------------

local API = {}

API.FormatType = {
	Notation = "Notation",
	Commas = "Commas",
	Suffix = "Suffix",
}

local function Convert(n: number, FormatType: string)
	n = tonumber(n)
	
	if n < 1e3 or FormatType == nil then
		if FormatType == nil then
			warn("[FormatNumber]: FormatType wasn't given.")
		end
		return tostring(n)
	end
	
	if FormatType == "Notation" then
		return formatNotation(n)
	elseif FormatType == "Commas" then
		return formatCommas(n)
	elseif FormatType == "Suffix" then
		return formatSuffix(n)
	else
		warn("[FormatNumber]: FormatType not found for \"".. FormatType .."\".")
	end
end

setmetatable(API, {
	__call = function(t, ...)
		if t == API then
			return Convert(...)
		end
	end,
})

return API
