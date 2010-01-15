require "m_monitor"
require "c_monitor_inc"
require "m_io_util"

local t_disableds = { }

local db_name = "/usr/local/itvision/model/db/db_disableds.lua"
local db_name = "../model/db/db_disableds.lua"


function disabled (_table)
	table.insert(t_disableds, _table)
end


function select_disableds(clause)
	local select_clause = clause
	t_disableds = { }

	--require "db_disableds"
	dofile ("/usr/local/itvision/model/db/db_disableds.lua")

	-- db_disables has inly one table with the list of disableds ic's!
	--return t_disableds
	return t_disableds[1]
end


function get_disableds(clause)
	local ret = select_disableds("all")
	result = {}

	for i, v in ipairs(ret) do
		if clause(v)  then
			table.insert(result, v)
		end
	end

	return result
end


function insert_disableds(ic)
	local ret = select_disableds()

	table.insert(ret, ic)

	f = io.open(db_name, 'w')
	f:write("\n\ndisabled {\n\n")
	for _,v in ipairs(ret) do
		f:write('\t"'..v..'",\n')
	end

	f:write("\n}")
	f:close()


end


function is_disableds(ic)
	local ret = select_disableds()
	local result = nil

	for i,v in ipairs(ret) do
		if ic == v then 
			result = i 
			return result
		end
	end

	return result
end


function delete_disableds(ic)
	local ret = select_disableds()

	f = io.open(db_name, 'w')
	f:write("\n\ndisabled {\n\n")
	for _,v in ipairs(ret) do
		if v ~= ic then
			f:write('\t"'..v..'",\n')
		end
	end

	f:write("\n}")
	f:close()


end


function show_disableds(clause)
	clause = clause or "all"

	local ret = get_disableds(clause)

	print ("\n\ndisableds:\n-----------------")
	for i, v in ipairs(ret) do
		print(i.." : "..v.name)
	end
	print()
end



--[[

print("-----------")
ret = select_disableds()
showtable(ret)

print("-----------")
insert_disableds("host ic x")
ret = select_disableds()
showtable(ret)

print("-----------")
delete_disableds("host ic "..arg[1])
ret = select_disableds()
showtable(ret)

]]--


