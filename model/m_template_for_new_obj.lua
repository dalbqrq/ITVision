require "m_monitor"
require "c_monitor_inc"

local db_dir = 'db/'

local t_entries = { }



function db_open(db)
	t_entries = { }

	loadstring('function '..db..' (_table) table.insert(t_entries, _table) end')
	dofile (db_dir..db)

	return t_entries
end


function db_select(db, clause)
	local entries = db_open(db)
	result = {}

	for i, v in ipairs(entries) do
		if clause(v)  then
			table.insert(result, v)
		end
	end
	return result
end


function db_insert(appl_state_string) 
	--io.output(config.db_dir..config.appl_file)
	--io.write(appl_state_string)

	return 1
end

