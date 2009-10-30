require "m_monitor"
require "c_monitor_inc"

local config = {
	appl_file = 'db_application_state.lua',
	db_dir = '/usr/local/itvision/model/db/',
}

local t_app_state = { }


function application_state (_table)
	table.insert(t_app_state, _table)
end


function select_application_state(clause)
	-- clause object shout be used to select status entries
	local select_clause = clause
	t_app_state = { }

	--require "db_application"
	code = os.execute('ls '..config.db_dir..config.appl_file..' > /dev/null 2>&1')
	if code == 0 then
		dofile (config.db_dir..config.appl_file)
	end

	return t_app_state
end


function get_application_state(gname)
	local app = select_application_state("all")

	for i, v in ipairs(app) do
		if gname == v.name then
			return v
		end
	end
end


function insert_application_state(appl_state_string) 
	os_date = os.date('%Y_%m_%d-%H:%M')

	io.output(config.db_dir..config.appl_file)
	io.write(appl_state_string)
end



