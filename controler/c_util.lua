

function table.uniq(table_)
	local res = {}
	local count = 0
	table.sort(table_)
	for i, v in ipairs(table_) do
		if (i == 1) or (v ~= res[count]) then
			table.insert(res, v)
			count = count + 1
		end
	end
	return res
end


-- Used in applic_list.lp !!!
function sort_services(a, b)
        if (a[2] < b[2]) then
                return true
        elseif (a[2] == b[2]) and (a[1] < b[1]) then
                return true
	else
                return false
        end
end


function table.find_entry(table_, entry_, field)
	for i, v in ipairs(table_) do
		if field then
			if v[field] == entry_ then return i end
		else
			if v == entry_ then return i end
		end
	end
	return 0
end



function os.splittime(time_)
	D, H = math.modf( time_ / 24 / 60 / 60 )
	H, M = math.modf(H * 24)
	M, S = math.modf(M * 60)
	S, _ = math.modf(S * 60)

	return D, H, M, S
end


function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end


