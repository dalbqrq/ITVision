--[[ FUNCTIONS DEFINED IN THIS FILE

	function showtable(t)		-- Prints table infos: var-names and values
	function toCSV (t, sep)			-- Transform an array of strings into CSV 
	function escapeCSV (s, sep)		-- Enclose comma or quote between quotes and escape its original quotes
	function fromCSV (s, sep)		-- Transform a CSV line string into an array of strings
	function line_reader(filename)		-- Return a table where each entry is a line

]]--

-- Prints table infos: var-names and values
function showtable(t)
	print( "{" )
	for i,v in pairs (t) do
		--print(("\n") )
		if type(v) == "table" then
			local vv = "{\n"
			for a,b in pairs(v) do
				vv = string.format ("%s  %s = \"%s\",\n", vv, a, tostring(b))
			end
			v = vv.." },"
			print( (string.format (" %s = %s", i, tostring(v))) )
		else
			print( (string.format (" %s = \"%s\",", i, tostring(v))) )
		end
	end
	if next(t) then
		--print( "\n" )
	end
	print( "}\n" )
end


-- Transform an array of strings into CSV 
function toCSV (t, sep)
	sep = sep or ','     -- ny default, use 'semi-colon' (,) as field delimiter instead of 'comma' (;)
	local s = ""
	local p

	for _,p in pairs(t) do
		s = s .. sep .. escapeCSV(p, sep)
	end
	return string.sub(s, 2)		-- remove first comma
end


-- If a string has commas or quotes inside, enclose it between quotes and escape its original quotes
function escapeCSV (s, sep)
	sep = sep or ','     -- use 'semi-colon' as field delimiter instead of 'comma'
	--local s = ""

	if string.find(s, '['..sep..'"]') then
		s = '"' .. string.gsub(s, '"', '""') .. '"'
	end
	return s
end


-- Transform a CSV line string into an array of strings
-- Return a table
function fromCSV (s, sep)
	sep = sep or ';'     -- use 'semi-colon' as field delimiter instead of 'comma'
	s = s .. sep
	local t = {}         -- table to collect fields
	local fieldstart = 1
	repeat
			if string.find(s, '^"', fieldstart) then        -- next field is quoted? (start with '"'?)
				local a, c
				local i = fieldstart
				repeat
					a, i, c = string.find(s, '"("?)', i+1)  -- find closing quote
				until c ~= '"'                              -- quote not followed by quote?
				if not i then error('unmatched "') end
				local f = string.sub(s, fieldstart+1, i-1)
				table.insert(t, (string.gsub(f, '""', '"')))
				fieldstart = string.find(s, sep, i) + 1
			else                                             -- unquoted; find next comma
				local nexti = string.find(s, sep, fieldstart)
				table.insert(t, string.sub(s, fieldstart, nexti-1))
				fieldstart = nexti + 1
			end
	until fieldstart > string.len(s)
	return t
end


function toString(t)
	s = "{"
	for i,v in pairs (t) do
		s = s .. "\n"
		if type(v) == "table" then
			local vv = "{\n"
			for a,b in pairs(v) do
				--vv = string.format ("%s  %s = \"%s\",\n", vv, a, tostring(b))  -- with numbers naming the fields
				vv = string.format ("%s  \"%s\",\n", vv, tostring(b))
			end
			v = vv.." },"
			--s = s .. (string.format (" %s = %s", i, tostring(v)))   -- with numbers naming the fields
			s = s .. (string.format (" %s", tostring(v))) 
		else
			--s = s .. (string.format (" %s = \"%s\",", i, tostring(v)))  -- with numbers naming the fields
			s = s .. (string.format (" \"%s\",", tostring(v)))
		end
	end
	if next(t) then
		s = s .. "\n" 
	end
	s = s .. "}\n"

	return s
end


-- Return a table where each entry is a line
function line_reader(filename)

	--[[ OLD IMPLEMENTATION
	io.input(filename)
	local lines = {}
	-- read the lines in table 'lines'
	for line in io.lines() do
		table.insert(lines, line)
	end
	return lines
	]]--

	local f = io.open(filename, "r")
	local lines = {}
	local line = ""

	if not f then return nil end

	while true do
		line = f:read("*line")
		if not line then 
			break 
		else
			table.insert(lines, line)
		end
	end
	f:close()

	return lines
end

function line_writer(filename, table_of_tables)
	-- Empty file
	local f = io.open(filename, 'w')
	f:close()

	f = io.open(filename, 'a')
	-- Append each table in CSV format to the file
	for _, v in ipairs(table_of_tables) do
		f:write(toCSV(v))
	end
	f:close()

end


function text_file_reader(filename)
	local f = io.open(filename, 'r')
	local text = f:read("*all")
	f:close()

	return text
end


function text_file_writer(filename, text)
	local f = io.open(filename, 'w')
	f:write(text)
	f:close()
end

