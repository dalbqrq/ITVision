--[[
This module will be used to deal with the following dbs:

db_ics.lua
db_relations.lua
db_checkcmds.lua
db_procedures.lua

]]--

require 'm_io_util'

function ic_get_label(field_key, key, return_field)
	dofile('/usr/local/itvision/model/db/db_ics.lua')

	for _,v in ipairs(ics) do
		if v[field_key] == key then
			return v[return_field]
		end
	end
	return nil
end

function ic_get_table(field_key, key)
	dofile('/usr/local/itvision/model/db/db_ics.lua')

	for _,v in ipairs(ics) do
		if v[field_key] == key then
			return v
		end
	end
end



