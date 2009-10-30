require "m_monitor"
require "c_monitor_inc"

local t_contacts = { }


function contact (_table)
	table.insert(t_contacts, _table)
end


function select_contacts(clause)
	local select_clause = clause
	t_contacts = { }

	--require "db_contacts"
	dofile ("/usr/local/itvision/model/db/db_contacts.lua")

	return t_contacts
end


function get_contacts(clause)
	contacts = select_contacts("all")
	result = {}

	for i, v in ipairs(contacts) do
		if clause(v)  then
			table.insert(result, v)
		end
	end
	return result
end


function show_contacts(clause)
	clause = clause or "all"

	contacts = get_contacts(clause)

	print ("\n\ncontacts:\n-----------------")
	for i, v in ipairs(contacts) do
		print(i.." : "..v.name)
	end
	print()
end


